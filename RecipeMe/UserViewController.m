//
//  UserViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserViewController.h"
#import "SWRevealViewController.h"
#import "UserProfileView.h"
#import "UserDetailInfoViewController.h"
#import "ServerConnection.h"
#import <MBProgressHUD.h>
#import "AuthorizationManager.h"
#import "Feed.h"
#import "UserOwnFeedTableViewCell.h"
#import <UIScrollView+InfiniteScroll.h>
#import "RecipeDetailViewController.h"
#import <FSImageViewer/FSBasicImage.h>
#import <FSImageViewer/FSBasicImageSource.h>
#import "AppDelegate.h"
#import "MainViewController.h"

@interface UserViewController (){
    NSString *panelID;
    AuthorizationManager *auth;
    ServerConnection *connection;
    UIRefreshControl *refreshControl;
    NSMutableArray *feeds;
    NSNumber *page;
    Recipe *selectedRecipe;
}

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    connection = [ServerConnection sharedInstance];
    auth = [AuthorizationManager sharedInstance];
    [self.tableView registerClass:[UserOwnFeedTableViewCell class] forCellReuseIdentifier:@"feedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserOwnFeedTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"feedCell"];
    feeds = [NSMutableArray new];
    page = @1;
    [self refreshInit];
    [self initRightBarButtonItem];
    [self setNavigationPanel];
    [self setNavigationBarApperance];
    [self loadUserData];
    [self loadUserFeedData];
    UIImageView *view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"profileViewBg.png"];
    self.tableView.backgroundView = view;
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        page = [NSNumber numberWithInteger:[page integerValue] + 1];
        [self loadUserFeedData];
        [tableView finishInfiniteScroll];
    }];
    // Do any additional setup after loading the view.
}
- (void) setNavigationBarApperance{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:.56 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:126.0/255.0 green:31.0/255.0 blue:81.0/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont fontWithName:@"System" size:22.0], NSFontAttributeName, nil]];
}

-(void) setNavigationPanel{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
}

- (void) showLeftMenu{
//    [(MainViewController *)kMainViewController setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserNavigationController"]];
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void) refreshInit{
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.backgroundColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:56/255.0 alpha:1];
    [refreshControl addTarget:self action:@selector(loadLastData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl]; //the tableView is a IBOutlet
}

- (void) loadLastData{
    page = @1;
    feeds = [NSMutableArray new];
    [self.tableView reloadData];
    [self loadUserData];
    [self loadUserFeedData];
}

- (void) initRightBarButtonItem{
    if([self.user.id isEqualToNumber:auth.currentUser.id]){
    
    } else {
        NSString *img;
        NSString *title;
        if([auth.currentUser.followingIds containsObject:self.user.id]){
                img = @"check-failed.png";
                title = NSLocalizedString(@"profile_unfollow", nil);
        } else {
            img = @"success-check.png";
            title = NSLocalizedString(@"profile_follow", nil);
        }
        [self setRightBarButtonItemWithText:title andImageName:img];
    }
    
}

- (void) relationshipButton: (UIButton *) button{
    NSString *url;
    NSString *requestType;
    if([auth.currentUser.followingIds containsObject:self.user.id]){
        url = [NSString stringWithFormat:@"/relationships/%@", self.user.id];
        requestType = @"DELETE";
    } else {
        url = @"/relationships";
        requestType = @"POST";
    }
    [connection sendDataToURL:url parameters:[NSMutableDictionary dictionaryWithObject:self.user.id forKey:@"id"] requestType:requestType andComplition:^(id data, BOOL success){
        if(success){
            [self parseFollowingData:data withRequest:requestType];
        } else {
            
        }
    }];
}

- (void) setRightBarButtonItemWithText: (NSString *) text andImageName: (NSString *) imageName{
    UIButton* customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [customButton setTitle:text forState:UIControlStateNormal];
    [customButton sizeToFit];
    [customButton addTarget:self action:@selector(relationshipButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem; // or self.navigationItem.rightBarButtonItem
}

- (void) parseFollowingData: (id) data withRequest: (NSString *) request{
    NSString *title;
    NSString *imgName;
    if([request isEqualToString:@"DELETE"]){
        [auth.currentUser.followingIds removeObject:data[@"id"]];
        title = NSLocalizedString(@"profile_follow", nil);
        imgName = @"success-check.png";
    } else {
        [auth.currentUser.followingIds addObject:data[@"id"]];
        title = NSLocalizedString(@"profile_unfollow", nil);
        imgName =  @"check-failed.png";
    }
    [self setRightBarButtonItemWithText:title andImageName:imgName];
}

- (void) loadUserData{
    [refreshControl endRefreshing];
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [connection sendDataToURL:[NSString stringWithFormat: @"/users/%@", self.user.id ] parameters:[NSMutableDictionary new] requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            [self parseUserData:data];
        } else {
        
        }
    }];
}

- (void) loadUserFeedData{
    [connection sendDataToURL: @"/users/own_feed" parameters:[NSMutableDictionary dictionaryWithDictionary:@{@"id": self.user.id, @"page": page}] requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            [self parseFeedData:data];
        } else {
            
        }
    }];
}

- (void) parseUserData: (id)data{
    if(data != [NSNull null]){
        [self.user setParams:data];
    }
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void) parseFeedData: (id) data{
    if(data != [NSNull null]){
        for (NSDictionary *fd in data){
            Feed *feed = [[Feed alloc] initWithParameters:fd];
            [feeds addObject:feed];
        }
        [self.tableView reloadData];
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UserProfileView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:self options:nil] firstObject];
    view.delegate = self;
    [view setUserData:self.user];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 250;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"feedCell";
    Feed *feed = feeds[indexPath.row];
    UserOwnFeedTableViewCell *cell = (UserOwnFeedTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserOwnFeedTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell initWithFeed:feed];
    cell.delegate = self;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgViewSmall.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (void) clickUserInfoPanel:(NSString *) panelIdentifier{
    panelID = panelIdentifier;
    [self performSegueWithIdentifier:@"detailList" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailList"]){
        UserDetailInfoViewController *view = segue.destinationViewController;
        view.scopeID = panelID;
        view.user = self.user;
    }
    if([segue.identifier isEqualToString:@"recipeView"]){
        RecipeDetailViewController *view = segue.destinationViewController;
        view.recipe = selectedRecipe;
    }
}

- (void) moveToFeedObject:(id)object{
    selectedRecipe = (Recipe *) object;
    [self performSegueWithIdentifier:@"recipeView" sender:self];
}

- (void) clickOnCellImage:(id)object{
    Recipe *recipe = (Recipe *) object;
    FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:recipe.imageUrl] name:recipe.title];
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:@[firstPhoto]];
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
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
