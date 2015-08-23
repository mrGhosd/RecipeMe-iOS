//
//  CategoriesViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 31.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "CategoriesViewController.h"
#import "SWRevealViewController.h"
#import "ServerConnection.h"
#import <MBProgressHUD.h>
#import "RMCategory.h"
#import <FSImageViewer/FSBasicImage.h>
#import <FSImageViewer/FSBasicImageSource.h>
#import "ServerError.h"
#import "CategoriesListTableViewCell.h"
#import "RecipesListViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface CategoriesViewController (){
    ServerConnection *connection;
    NSMutableArray *categories;
    RMCategory *selectedCategory;
    UIButton *errorButton;
    UIRefreshControl *refreshControl;
}

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    categories = [NSMutableArray new];
    connection = [ServerConnection sharedInstance];
    [self.tableView registerClass:[CategoriesListTableViewCell class] forCellReuseIdentifier:@"categoryCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoriesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"categoryCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"sidebarBg.png"]];
    self.tableView.backgroundView = bgView;
    [self refreshInit];
    [self setNavigationPanel];
    [self setNavigationAttributes];
    [self loadCategories];
    // Do any additional setup after loading the view.
}

- (void) loadCategories{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [connection sendDataToURL:@"/categories" parameters:nil requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            errorButton.hidden = YES;
            errorButton = nil;
            [errorButton removeFromSuperview];
            [refreshControl endRefreshing];
            [self parseCategories:data];
        } else {
            ServerError *error = [[ServerError alloc] initWithData:data];
            error.delegate = self;
            [error handle];
        }
    }];
}

- (void) parseCategories: (id) data{
    for(NSDictionary *params in data){
        RMCategory *category = [[RMCategory alloc] initWithParameters:params];
        [categories addObject:category];
    }
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNavigationAttributes{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:.56 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"categories_title", nil);
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont fontWithName:@"System" size:22.0], NSFontAttributeName, nil]];
}

-(void) setNavigationPanel{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
    [self.sidebarButton setTarget:self.sidebarButton];
    [self.sidebarButton setAction: @selector(showLeftMenu:)];
}

- (void) showLeftMenu{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void) clickOnImage: (RMCategory *) category{
    FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:category.imageUrl] name:category.title];
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:@[firstPhoto]];
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void) refreshInit{
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.backgroundColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:56/255.0 alpha:1];
    //    [refreshView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadLatestCategories) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl]; //the tableView is a IBOutlet
}
- (void) loadLatestCategories{
    categories = [NSMutableArray new];
    [self loadCategories];
}
- (void) handleServerErrorWithError:(id)error{
    if(errorButton){
        errorButton.hidden = NO;
    } else {
        errorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        errorButton.backgroundColor = [UIColor lightGrayColor];
        [errorButton setTitle:[error messageText] forState:UIControlStateNormal];
        [errorButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [errorButton addTarget:self action:@selector(loadRecipesList) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:errorButton];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [refreshControl endRefreshing];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return categories.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedCategory = categories[indexPath.row];
    [self performSegueWithIdentifier:@"categoryRecipes" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"categoryCell";
    CategoriesListTableViewCell *cell = (CategoriesListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoriesListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"bgViewSmall.png"]];
    cell.backgroundView = bgView;
    [cell setCategoryData:categories[indexPath.row]];
    cell.delegate = self;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"categoryRecipes"]){
        RecipesListViewController *view = segue.destinationViewController;
        view.category = selectedCategory;
    }
}

@end
