module arch.executer.formats;

struct DecodedFormatJ
{
    ubyte opcode;
    uint immX;
}

struct DecodedFormatW
{
    ubyte opcode;
    ubyte regY;
    ushort immX;
    ubyte specZ;
}

struct DecodedFormatO
{
    ubyte opcode;
    ubyte regdY;
    ubyte regZ;
    ubyte regX;
    ushort specV;
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

struct DecodedFormatS
{
    ubyte opcode;
    ubyte regY;
    ubyte regZ;
    ubyte specW;
    ushort immV;
}
struct DecodedFormatT
{
    ubyte opcode;
    ubyte regY;
    ubyte regZ;
    ubyte specW;
    ubyte immV;
}

