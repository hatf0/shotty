module shotty.app;
import std.experimental.logger;
import shotty.config;
import shotty.utils;
import shotty.uploaders;
import shotty.shooters;

void main(string[] args) {
    import std.getopt : getopt, defaultGetoptPrinter;

    bool cleanupNeeded; // set if we have a temp file

    try {
        auto opts = getopt(
            args,
            "clipboard|c", "Copy the captured image to the X11 clipboard.", &cmdlineOpts.copyToClipboard,
            "selection|s", "Select a region to capture.", &cmdlineOpts.selection,
            "upload|u", "Upload your screenshot to a cloud service.", &cmdlineOpts.upload,
            "uploader", "Target cloud service to upload your screenshot to.", &cmdlineOpts.uploader,
            "config", "Use a different configuration file (default: ~/.shotty.json)", &cmdlineOpts.configFile,
            "format|f", "Specify a specific format to take the picture in.", &cmdlineOpts.format,
            "shooter", "Specify a different program to take the screenshot with.", &cmdlineOpts.shooter,
            "output|o", "Specify a location for the resulting screenshot.", &cmdlineOpts.outputFile);

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

    import std.path;
    import std.file : tempDir, remove, exists, isDir;

    scope (exit) { 
        if (cleanupNeeded) {
            if (cmdlineOpts.outputFile.exists) cmdlineOpts.outputFile.remove; // clean up after ourselves
        }
    }

    string outFile = cmdlineOpts.outputFile; 
    if (outFile.length == 0) {
        outFile = tempDir.buildPath("shotty_" ~ generateRandomString(20));
        cleanupNeeded = true;
    } else {
        if (outFile.isValidPath() && outFile.exists() && outFile.isDir()) {
            outFile = outFile.fullyExpandPath();
            outFile = outFile.buildPath(generateFileName(config.schema));
        } else {
            // assume they want us to output to a file
            outFile = buildNormalizedPath(outFile.fullyExpandPath());
        }
            
    }

    import std.conv : to;
    cmdlineOpts.outputFile = outFile ~ "." ~ to!string(cmdlineOpts.format);
        
    takeScreenshot(cmdlineOpts.outputFile);

    if (cmdlineOpts.upload) {
        import std.conv : to;
        if (cmdlineOpts.outputFile.exists) {
            uploadToService(cmdlineOpts.outputFile, generateRandomString(10)); 
        }
    } else if (!cmdlineOpts.copyToClipboard) {
        infof("Output saved as %s", cmdlineOpts.outputFile);
    }


}


