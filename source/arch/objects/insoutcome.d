module arch.objects.insoutcome;
//instruction outcome

import std.sumtype;

struct InstructionOutcome
{
    ubyte statusID;
}


struct ArraySlice(T){
    T *ptr;
    size_t length;
    T at(size_t loc){
        return *(ptr+loc);
    }
}