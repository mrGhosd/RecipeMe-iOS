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

@interface UserViewController (){
    NSString *panelID;
    AuthorizationManager *auth;
    ServerConnection *connection;
    UIRefreshControl *refreshControl;
}

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    connection = [ServerConnection sharedInstance];
    auth = [AuthorizationManager sharedInstance];
    [self refreshInit];
    [self initRightBarButtonItem];
    [self setNavigationPanel];
    [self setNavigationBarApperance];
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
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        revealViewController.rightViewController = nil;
    }
}
- (void) refreshInit{
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.backgroundColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:56/255.0 alpha:1];
    //    [refreshView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadUserData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl]; //the tableView is a IBOutlet
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

- (void) parseUserData: (id)data{
    if(data != [NSNull null]){
        [self.user setParams:data];
        [self.tableView reloadData];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    return 100;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"recipeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
