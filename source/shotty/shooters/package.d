module shotty.shooters;
import shotty.config;
import asdf;
import std.traits;
import std.conv : to;

static foreach(member; EnumMembers!ShottyShooters) {
    mixin("public import shotty.shooters." ~ to!string(member) ~ ";");
}

enum ShottyShooters {
    maim
};

void takeScreenshot(string outputFile) {
    switch (cmdlineOpts.shooter) {
        static foreach(member; EnumMembers!ShottyShooters) {
            case member:
                mixin("import shotty.shooters." ~ to!string(member) ~ ";");
                with (mixin("shotty.shooters." ~ to!string(member))) {
                    shoot(outputFile);
                }
                return;
        }
        default: assert(0, "Unexpected shooter");
    }
}
