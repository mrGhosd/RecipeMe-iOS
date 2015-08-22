//
//  NewsFeedViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 19.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "SWRevealViewController.h"
#import "ServerConnection.h"
#import "AuthorizationManager.h"
#import "FeedTableViewCell.h"
#import <MBProgressHUD.h>
#import <UIScrollView+InfiniteScroll.h>

@interface NewsFeedViewController (){
    ServerConnection *connection;
    AuthorizationManager *auth;
    NSNumber *page;
    NSMutableArray *feeds;
}

@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = @1;
    feeds = [NSMutableArray new];
    connection = [ServerConnection sharedInstance];
    auth = [AuthorizationManager sharedInstance];
    [self.tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:@"feedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"feedCell"];
    [self setNavigationPanel];
    [self setNavigationAttributes];
    [self loadUserFeedData];
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        page = [NSNumber numberWithInteger:[page integerValue] + 1];
        [self loadUserFeedData];
        [tableView finishInfiniteScroll];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) loadUserFeedData{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [connection sendDataToURL:@"/users/feed" parameters:@{@"page": page} requestType:@"GET" andComplition:^(id data, BOOL success){
        if(data){
            [self parseFeedData:data];
        } else {
        
        }
    }];
}
- (void) parseFeedData: (id) data{
    if([data count]){
        for(NSDictionary *fd in data){
            Feed *feed = [[Feed alloc] initWithParameters:fd];
            [feeds addObject:feed];
        }
        [self.tableView reloadData];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void) setNavigationPanel{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        revealViewController.rightViewController = nil;
    }
}
- (void) setNavigationAttributes{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:.56 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"feed_page_title", nil);
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont fontWithName:@"System" size:22.0], NSFontAttributeName, nil]];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return feeds.count;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"feedCell";
    Feed *feed = feeds[indexPath.row];
    FeedTableViewCell *cell = (FeedTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgViewSmall.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setFeedData:feed];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
