#import "VDDTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface VDDTableViewCell ()

@property (nonatomic, strong) PFObject *app;

@end

@implementation VDDTableViewCell

- (void)awakeFromNib {
    
    self.appIconView.layer.cornerRadius = 12;
    self.appIconView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
	[self.installButton setTitle:@"Install" forState:UIControlStateNormal];
	[self.installButton setTitle:@"Installed" forState:UIControlStateDisabled];
	[self.installButton setConfirmationTitle:@"Overwrite" forState:UIControlStateNormal];

    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
	[self.shareButton setTitle:@"Shared" forState:UIControlStateDisabled];
	[self.shareButton setConfirmationTitle:@"-" forState:UIControlStateNormal];
    self.shareButton.shouldConfirmAction = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)configureForApp:(PFObject *)app {
    self.app = app;
    
    self.appNameLabel.text = app[VDDAppKeyName];
    self.appDescriptionLabel.text = app[VDDAppKeyDescription];

    self.appIconView.image = [UIImage imageNamed:@"VenmoIcon"];

    PFFile *image = app[VDDAppKeyImage];
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            self.appIconView.image = [UIImage imageWithData:data];
        }
    }];
}


- (IBAction)installApp:(id)sender {
    NSString *installUrl = self.app[VDDAppKeyInstallUrl];
    if (installUrl) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
        [self.installButton setLoading:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.installButton setLoading:NO];
        });
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Couldn't install build" message:@"There's no URL to get it." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }
}


- (IBAction)shareApp:(id)sender {
    
    NSString *installText = [NSString stringWithFormat:@"Download %@ -- %@: %@", self.app[VDDAppKeyName], self.app[VDDAppKeyDescription], self.app[VDDAppKeyShareUrl]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[installText] applicationActivities:nil];
    [self.controller presentViewController:activityController animated:YES completion:nil];
    
}


+ (CGFloat)height {
    return 85;
}

@end
