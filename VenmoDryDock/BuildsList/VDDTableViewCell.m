// VDDTableViewCell.m
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

#import "VDDTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+DryDock.h"

const CGFloat VDDDetailsBottomBuffer = 10;
const CGFloat VDDDetailsLabelWidth = 290;
#define VDDDetailsFont [UIFont fontWithName:@"HelveticaNeue-Light" size:13]

@interface VDDTableViewCell ()

@property (nonatomic, strong) PFObject *app;

@end

@implementation VDDTableViewCell

- (void)awakeFromNib {

    self.contentView.clipsToBounds = YES;
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

    self.appDetailsLabel                = [[UILabel alloc] init];
    self.appDetailsLabel.numberOfLines  = 0;
    self.appDetailsLabel.font           = VDDDetailsFont;
    [self.contentView addSubview:self.appDetailsLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)configureForApp:(PFObject *)app {
    self.app = app;
    
    self.appNameLabel.text = app[VDDAppKeyName];
    self.appDescriptionLabel.text = app[VDDAppKeyDescription];

    self.appIconView.image = [UIImage imageNamed:@"VenmoIcon"];
    
    [self configureDetailsLabel];
    
    PFFile *image = app[VDDAppKeyImage];
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            self.appIconView.image = [UIImage imageWithData:data];
        }
    }];
}

- (void)configureDetailsLabel {
    PFObject *app = self.app;
    if ([app[VDDAppKeyDetails] hasContent] && CGRectGetHeight(self.frame) > [VDDTableViewCell heightWithoutDetails]) {
        self.appDetailsLabel.text           = [app[VDDAppKeyDetails] stringByReplacingEscapedNewlines];
        CGFloat heightForDetails            = [[self class] heightForDetails:app[VDDAppKeyDetails]];
        self.appDetailsLabel.frame          = CGRectMake(CGRectGetMinX(self.appIconView.frame),
                                                         [[self class] heightWithoutDetails],
                                                         VDDDetailsLabelWidth,
                                                         heightForDetails);
    }
    else {
        self.appDetailsLabel.text           = @"";
    }
}


#pragma mark - IBActions

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


+ (CGFloat)heightWithoutDetails {
    return 85;
}

+ (CGFloat)heightWithDetailsForApp:(PFObject *)app {
    if (![self detailsSupportedByApp:app]) {
        return [self heightWithoutDetails];
    }
    return [self heightWithoutDetails] + [self heightForDetails:app[VDDAppKeyDetails]] + VDDDetailsBottomBuffer;
}

+ (BOOL)detailsSupportedByApp:(PFObject *)app {
    return (app[VDDAppKeyDetails] && [app[VDDAppKeyDetails] hasContent]);
}

+ (CGFloat)heightForDetails:(NSString *)detailsString {
    NSDictionary *attributes = @{NSFontAttributeName: VDDDetailsFont};
    NSString *moreDetails = [detailsString stringByReplacingEscapedNewlines];
    return CGRectGetHeight([moreDetails boundingRectWithSize:CGSizeMake(VDDDetailsLabelWidth, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributes
                                                     context:nil]);
}

@end
