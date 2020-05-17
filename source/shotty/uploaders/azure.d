module shotty.uploaders.azure;
import asdf;

static ShottyAzureConfig azureConfig;

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

