
#include <iostream>
#include <fstream>
#include <iterator>
#include <string>
#include <boost/wave.hpp>
#include <boost/wave/cpp_iteration_context.hpp>
#include <boost/wave/cpplexer/cpp_lex_token.hpp>
#include <boost/wave/cpplexer/cpp_lex_iterator.hpp>

int main(){
    // The following preprocesses a given input file.
    // Open the file and read it into a string variable
    std::ifstream instream("wave.cpp");
    std::string input(
        std::istreambuf_iterator<char>(instream.rdbuf()),
        std::istreambuf_iterator<char>());

    // The template boost::wave::cpplexer::lex_token<> is the  
    // token type to be used by the Wave library.
    // This token type is one of the central types throughout 
    // the library, because it is a template parameter to some 
    // of the public classes and templates and it is returned 
    // from the iterators.
    // The template boost::wave::cpplexer::lex_iterator<> is
    // the lexer iterator to use as the token source for the
    // preprocessing engine. In this case this is parametrized
    // with the token type.
    typedef boost::wave::cpplexer::lex_iterator<
            boost::wave::cpplexer::lex_token<> >
        lex_iterator_type;
    typedef boost::wave::context<
            std::string::iterator, lex_iterator_type>
        context_type;

    context_type ctx(input.begin(), input.end(), "wave.cpp");

    // At this point you may want to set the parameters of the
    // preprocessing as include paths and/or predefined macros.
    // ctx.add_include_path("...");
    // ctx.add_macro_definition(...);

    // Get the preprocessor iterators and use them to generate 
    // the token sequence.
    context_type::iterator_type first = ctx.begin();
    context_type::iterator_type last = ctx.end();

    // The input stream is preprocessed for you during iteration
    // over [first, last)
    while (first != last) {
        std::cout << (*first).get_value();
        ++first;
    }
}
