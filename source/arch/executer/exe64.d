module arch.executer.exe64;
import formats;
import arch.objects.systembus;
import arch.objects.insoutcome;
import arch.objects.core;

enum Format[ubyte] formatPerOpcode = 
[
    0x02: FMT_J, 
    0x03: FMT_W,
    0x04: FMT_W, 
    0x05: FMT_W, 
    0x06: FMT_W, 
    0x07: FMT_S, 
    0x08: FMT_O, 
    0x09: FMT_W,
    0x0a: FMT_W,
    0x0b: FMT_W,
    0x0b: FMT_W,
    0x0c: FMT_W,
    0x0d: FMT_W,
];

InstructionOutcome executeInstruction(ref SystemBus systemBus, ref Cpu cpu, ushort cpuCoreId, uint instruction)
{
    ubyte opcode = cast(ubyte) instruction;
    Format* fptr = opcode in formatPerOpcode;
    if(fptr is null) return InstructionOutcome(2);
}

InstructionOutcome iJmp(ref Cpu cpu, ushort cpuCoreID, ushort immX){
    if(cpuCoreId >= cpu.core.length) return InstructionOutcome(3);
    cpu.cores[cpuCoreID].pc += 2 * ( cast (int) cast (short) immX);
    return InstructionOutcome(0);
}

InstructionOutcome iJrnzJrz(ref Cpu cpu, ushort cpuCoreId, DecodedFormatW dw){
    if(cpuCoreId >= cpu.core.length) return InstructionOutcome(3);
    cpu.cores[cpuCoreId].pc = cpu.cores[cpuCoreId].pc + 
    ((regY == 0) == (regZ == 0))? 0 : 2 * cast(int) cast(short) dw.immX;
    return InstructionOutcome(0);
}

InstructionOutcome iWtbWtbc(ref Cpu cpu, ushort cpuCoreID, DecodedFormatW dw){
    if(cpuCoreId >= cpu.core.length) return InstructionOutcome(3);
    ryVal = cpu[cpuCoreID].getregval(dw.regY);
    if((dw.specZ << 2) == 0)
    {
        ryVal = 0;
    }
    dw.specZ &= 0x3;
    ushort* loc = &ryVal;
    loc += 2* dw.specZ;
    *loc = immX;
    cpu[cpuCoreID].writeregval(dw.regY, ryVal);
    return InstructionOutcome(0);
}

InstructionOutcome i0x06(ref Cpu cpu, ushort cpuCoreID, DecodedFormatW dw){
    if(cpuCoreId >= cpu.core.length) return InstructionOutcome(3);
    size_t ryVal = cpu[cpuCoreID].getregval(dw.regY);
    switch(dw.specZ){
        case 0:
            ryVal += dw.immX;
            break;
        case 1:
            ryVal -= dw.immX;
            break;
        case 2:
            ryVal >>= cast (short) dw.immX;
        case 3:
            ryVal >>>= cast (short) dw.immX;
        case 4: 
            ryVal &= cast(size_t) dw.immX;
        case 5: 
            ryVal |= cast(size_t) dw.immX;
        case 6: 
            ryVal ^= cast(size_t) dw.immX;
        case 7: 
            ryVal *= cast(short) dw.immX;
        default:
            assert(0);
    }
    return ryVal;
}