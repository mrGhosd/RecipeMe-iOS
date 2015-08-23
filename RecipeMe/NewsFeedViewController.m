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
#import "Recipe.h"
#import "RecipeDetailViewController.h"
#import "UserViewController.h"
#import <FSImageViewer/FSBasicImage.h>
#import <FSImageViewer/FSBasicImageSource.h>
#import "AppDelegate.h"
#import "MainViewController.h"

@interface NewsFeedViewController (){
    ServerConnection *connection;
    AuthorizationManager *auth;
    NSNumber *page;
    NSMutableArray *feeds;
    Recipe *selectedRecipe;
    User *selectedUser;
    UIRefreshControl *refreshControl;
}

@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = @1;
    feeds = [NSMutableArray new];
    connection = [ServerConnection sharedInstance];
    auth = [AuthorizationManager sharedInstance];
    [self refreshInit];
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
    [refreshControl endRefreshing];
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [connection sendDataToURL:@"/users/feed" parameters:@{@"page": page} requestType:@"GET" andComplition:^(id data, BOOL success){
        if(data){
            [self parseFeedData:data];
        } else {
        
        }
    }];
}

- (void) loadLastData{
    page = @1;
    feeds = [NSMutableArray new];
    [self loadUserFeedData];
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

- (void) refreshInit{
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.backgroundColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:56/255.0 alpha:1];
    [refreshControl addTarget:self action:@selector(loadLastData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl]; //the tableView is a IBOutlet
}

-(void) setNavigationPanel{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
    [self.sidebarButton setTarget:self.sidebarButton];
    [self.sidebarButton setAction: @selector(showLeftMenu:)];
}

- (void) showLeftMenu{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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
    cell.delegate = self;
    [cell setFeedData:feed];
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"recipeView"]){
        RecipeDetailViewController *view = segue.destinationViewController;
        view.recipe = selectedRecipe;
    }
    if([segue.identifier isEqualToString:@"userView"]){
        UserViewController *view = segue.destinationViewController;
        view.user = selectedUser;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
#pragma mark - FeedCell delegate methods

- (void) moveToFeedObject:(id)object{
    selectedRecipe = (Recipe *) object;
    [self performSegueWithIdentifier:@"recipeView" sender:self];
}
- (void) clickOnCellImage:(id)object{
    NSString *url;
    NSString *name;
    if([object isKindOfClass:[NSDictionary class]]){
        url = object[@"avatar_url"];
        name = object[@"name"];
    } else {
        url = (Recipe *) [object imageUrl];
        name = (Recipe *) [object title];
    }
    FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:url] name:name];
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:@[firstPhoto]];
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}
- (void) moveToUserProfile:(id)user{
    selectedUser = (User *) user;
    [self performSegueWithIdentifier:@"userView" sender:self];
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
