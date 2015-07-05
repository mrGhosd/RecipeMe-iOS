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

@interface SidebarViewController (){
    NSMutableArray *menuItems;
    NSArray *menuIds;
    NSArray *menuIcons;
    AuthorizationManager *auth;
}

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    auth = [AuthorizationManager sharedInstance];
    menuItems = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"auth", nil), NSLocalizedString(@"reg", nil),  NSLocalizedString(@"recipes", nil), NSLocalizedString(@"categories", nil)]];
    menuIds = @[@"auth", @"reg", @"recipes", @"categories"];
    menuIcons = @[@"auth.png", @"reg.png", @"recipes.png", @"category.png"];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSidebarData) name:@"currentUserWasReseived" object:nil];
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"sidebarBg.png"]];
    self.tableView.backgroundView = bgView;
    self.tableView.separatorColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    // Do any additional setup after loading the view.
}
- (void) initSidebarData{
    if(auth.currentUser){
    
    } else {
        
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
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        NSString *touched = menuIds[indexPath.row];
        [self performSegueWithIdentifier:touched sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) viewWillAppear:(BOOL)animated{
    //    super: YES;
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void) viewWillDisappear:(BOOL)animated{
    //    super: YES;
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

@end
