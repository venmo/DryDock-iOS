#import <UIKit/UIKit.h>

@interface VDDBuildsTableViewController : UITableViewController

@property (nonatomic) VDDAppDistributionType distributionType;

- (instancetype)initWithBuildType:(VDDAppDistributionType)distributionType;

@end
