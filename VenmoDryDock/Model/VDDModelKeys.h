typedef NS_ENUM(NSUInteger, VDDAppDistributionType) {
    VDDAppDistributionTypeInternal = 1,
    VDDAppDistributionTypePublic = 2
};

#define VDDModelApp @"VDDModelApp"

#define VDDAppKeyName @"name"
#define VDDAppKeyDescription @"description"
#define VDDAppKeyDetails @"details"
#define VDDAppKeyImage @"image"
#define VDDAppKeyInstallUrl @"install_url"
#define VDDAppKeyShareUrl @"share_url"
#define VDDAppKeyVersionNumber @"version_number"
#define VDDAppKeySharable @"sharable"
#define VDDAppKeyType @"type"


#define VDDModelUser @"VDDModelUser"
#define VDDUserKeyAdvertisingID @"advertising_id"
#define VDDUserKeyPushToken @"push_token"

void createDemoObject();