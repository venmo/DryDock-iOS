#import "VDDAppDelegate.h"
#import <VENVersionTracker/VENVersionTracker.h>
#import "VDDConstants.h"

@implementation VDDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:VDDParseAppId
                  clientKey:VDDParseClientKey];
    
    [self startTrackingVersion];
    
    return YES;
}


- (void)startTrackingVersion {
    // For details on using VENVersionTracker see -- https://github.com/venmo/VENVersionTracker
    /*
     The URL http://YOUR_BASE_URL/track/YOUR_CHANNEL_NAME should return the following JSON:

     {
        "version":{
            "number":"0.1.0",
            "mandatory":false,
            "install_url":"<<ITMS INSTALL URL>>"
        },
        "min-version-number":0.1.0
     }
     */
    [VENVersionTracker beginTrackingVersionForChannel:VDDChannelName
                                       serviceBaseUrl:VDDBaseUrl
                                         timeInterval:1800
                                          withHandler:^(VENVersionTrackerState state, VENVersion *version) {
                                              dispatch_sync(dispatch_get_main_queue(), ^{
                                                  if (state == VENVersionTrackerStateDeprecated || state == VENVersionTrackerStateOutdated) {
                                                      [version install];
                                                  }
                                              });
                                          }];
}

@end
