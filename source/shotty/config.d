module shotty.config;
import shotty.uploaders;
import shotty.utils;
import shotty.shooters;
import std.experimental.logger;
import asdf;

static ShottyCmdConfig cmdlineOpts;
static ShottyConfig config;

enum defaultConfigPath = "~/.shotty.json";

enum ShottyFormats {
    png,
    jpeg
};

struct ShottyCmdConfig {
    bool copyToClipboard; // whether a temp file will be created, and then passed to xclip or whatever
    bool selection; // whether we should have a selection
    bool upload;
    ShottyFormats format; // jpg/png...
    ShottyUploaders uploader;
    ShottyShooters shooter;
    string configFile;
    string outputFile;
}

struct ShottyConfig {
    @serializationKeys("default_folder") string defaultFolder;
    @serializationKeys("uploaders") ShottyUploaderConfig uploaders;
    @serializationKeys("file_schema") string schema;

    void load(string path = defaultConfigPath) {
        import std.file : read, exists, isFile;
        path = path.fullyExpandPath();
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
        write(path.fullyExpandPath(), json);
    }
}



