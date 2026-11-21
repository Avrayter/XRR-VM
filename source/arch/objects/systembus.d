module arch.objects.systembus;
import arch.objects.insoutcome;
import core.stdc.stdlib: malloc, free;
import core.stdc.stdio;
@nogc:
//memory allocation or whatever

private struct ReadResult(ubyte readCount)
{
    InstructionOutcome i;
    ubyte[readCount] bytes;
    size_t bytesToUll(){
        return *(cast(size_t*) &bytes);
    }
}

struct SystemBus
{
    bool isfaulty = false;
    size_t memorysize;
    ReadResult!(size_t.sizeof)  function(ref SystemBus,size_t) readAddr;
    InstructionOutcome function(ref SystemBus, size_t, size_t) writeAddr;
    ArraySlice!ubyte memoryPool;
    @nogc this
    (
        ReadResult!(size_t.sizeof)  function(ref SystemBus,size_t) read, 
        InstructionOutcome function(ref SystemBus, size_t, size_t) write,
        size_t memSize
    )
    {
        //allocate real memory at runtime to the virtual memory pool
        this.memorysize = memSize;
        this.memoryPool.ptr = cast(ubyte*) malloc(memSize);
        if(this.memoryPool.ptr is null){
            this.isfaulty = true;
            free(this.memoryPool.ptr);
        }
        this.memoryPool.length = memSize;
    }
}

struct MmioController
{

}

/+basic example with only memory and no mmu, vga buffer, etc.+/

//SystemBus lazyBus = SystemBus(&lazyRead, &lazyWrite, 500_000);

unittest
{
    SystemBus lazyBus = SystemBus(&lazyRead, &lazyWrite, 500_000);
    InstructionOutcome i = lazyBus.lazyWrite(356, 0x05);
    ReadResult!(size_t.sizeof) bts = lazyBus.lazyRead(356);
    printf("%llu is the same as %llu\n",bts.bytesToUll(), 0x05);
    InstructionOutcome j = lazyBus.lazyWrite(499_991, 0xFFFFFFFFFFFFFFFF);
    printf("%llu is the same as %llu, statID is %u\n",lazyBus.lazyRead(499_991).bytesToUll(),
     0xFFFFFFFFFFFFFFFF, j.statusID);
    InstructionOutcome k =  lazyBus.lazyWrite(499_999, 0x0000000000);
    printf("%llu\n", cast(ulong) k.statusID);
}

/+
works in this way:
takes the adress, 
casts the pointer of the base of the memory pool in the systembus plus accessedAdress to ubyte[size_t.sizeof],
deferencing that if safe, returns it and zero as the statusID if successful, and 1 if unsuccesful.
+/

ReadResult!(size_t.sizeof) lazyRead(ref SystemBus sb, size_t accessedAddress){
    ubyte[size_t.sizeof]* returnResultPtr;
    ubyte[size_t.sizeof] toBeReturned;
    if(accessedAddress + size_t.sizeof >= sb.memoryPool.length){
        return ReadResult!(size_t.sizeof)(InstructionOutcome(1), toBeReturned);
    } 
    else
    {
        returnResultPtr = cast(ubyte[8]*) (sb.memoryPool.ptr + accessedAddress);
        printf("If you see a message immediately after this there is a bug in the read func\n");
        toBeReturned = *returnResultPtr;
        printf("you should see this if no segfault\n");
        return ReadResult!(size_t.sizeof)(InstructionOutcome(0), toBeReturned);
    }
}

//writes lazily
InstructionOutcome lazyWrite(ref SystemBus sb, size_t addressWrittenTo, size_t bytesToWrite)
{
    if(addressWrittenTo + size_t.sizeof >= sb.memoryPool.length) return InstructionOutcome(1);
    printf("If you see a message immediately after this there is a bug in the write func\n");
    *(cast(size_t *)(sb.memoryPool.ptr + addressWrittenTo)) = bytesToWrite;
    printf("you should see this if no segfault\n");
    return InstructionOutcome(0);
}



