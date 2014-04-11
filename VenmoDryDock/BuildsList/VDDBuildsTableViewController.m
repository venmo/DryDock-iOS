#import "VDDBuildsTableViewController.h"
#import "VDDTableViewCell.h"

@interface VDDBuildsTableViewController ()

@property (nonatomic, strong) NSMutableArray *apps;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

@end

@implementation VDDBuildsTableViewController

- (instancetype)initWithBuildType:(VDDAppDistributionType)distributionType {
    self = [super init];
    if (self) {
        self.distributionType = distributionType;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.apps = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"VDDTableViewCell" bundle:nil] forCellReuseIdentifier:@"VDDTableViewCell"];
    
    [self.tableView setTableFooterView:[UIView new]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(fetchApps)
             forControlEvents:UIControlEventValueChanged];

    self.refreshControl = refreshControl;
    
    [self fetchApps];
}


- (void)fetchApps {
    [self.refreshControl beginRefreshing];
    PFQuery *query = [PFQuery queryWithClassName:VDDModelApp];
    [query whereKeyExists:VDDAppKeyName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        // If there are no apps, let's make a demo object to create the model
        if ([objects count] == 0) {
            createDemoObject();
        }
        
        NSMutableArray *newApps = [NSMutableArray array];
        for (PFObject *object in objects) {
            if ([object[VDDAppKeyType] integerValue] == self.distributionType) {
                [newApps addObject:object];
            }
        }
        
        newApps = [[newApps sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if (!obj1 || !obj2 || ![obj1 respondsToSelector:@selector(objectForKeyedSubscript:)] || ![obj2 respondsToSelector:@selector(objectForKeyedSubscript:)]) {
                return NSOrderedSame;
            }
            
            return [obj2[VDDAppKeyVersionNumber] compare:obj1[VDDAppKeyVersionNumber]];
        }] mutableCopy];

        
        self.apps = newApps;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}


- (void)viewDidDisappear:(BOOL)animated {
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.apps count] ? 1 : 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.apps count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.lastSelectedIndexPath]) {
        PFObject *app = self.apps[indexPath.row];
        [VDDTableViewCell heightWithDetailsForApp:app];
    }
    return [VDDTableViewCell heightWithoutDetails];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VDDTableViewCell *cell = (VDDTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VDDTableViewCell" forIndexPath:indexPath];
    cell.controller = self;
    
    [(VDDTableViewCell *)cell configureForApp:[self.apps objectAtIndex:[indexPath row]]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
