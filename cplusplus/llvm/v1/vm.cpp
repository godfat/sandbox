
// llvm-config --cxxflags --ldflags --libs | tr "\n" " " | tr -s " " | xargs g++ vm.cpp -o vm -O3 -std=c++98
// ruby program.rb | ./vm

#include <llvm/Type.h> // for Type
#include <llvm/Function.h> // for Function
#include <llvm/Module.h> // for Module
#include <llvm/PassManager.h> // for PassManager
#include <llvm/Support/MemoryBuffer.h> // for MemoryBuffer

#include <llvm/Bitcode/ReaderWriter.h> // for ParseBitcodeFile
#include <llvm/DerivedTypes.h> // for PointerType
#include <llvm/Instructions.h> // for CallInst
#include <llvm/Constants.h> // for ConstantInt
// #include <llvm/ModuleProvider.h> // for ExistingModuleProvider
#include <llvm/ExecutionEngine/JIT.h> // for ExecutionEngine

#include <llvm/Target/TargetData.h> // for TargetData
#include <llvm/Analysis/Verifier.h> // for createVerifierPass
#include <llvm/Transforms/IPO.h> // for createLowerSetJmpPass
#include <llvm/Transforms/Scalar.h> // for createCFGSimplificationPass

#include <boost/lexical_cast.hpp>

#include <string>
#include <vector>
#include <iostream>

using namespace llvm;

Module* load(){
    std::string error;
    Module* jit = 0;

    // Load in the bitcode file containing the functions for each
    // bytecode operation.
    if(MemoryBuffer* buffer = MemoryBuffer::getFile("ops.o", &error)){
        jit = ParseBitcodeFile(buffer, &error);
        delete buffer;
    }
    return jit;
}

Function* init_main(Module* jit, std::vector<Value*>& params){
    // Now, begin building our new function, which calls the
    // above functions.
    Function* main = cast<Function>(jit->getOrInsertFunction("main",
        Type::VoidTy,
        PointerType::getUnqual(Type::Int32Ty),
        PointerType::getUnqual(Type::Int32Ty),
        static_cast<Type*>(0)));

    // Our function will be passed the ops pointer and the
    // registers pointer, just like before.
    Function::arg_iterator args = main->arg_begin();
    Value* registers = args++;
    registers->setName("registers");
    Value* ops = args++;
    ops->setName("ops");

    // Set up our arguments to be passed to set.
    params.push_back(registers);
    params.push_back(ops);

    return main;
}

Module* compile(std::vector<int> ops){
    using boost::lexical_cast;

    Module* jit = load();
    if( !jit ) return 0;

    // Pull out references to them.
    Function* set  = jit->getFunction("set");
    Function* add  = jit->getFunction("add");
    Function* show = jit->getFunction("show");

    std::vector<Value*> params;
    Function* main = init_main(jit, params);

    BasicBlock* bb = BasicBlock::Create("entry", main);

    for(int i = 0, step = 0; i < ops.size(); i += step){
        // Setup and call add, notice we pass down the updated ops pointer
        // rather than the original, so that we've moved down.
        GetElementPtrInst* ptr;
        CallInst* call;
        ConstantInt* const_n;

        if(step != 0){
            const_n = ConstantInt::get(APInt(32, lexical_cast<std::string>(step), 10));
            ptr = GetElementPtrInst::Create(params.back(), const_n, "tmp", bb);
            params.pop_back(); params.push_back(ptr);
        }

        switch(ops[i]){
            case 0:
                // Call out to set, passing ops and registers down
                call = CallInst::Create(set, params.begin(), params.end(), "", bb);
                // add 3 to the ops pointer.
                step = 3;
                break;

            case 1:
                call = CallInst::Create(add, params.begin(), params.end(), "", bb);
                // Push the ops pointer down another 4.
                step = 4;
                break;

            case 2:
                call = CallInst::Create(show, params.begin(), params.end(), "", bb);
                step = 2;
                break;
        }
    }

    // And we're done!
    ReturnInst::Create(bb);

    return jit;
}



int main(int argc, char* argv[]){
    // The registers.
    int registers[] = {0, 0};

    // Our program.
    // int program[] = { 0, 0, 5,
    //                   1, 0, 0, 4,
    //                   2, 0 };

    std::string program;
    getline(std::cin, program);
    std::vector<int> ops(program.begin(), program.end());

    // Create our function and give us the Module and Function back.
    Module* jit = compile(ops);

    // Add in optimizations. These were taken from a list that 'opt', LLVMs optimization tool, uses.
    PassManager p;

    // Comment out optimize
    if( argc > 1 && std::string(argv[1]) == "-O" ){
        p.add(new TargetData(jit));
        p.add(createVerifierPass());
        p.add(createLowerSetJmpPass());
        p.add(createRaiseAllocationsPass());
        p.add(createCFGSimplificationPass());
        p.add(createPromoteMemoryToRegisterPass());
        p.add(createGlobalOptimizerPass());
        p.add(createGlobalDCEPass());
        p.add(createFunctionInliningPass());
    }

    // Run these optimizations on our Module
    p.run(*jit);

    // Setup for JIT
    ExistingModuleProvider* mp = new ExistingModuleProvider(jit);
    ExecutionEngine* engine = ExecutionEngine::create(mp);

    // Show us what we've created!
    std::cout << "Created\n" << *(jit->getFunction("main"));

    // Have our function JIT'd into machine code and return. We cast it to a particular C function pointer signature so we can call in nicely.
    Function* func = jit->getFunction("main");
    void (*fp)(int*, int const*) =
        reinterpret_cast<void (*)(int*, int const*)>(engine->getPointerToFunction(func));

    // Call what we've created!
    fp(registers, &*ops.begin());
}
