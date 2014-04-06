#import <UIKit/UIKit.h>
#import "DCTConfirmationButton.h"

@interface VDDTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *appIconView;
@property (nonatomic, strong) IBOutlet UILabel *appNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *appDescriptionLabel;

@property (nonatomic, strong) IBOutlet DCTConfirmationButton *installButton;
@property (nonatomic, strong) IBOutlet DCTConfirmationButton *shareButton;

@property (nonatomic, weak) UIViewController *controller;

- (void)configureForApp:(PFObject *)app;

+ (CGFloat)height;

@end
