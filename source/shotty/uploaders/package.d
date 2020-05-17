module shotty.uploaders;
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
        mixin("@serializationKeys(\"" ~ to!string(member) ~"\") Shotty" ~ to!string(member).capitalize ~ "Config " ~ to!string(member) ~ ";");
    }
}
