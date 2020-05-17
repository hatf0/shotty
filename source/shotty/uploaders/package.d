module shotty.uploaders;
import shotty.config;
import asdf;
import std.traits;
import std.conv : to;

static foreach(member; EnumMembers!ShottyUploaders) {
    mixin("public import shotty.uploaders." ~ to!string(member) ~ ";");
}

enum ShottyUploaders {
    azure,
    imgur
};

/* custom uploaders will extend on this */
import std.string : capitalize;
struct ShottyUploaderConfig {
    static foreach(member; EnumMembers!ShottyUploaders) {
        mixin("@serializationKeys(\"" ~ to!string(member) ~"\") @serializationIgnoreDefault Shotty" ~ to!string(member).capitalize ~ "Config " ~ to!string(member) ~ ";");
    }
}

void uploadToService(string uploadPath, string remotePath) {
    switch (cmdlineOpts.uploader) {
        static foreach(member; EnumMembers!ShottyUploaders) {
            case member:
                mixin("import shotty.uploaders." ~ to!string(member) ~ ";");
                with (mixin("shotty.uploaders." ~ to!string(member))) {
                    uploadFile(uploadPath, remotePath);
                }
                return;
        }
        default: assert(0, "Unknown uploader");
    }
}
