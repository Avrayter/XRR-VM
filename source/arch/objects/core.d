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

struct CpuCore
{
   size_t[size_t.sizeof*4 - 1] registers;
    
}

struct MMU
{
    
}