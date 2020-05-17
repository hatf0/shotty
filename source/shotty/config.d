module shotty.config;
import shotty.uploaders;
import std.experimental.logger;
import std.path : absolutePath, expandTilde;
import asdf;

static ShottyCmdConfig cmdlineOpts;
static ShottyConfig config;

enum defaultConfigPath = "~/.shotty.json";

struct ShottyCmdConfig {
    bool copyToClipboard; // whether a temp file will be created, and then passed to xclip or whatever
    bool selection; // whether we should have a selection
    bool upload;
    string uploader;
    string configFile;
}

struct ShottyConfig {
    @serializationKeys("uploaders") ShottyUploaderConfig uploaders;
    @serializationKeys("url_schema") string schema = "%ra{10}";

    void load(string path = defaultConfigPath) {
        import std.file : read, exists, isFile;

        if (path[0 .. 2] == "~/") {
            path = path.expandTilde();
        }
        path = path.absolutePath();

        if (!exists(path)) {
            infof("Config file at %s doesn't exist.. creating new config", path);
            config.save(path);
            return;
        }

        if (!isFile(path)) {
            errorf("Config file \"%s\" was not readable as it's not a file...", path);
            return;
        }

        string json = cast(string)read(path);

        try {
            this = json.deserialize!ShottyConfig();
        } catch (AsdfException e) {
            errorf("Failed to deserialize config \"%s\"... using blank config", path);
        }
    }
    
    void save(string path = defaultConfigPath) {
        import std.file : write;
        string json = this.serializeToJsonPretty();
        if (path[0 .. 2] == "~/") {
            path = path.expandTilde();
        }

        write(path.absolutePath(), json);
    }
}



