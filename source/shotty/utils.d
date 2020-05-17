module shotty.utils;
import shotty.parser;
import std.path : absolutePath, expandTilde;

string fullyExpandPath(string originalPath) {
    string path = originalPath;
    if (originalPath[0] == '~') {
        path = path.expandTilde;
    }
    path = path.absolutePath();
    return path;
}

string generateFileName(string schema) {
    import shotty.schema;
    string output = evaluateGivenSchema(schema);
    if (output.length == 0) {
        output = "shotty_";
    }

    return output;
}

string generateRandomString(size_t count) {
    import std.random : randomSample;
    import std.utf : byCodeUnit;
    import std.conv : to;
    import std.ascii : letters;

    string output = letters.byCodeUnit.randomSample(count).to!string;
    return output;
}


