module shotty.utils;

string generateRandomString(size_t letters) {
    import std.random : randomSample;
    import std.utf : byCodeUnit;
    import std.conv : to;
    import std.ascii : letters;

    string output = letters.byCodeUnit.randomSample(20).to!string;
    return output;
}


