module shotty.uploaders.azure;
import std.experimental.logger;
import asdf;

enum AzureAPIVersion = "2016-05-31";

struct ShottyAzureConfig {
    @serializationKeys("account_name")
    @serializationIgnoreDefault
        string accountName;
    @serializationKeys("access_key") 
    @serializationIgnoreDefault
        string accessKey;
    @serializationKeys("container")
    @serializationIgnoreDefault
        string container;
    @serializationKeys("environment") 
    @serializationIgnoreDefault
        string environment;
    @serializationKeys("custom_domain")
    @serializationIgnoreDefault
        string customDomain;
    @serializationKeys("upload_path")
    @serializationIgnoreDefault
        string uploadPath;
}
import std.format;

string signRequest(string canoHeaders, string canoResource, string contentLength, string contentType) {
    import shotty.config;
    ShottyAzureConfig cfg = config.uploaders.azure;
    import std.digest.sha : SHA256;
    import std.digest.hmac : hmac;
    import std.base64 : Base64;
    import std.string : representation;
    import std.utf : toUTF8;
    string request = format!
"PUT
\n
%s\n
%s\n
\n
\n
%s\n%s"(contentLength, contentType, canoHeaders, canoResource);

    return Base64.encode(request.toUTF8
                                .representation
                                .hmac!SHA256(Base64.decode(cfg.accessKey)));
}


/* Sun, 17 May 2020 07:47:07 GMT */
import std.net.curl;
import std.file;
string uploadFile(string path, string file_name) {
    if (!path.exists()) return "";
    if (!path.isFile()) return "";
    import shotty.config;
    ShottyAzureConfig cfg = config.uploaders.azure;
    if (cfg.accountName == "") {
        error("AccountName cannot be empty");
        return "";
    }
    if (cfg.accessKey == "") {
        error("Access Key cannot be empty");
        return "";
    }
    if (cfg.container == "") {
        error("Container cannot be empty");
        return "";
    }

    if (cfg.environment == "") cfg.environment = "blob.core.windows.net";

    import std.datetime.systime : SysTime, Clock;
    import std.string;
    import std.conv : to;
    string uploadPath = cfg.uploadPath ~ file_name;
    SysTime currentTime = Clock.currTime().toUTC();
    auto client = HTTP();
    client.method = HTTP.Method.put;
    string date = format!"%s, %.2d %s %.4d %.2d:%.2d:%.2d GMT"(
                currentTime.dayOfWeek.to!string.capitalize,
                currentTime.day,
                currentTime.month.to!string.capitalize,
                currentTime.year,
                currentTime.hour,
                currentTime.minute,
                currentTime.second
            );

    size_t length = getSize(path);

    client.clearRequestHeaders();
    client.addRequestHeader("x-ms-blob-type", "BlockBlob");
    client.addRequestHeader("x-ms-date", date);
    client.addRequestHeader("x-ms-version", AzureAPIVersion);
    client.addRequestHeader("x-ms-content-length", length.to!string);
    string mime = cmdlineOpts.format == ShottyFormats.png ? "image/png" : "image/jpeg"; 
    client.addRequestHeader("Content-Type", mime);
    client.contentLength = length;

    string canoHeaders = format!"\nx-ms-blob-type:BlockBlob\nx-ms-content-length:%d\nx-ms-date:%s\nx-ms-version:%s"(length, date, AzureAPIVersion);
    string canoResource = format!"/%s/%s/%s"(cfg.accountName, cfg.container, uploadPath);
    string signedString = signRequest(canoHeaders, canoResource, length.to!string, mime); 
    client.addRequestHeader("Authorization", "SharedKey " ~ cfg.accountName ~ ":" ~ signedString);
    string requestUrl = format!"https://%s.%s/%s/%s"(cfg.accountName, cfg.environment, cfg.container, uploadPath);

    try { 
        auto content = put(requestUrl, cast(ubyte[])read(path), client);
    } catch (Exception e) {
        return "";
    }

    if (cfg.customDomain.length != 0) {
        return cfg.customDomain ~ "/" ~ uploadPath;
    } else {
        return requestUrl;
    }
}
