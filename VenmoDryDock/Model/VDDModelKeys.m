#import "VDDModelKeys.h"

void createDemoObject() {
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"VenmoIcon"], 1.0);
    PFFile *file = [PFFile fileWithName:@"image.png" data:imageData];

    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"Could not save demo object: %@", [error localizedDescription]);
        }
        PFObject *testObject = [PFObject objectWithClassName:VDDModelApp];
        testObject[VDDAppKeyName]           = @"Venmo";
        testObject[VDDAppKeyDescription]    = @"Venmo Dogfood Builds";
        testObject[VDDAppKeyDetails]        = @"Connect with people, send money for free, and cash out to any bank overnight.";
        testObject[VDDAppKeyType]           = @(1);
        testObject[VDDAppKeyVersionNumber]  = @"1";
        testObject[VDDAppKeySharable]       = @(YES);

        testObject[VDDAppKeyShareUrl]       = @"http://someshareurl/";
        testObject[VDDAppKeyInstallUrl]     = @"itms-service://someinstallurl/";

        testObject[VDDAppKeyImage]          = file;
        [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Created Demo Object");
            }
            else {
                NSLog(@"Could not save Demo Object: %@", [error localizedDescription]);
            }
        }];
    } progressBlock:^(int percentDone) {

    }];
}