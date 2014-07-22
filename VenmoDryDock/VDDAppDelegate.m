// VDDAppDelegate.m
//
// Copyright (c) 2014 Venmo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VDDAppDelegate.h"
#import <VENVersionTracker/VENVersionTracker.h>

@implementation VDDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"YOUR_PARSE_APP_ID"
                  clientKey:@"YOUR_PARSE_CLIENT_KEY"];
    
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
    [VENVersionTracker beginTrackingVersionForChannel:@"YOUR_CHANNEL_NAME"
                                       serviceBaseUrl:@"http://YOUR_BASE_URL"
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
