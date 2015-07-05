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

@interface SidebarViewController (){
    NSMutableArray *menuItems;
    NSArray *menuIds;
    NSArray *menuIcons;
}

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    menuItems = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"auth", nil), NSLocalizedString(@"reg", nil),  NSLocalizedString(@"recipes", nil), NSLocalizedString(@"categories", nil)]];
    menuIds = @[@"auth", @"reg", @"recipes", @"categories"];
    menuIcons = @[@"auth.png", @"reg.png", @"recipes.png", @"category.png"];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
