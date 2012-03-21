
#include "ruby.h"

int eval_to_int(char const*const str){
  return rb_num2int(rb_eval_string(str));
}
