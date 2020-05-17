module shotty.parser;
import shotty.schema;
import std.experimental.logger;

enum RandomTypes {
    Hex = "x",
    Alpha = "a",
    Number = "n",
};


T extractValue(T)(ParseTree tree) {
    T ret;
    ParseTree current = tree;
    while (current.name != "ShottySchema.Value") {
        if (current.children.length == 0) {
            assert(0, "dead end");
        }
        current = current.children[0];
    }

    import std.conv;

    ret = to!T(current.children[0].matches[0]); 

    return ret;
}

string generateRandom(ParseTree tree) {
    if (tree.name != "ShottySchema.Random") {
        return "";
    }

    if (tree.children.length != 2) {
        return "";
    }

    import std.traits;
    ParseTree type = tree.children[0].children[0];
    int count = extractValue!int(tree.children[1]);

    import std.conv : to;
    static foreach(member; EnumMembers!RandomTypes) {
        if (type.matches[0] == member) {
            mixin("return generateRandom" ~ to!string(member) ~ "(count);");
        }

    }

    assert(0, "Invalid type given");
}
import std.random : randomSample;
import std.utf : byCodeUnit;
import std.conv : to;
import std.ascii;

string generateRandomHex(size_t count) {
    string output = lowerHexDigits.byCodeUnit.randomSample(count).to!string;
    return output;
}
string generateRandomNumber(size_t count) {
    string output = std.ascii.digits.byCodeUnit.randomSample(count).to!string;
    return output;
}
string generateRandomAlpha(size_t count) {
    string output = std.ascii.letters.byCodeUnit.randomSample(count).to!string;
    return output;
}

string evaluateGivenSchema(string schema) {
    import std.array : appender;
    auto o = appender!string;
    auto tree = ShottySchema(schema);

    debug infof("%s", tree.toString());
    foreach (_entry; tree.children[0].children) {
        auto entry = _entry.children[0]; // wrapped by an Entry object, get the ACTUAL one

        debug infof("%s", entry.name);
        if (entry.name == "ShottySchema.ConstStr") {
            o ~= extractValue!string(entry);
        } else if (entry.name == "ShottySchema.Random") {
            o ~= generateRandom(entry);
        }

    }

    return o.data;
}
