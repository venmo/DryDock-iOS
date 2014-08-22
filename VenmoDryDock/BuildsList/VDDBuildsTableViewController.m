// VDDBuildsTableViewController.m
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
            if (![obj1 respondsToSelector:@selector(objectForKeyedSubscript:)] || ![obj2 respondsToSelector:@selector(objectForKeyedSubscript:)]) {
                return NSOrderedSame;
            }
            NSComparisonResult result = [obj1[VDDAppKeyRank] compare:obj2[VDDAppKeyRank]]; // Lower rank closer to top
            if (result == NSOrderedSame) {
                return [obj2[VDDAppKeyVersionNumber] compare:obj1[VDDAppKeyVersionNumber]]; // Higher version closer to top
            }
            else {
                return result;
            }
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
        return [VDDTableViewCell heightWithDetailsForApp:app];
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
    NSIndexPath *oldIndexPath   = self.lastSelectedIndexPath;
    if (![self.lastSelectedIndexPath isEqual:indexPath]) {
        self.lastSelectedIndexPath  = indexPath;
    }
    else {
        self.lastSelectedIndexPath = nil;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
    if (oldIndexPath && ![oldIndexPath isEqual:indexPath]) {
        [indexPathsToReload addObject:oldIndexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationFade];
}

@end
