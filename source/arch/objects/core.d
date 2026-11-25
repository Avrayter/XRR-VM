module arch.objects.core32;

import arch.objects.systembus;
import arch.objects.insoutcome;
import core.stdc.stdlib: malloc, free;
struct Cpu
{
    bool isfaulty = false;
    const ushort coreCount;
    ArraySlice!CpuCore cores;
    this(ushort corecount){
        this.coreCount = corecount;
        this.cores.ptr = cast(CpuCore*) malloc(coreCount * CpuCore.sizeof);
        if(this.cores.ptr is null){
            this.isfaulty = true;
            free(this.cores.ptr);
        }
        this.cores.length = coreCount;
    }
}

struct XrrlDevice
{

    Cpu cpu;
    SystemBus sysBus;
}

const enum ulong r0 = 0;

struct CpuCore
{
    size_t[size_t.sizeof*4 - 1] registers;
    size_t getregval(ubyte index){
        if(index == 0) return 0;
        return registers[index - 1];
    }
    void writeregval(ubyte index, size_t val){
        if(index == 0) return;
        registers[index - 1] = val;
    }
   size_t pc;
}



struct MMU
{
    
}