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

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationPanel];
    [self setNavigationBarApperance];
    // Do any additional setup after loading the view.
}

- (void) setNavigationBarApperance{
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:.56 alpha:1];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self setNeedsStatusBarAppearanceUpdate];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont fontWithName:@"System" size:22.0], NSFontAttributeName, nil]];
}

-(void) setNavigationPanel{
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController ){
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector(revealToggle:)];
//        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
//        revealViewController.rightViewController = nil;
//    }
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UserProfileView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:self options:nil] firstObject];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
