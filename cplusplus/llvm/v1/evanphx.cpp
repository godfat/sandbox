
// bash -c "g++-mp-4.3 evanphx.cpp -o evanphx -std=c++98 `llvm-config --cxxflags --ldflags --libs`"

#include <llvm/Type.h> // for Type
#include <llvm/Function.h> // for Function
#include <llvm/Module.h> // for Module
#include <llvm/PassManager.h> // for PassManager
#include <llvm/Support/MemoryBuffer.h> // for MemoryBuffer

#include <llvm/Bitcode/ReaderWriter.h> // for ParseBitcodeFile
#include <llvm/DerivedTypes.h> // for PointerType
#include <llvm/Instructions.h> // for CallInst
#include <llvm/Constants.h> // for ConstantInt
#include <llvm/ModuleProvider.h> // for ExistingModuleProvider
#include <llvm/ExecutionEngine/JIT.h> // for ExecutionEngine

#include <llvm/Target/TargetData.h> // for TargetData
#include <llvm/Analysis/Verifier.h> // for createVerifierPass
#include <llvm/Transforms/IPO.h> // for createLowerSetJmpPass
#include <llvm/Transforms/Scalar.h> // for createCFGSimplificationPass

#include <iostream>

using namespace llvm;

Function* create(Module** out) {
  std::string error;
  Module* jit;

  // Load in the bitcode file containing the functions for each
  // bytecode operation.
  if(MemoryBuffer* buffer = MemoryBuffer::getFile("evanphx_ops.o", &error)) {
    jit = ParseBitcodeFile(buffer, &error);
    delete buffer;
  }

  // Pull out references to them.
  Function* set =  jit->getFunction(std::string("set"));
  Function* add =  jit->getFunction(std::string("add"));
  Function* show = jit->getFunction(std::string("show"));

  // Now, begin building our new function, which calls the
  // above functions.
  Function* body = cast<Function>(jit->getOrInsertFunction("body",
        Type::VoidTy,
        PointerType::getUnqual(Type::Int32Ty),
        PointerType::getUnqual(Type::Int32Ty), (Type*)0));

  // Our function will be passed the ops pointer and the
  // registers pointer, just like before.
  Function::arg_iterator args = body->arg_begin();
  Value* ops = args++;
  ops->setName("ops");
  Value* registers = args++;
  registers->setName("registers");

  BasicBlock *bb = BasicBlock::Create("entry", body);

  // Set up our arguments to be passed to set.
  std::vector<Value*> params;
  params.push_back(ops);
  params.push_back(registers);

  // Call out to set, passing ops and registers down
  CallInst* call = CallInst::Create(set, params.begin(), params.end(), "", bb);
  ConstantInt* const_3 = ConstantInt::get(APInt(32,  "3", 10));
  ConstantInt* const_4 = ConstantInt::get(APInt(32,  "4", 10));

  // add 3 to the ops pointer.
  GetElementPtrInst* ptr1 = GetElementPtrInst::Create(ops, const_3, "tmp3", bb);

  // Setup and call add, notice we pass down the updated ops pointer
  // rather than the original, so that we've moved down.
  std::vector<Value*> params2;
  params2.push_back(ptr1);
  params2.push_back(registers);
  CallInst* call2 = CallInst::Create(add, params2.begin(), params2.end(), "", bb);

  // Push the ops pointer down another 4.
  // GetElementPtrInst* ptr2 = GetElementPtrInst::Create(ops, const_4, "tmp3", bb);
  GetElementPtrInst* ptr2 = GetElementPtrInst::Create(ptr1, const_4, "tmp3", bb);

  // Setup and call show.
  std::vector<Value*> params3;
  params3.push_back(ptr2);
  params3.push_back(registers);
  CallInst* call3 = CallInst::Create(show, params3.begin(), params3.end(), "", bb);

  // And we're done!
  ReturnInst::Create(bb);

  *out = jit;
  return body;
}

int main() {
  // The registers.
  int registers[2] = {0, 0};

  // Our program.
  int program[20] = {0, 0, 3,
                     1, 0, 0, 4,
                     2, 0};

  int* ops = (int*)program;

  // Create our function and give us the Module and Function back.
  Module* jit;
  Function* func = create(&jit);

  // Add in optimizations. These were taken from a list that 'opt', LLVMs optimization tool, uses.
  PassManager p;

  /* Comment out optimize
  p.add(new TargetData(jit));
  p.add(createVerifierPass());
  p.add(createLowerSetJmpPass());
  p.add(createRaiseAllocationsPass());
  p.add(createCFGSimplificationPass());
  p.add(createPromoteMemoryToRegisterPass());
  p.add(createGlobalOptimizerPass());
  p.add(createGlobalDCEPass());
  p.add(createFunctionInliningPass());
  */

  // Run these optimizations on our Module
  p.run(*jit);

  // Setup for JIT
  ExistingModuleProvider* mp = new ExistingModuleProvider(jit);
  ExecutionEngine* engine = ExecutionEngine::create(mp);

  // Show us what we've created!
  std::cout << "Created\n" << *jit;

  // Have our function JIT'd into machine code and return. We cast it to a particular C function pointer signature so we can call in nicely.
  void (*fp)(int*, int*) = (void (*)(int*, int*))engine->getPointerToFunction(func);

  // Call what we've created!
  fp(ops, registers);
}
