module shotty.app;
import std.experimental.logger;
import shotty.config;
import shotty.utils;
import shotty.uploaders;
import shotty.shooters;

void main(string[] args) {
    import std.getopt : getopt, defaultGetoptPrinter;

    try {
        auto opts = getopt(
            args,
            "clipboard|c", "Copy the captured image to the X11 clipboard.", &cmdlineOpts.copyToClipboard,
            "selection|s", "Select a region to capture.", &cmdlineOpts.selection,
            "upload|u", "Upload your screenshot to a cloud service.", &cmdlineOpts.upload,
            "uploader", "Target cloud service to upload your screenshot to.", &cmdlineOpts.uploader,
            "config", "Use a different configuration file (default: ~/.shotty.json)", &cmdlineOpts.configFile,
            "format|f", "Specify a specific format to take the picture in.", &cmdlineOpts.format);

        if (opts.helpWanted) {
            defaultGetoptPrinter("shotty: a lightweight screenshot wrapper",
                opts.options);
            return;
        }
    } catch (Exception e) {
        errorf("Caught exception while parsing arguments: %s", e.msg);
        return;
    }
    // Load our config (if it's not specified at commandline, use the default hard-coded path)
    if (cmdlineOpts.configFile.length == 0) {
        cmdlineOpts.configFile = defaultConfigPath;
    }
    config.load(cmdlineOpts.configFile);  

    import std.path : buildPath;
    import std.file : tempDir, remove, exists;

    auto tempFile = tempDir.buildPath("shotty_" ~ generateRandomString(20));
    scope (exit) { 
        if (tempFile.exists) tempFile.remove; // clean up after ourselves
    }
}


