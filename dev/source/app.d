import std.stdio;
import schema;
import pegged.grammar;

void main()
{
    writeln("Generating new grammar..");
    asModule("shotty.schema", "../source/shotty/schema", scheme);
}
