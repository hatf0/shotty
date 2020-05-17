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

import std.process : execute, spawnProcess, pipeProcess, kill, wait, Redirect;
bool xclipPresent() {
    try {
        auto xclip = execute(["xclip", "-h"]);
    } catch (Exception e) {
        return false;
    }

    return true;
}

/* depends on xclip being present */
void pasteClipboard(string input) {
    if (!xclipPresent) return;
    auto xclip = pipeProcess(["xclip", "-selection", "clipboard"], Redirect.stdin);
    xclip.stdin.write(input);
    xclip.stdin.close();
    wait(xclip.pid);
}

void pasteImageClipboard(string path, string mimeType) {
    if (!xclipPresent) return;
    auto xclip = spawnProcess(["xclip", "-selection", "clipboard", "-t", mimeType, path]);
    wait(xclip);
}


