module shotty.shooters.maim;
import shotty.config;
import std.experimental.logger;
import std.process : execute, ProcessException;

void shoot(string outputFile) {
    // -B is needed here as without it KWin will continually return old window data
    // -u hides the cursor
    // -m 3 is the quality level
    string[] programArgs = ["maim", "-B", "-u", "-m", "3"];

    import std.conv : to;

    programArgs ~= "-f"; 
    programArgs ~= to!string(cmdlineOpts.format);

    if (cmdlineOpts.selection) {
        programArgs ~= "-s";
    }

    programArgs ~= outputFile;
    try {
        debug infof("maim args: %s", programArgs);
        auto maim = execute(programArgs);
        if (maim.status != 0) {
            errorf("'maim' exited with a non-zero status code (%d)", maim.status);
            if (maim.output.length != 0) {
                import std.string : strip;
                errorf("output: %s", maim.output.strip);
            }
        }
    } catch (ProcessException e) {
        errorf("Caught exception while shooting: %s", e.msg);
    }
}
