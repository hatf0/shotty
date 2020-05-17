module shotty.app;
import shotty.config;
import shotty.uploader;
import shotty.shooter;

void main(string[] args) {
    import std.getopt : getopt, defaultGetoptPrinter;

    auto opts = getopt(
        args,
        "clipboard|c", "Copy the captured image to the X11 clipboard.", &cmdlineOpts.copyToClipboard,
        "selection|s", "Select a region to capture.", &cmdlineOpts.selection,
        "upload|u", "Upload your screenshot to a cloud service.", &cmdlineOpts.upload,
        "uploader", "Target cloud service to upload your screenshot to.", &cmdlineOpts.uploader,
        "config", "Use a different configuration file (default: ~/.shotty.json)", &cmdlineOpts.configFile);

    if (opts.helpWanted) {
        defaultGetoptPrinter("shotty: a lightweight screenshot wrapper",
            opts.options);
        return;
    }

    // Load our config
    if (cmdlineOpts.configFile.length == 0) {
        cmdlineOpts.configFile = defaultConfigPath;
    }

    config.load(cmdlineOpts.configFile);  
}


