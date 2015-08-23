//
//  SidebarViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 04.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "SidebarViewController.h"
#import "RecipesListViewController.h"
#import "SWRevealViewController.h"
#import "AuthorizationViewController.h"
#import "AuthorizationManager.h"
#import "UserProfileTableViewCell.h"
#import "UserViewController.h"
#import <UICKeyChainStore.h>

@interface SidebarViewController (){
    NSMutableArray *menuItems;
    NSArray *menuIds;
    NSArray *menuIcons;
    AuthorizationManager *auth;
    UICKeyChainStore *store;
}

@end

@implementation SidebarViewController

- (void) awakeFromNib{
    [super awakeFromNib];
    [self viewDidLoad];
    
}
- (void)viewDidLoad {
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    auth = [AuthorizationManager sharedInstance];
    store = [UICKeyChainStore keyChainStore];
    [self initSidebarData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignedIn) name:@"currentUserWasReseived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignedOut) name:@"signedOut" object:nil];
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"sidebarBg.png"]];
    self.tableView.backgroundView = bgView;
    self.tableView.separatorColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UserProfileTableViewCell class] forCellReuseIdentifier:@"profileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserProfileTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"profileCell"];
    // Do any additional setup after loading the view.
}

-(void) userSignedIn{
    [self initSidebarData];
    [self.tableView reloadData];
}
- (void) userSignedOut{
    [self initSidebarData];
    [self.tableView reloadData];
}
- (void) initSidebarData{
    if(auth.currentUser){
        menuItems = [NSMutableArray arrayWithArray:@[@"Profile", NSLocalizedString(@"recipes", nil), NSLocalizedString(@"categories", nil), NSLocalizedString(@"news_feed", nil)]];
        menuIds = @[@"profile", @"recipes", @"categories", @"feed"];
        menuIcons = @[@"auth.png", @"recipes.png", @"category.png", @"newsFeedIcon.png"];
        self.signOutButton.hidden = NO;
    } else {
        menuItems = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"auth", nil), NSLocalizedString(@"reg", nil),  NSLocalizedString(@"recipes", nil), NSLocalizedString(@"categories", nil)]];
        menuIds = @[@"auth", @"reg", @"recipes", @"categories"];
        menuIcons = @[@"auth.png", @"reg.png", @"recipes.png", @"category.png"];
        self.signOutButton.hidden = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"auth"]){
        AuthorizationViewController *view = segue.destinationViewController;
        view.type = @"auth";
    }
    if([[segue identifier] isEqualToString:@"reg"]){
        AuthorizationViewController *view = segue.destinationViewController;
        view.type = @"reg";
    }
    if([[segue identifier] isEqualToString:@"recipes"]){
        RecipesListViewController *view = segue.destinationViewController;
    }
    if([[segue identifier] isEqualToString:@"profile"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        UserViewController *view = (UserViewController *)navController.topViewController;
        view.user = auth.currentUser;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(auth.currentUser && indexPath.row == 0){
        return 60;
    } else {
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        NSString *touched = menuIds[indexPath.row];
        [self performSegueWithIdentifier:touched sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(auth.currentUser && indexPath.row == 0){
        static NSString *cellIdentifier = @"profileCell";
        UserProfileTableViewCell *cell = (UserProfileTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cell setUserData:auth.currentUser];
        UIImageView *bgView = [[UIImageView alloc] init];
        [bgView setImage:[UIImage imageNamed:@"bgViewSmall.png"]];
        cell.backgroundView = bgView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *cellIdentifier = @"navigationCell";
        UIImageView *bgView = [[UIImageView alloc] init];
        [bgView setImage:[UIImage imageNamed:@"bgViewSmall.png"]];
        UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.textLabel.text = menuItems[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.imageView.image = [UIImage imageNamed:menuIcons[indexPath.row]];
        cell.backgroundView = bgView;
        return cell;
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

- (void) viewWillDisappear:(BOOL)animated{
    //    super: YES;
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

- (IBAction)signOut:(id)sender {
    auth.currentUser = nil;
    [store removeItemForKey:@"email"];
    [store removeItemForKey:@"password"];
    [store removeItemForKey:@"access_token"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"signedOut"
     object:self];
}
@end
