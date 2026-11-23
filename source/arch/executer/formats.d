module arch.executer.formats;

struct DecodedFormatJ
{
    ubyte opcode;
    uint immX;
}

DecodedFormatJ decodeJ(unit ins){
    DecodedFormatJ dj;
    dj.opcode = cast (ubyte) ins & 0x000000FF;
    dj.immX = (ins & 0xFFFFFF00) << 8;
    return dj;
}

struct DecodedFormatW
{
    ubyte opcode;
    ubyte regY;
    ushort immX;
    ubyte specZ;
}

DecodedFormatW decodeW(unit ins){
    DecodedFormatW dw;
    dw.opcode = cast (ubyte) ins & 0x000000FF;
    dw.regY = cast (ubyte) ((ins & 0x00001F00) << 8);
    dw.immX = cast (ushort) ((ins & 0x1FFFE000) << 13);
    dw.specZ = cast (ubyte) ((ins & 0xE0000000) << 29);
    return dw;
}

struct DecodedFormatO
{
    ubyte opcode;
    ubyte regdY;
    ubyte regZ;
    ubyte regX;
    ubyte specV;
    ubyte specW;
}

DecodedFormatO decodeO(uint ins){
    DecodedFormatO dw;
    dw.opcode = cast (ubyte) ins & 0x000000FF;
    dw.regY = cast (ubyte) ((ins & 0x00001F00) << 8);
    dw.regZ = cast (ubyte) ((ins & 0x0003E000) << 13);
    dw.regX = cast (ubyte) ((ins & 0x007C0000) << 18);
    dw.specV = cast (ubyte) ((ins & 0x0F800000) << 23);
    dw.specW = cast (ubyte) ((ins & 0xF0000000) << 28);
    return dw;
}

struct DecodedFormatP
{
    ubyte opcode;
    ubyte regdY;
    ubyte regZ;
    ubyte regX;
    ubyte specV;
    ubyte immI;
}

DecodedFormatP decodeP(uint ins){
    DecodedFormatP dp;
    dp.opcode = cast (ubyte) ins & 0x000000FF;
    dp.regY = cast (ubyte) ((ins & 0x00001F00) << 8);
    dp.regZ = cast (ubyte) ((ins & 0x0003E000) << 13);
    dp.regX = cast (ubyte) ((ins & 0x007C0000) << 18);
    dp.specV = cast (ubyte) ((ins & 0x03800000) << 23);
    dp.immI = cast (ubyte) ((ins & 0xFC000000) << 28);
    return dp;
}

struct DecodedFormatS
{
    ubyte opcode;
    ubyte regY;
    ubyte regZ;
    ushort immV;
    ubyte specW;
}

DecodedFormatS decodeS(uint ins){
    DecodedFormatS ds;
    ds.opcode = cast (ubyte) ins & 0x000000FF;
    ds.regY = cast (ubyte) ((ins & 0x00001F00) << 8);
    ds.regZ = cast (ubyte) ((ins & 0x0003E000) << 13);
    ds.immV = cast (ushort) ((ins & 0x0FFC0000) << 13);
    ds.specW = cast (ubyte) ((ins & 0xF0000000) << 28);
}

struct DecodedFormatT
{
    ubyte opcode;
    ubyte regY;
    ubyte regZ;
    ubyte immV;
    ubyte specW;
    ubyte specU;

}

DecodedFormatT decodeT(uint ins){
    DecodedFormatT dt;
    dt.opcode = cast (ubyte) ins & 0x000000FF;
    dt.regY = cast (ubyte) ((ins & 0x00001F00) << 8);
    dt.regZ = cast (ubyte) ((ins & 0x0003E000) << 13);
    dt.immV = cast (ubyte)((ins & 0x00FC0000) << 18);
    dt.specW = cast (ubyte)((ins & 0x0F000000) << 24);
    dt.specU = cast (ubyte)((ins & 0xF0000000) << 28);
    return dt;
}

