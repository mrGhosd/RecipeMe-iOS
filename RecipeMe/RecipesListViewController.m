//
//  RecipesListViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipesListViewController.h"
#import "RecipesListTableViewCell.h"
#import "ServerConnection.h"
#import "Recipe.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>
#import <UIScrollView+InfiniteScroll.h>
#import "RecipeDetailViewController.h"
#import "SWRevealViewController.h"
#import "ServerError.h"

@interface RecipesListViewController (){
    ServerConnection *connection;
    NSMutableArray *recipes;
    NSArray *searchResults;
    NSNumber *pageNumber;
    UIRefreshControl *refreshControl;
    UISearchBar *searchBarMain;
    Recipe *selectedRecipe;
    UIButton *errorButton;
    UISearchDisplayController *searchDisplayController;
}

@end

@implementation RecipesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = @1;
    recipes = [NSMutableArray new];
    connection = [ServerConnection sharedInstance];
    [self setNavigationPanel];
    [self.tableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    [self setNavigationAttributes];
    [self refreshInit];
    [self loadRecipesList];
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searcIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSearchBar:)];
    UIBarButtonItem *addRecipe = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addRecipe.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(addRecipe:)];
    self.navigationItem.rightBarButtonItems = [self.navigationItem.rightBarButtonItems arrayByAddingObjectsFromArray:@[search, addRecipe]];
//    [search setImage:searchImage];
    
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        pageNumber = [NSNumber numberWithInteger:[pageNumber integerValue] + 1];
        [self loadRecipesList];
        [tableView finishInfiniteScroll];
    }];
    // Do any additional setup after loading the view.
}
- (void) setNavigationAttributes{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:.56 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"recipes", nil);
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"System" size:22.0], NSFontAttributeName, nil]];
    
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
    [refreshControl addTarget:self action:@selector(loadLatestRecipes) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl]; //the tableView is a IBOutlet
}
- (void) loadLatestRecipes{
    recipes = [NSMutableArray new];
    pageNumber = @1;
    [self.tableView reloadData];
    [self loadRecipesList];
}

- (void) loadRecipesList{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [refreshControl endRefreshing];
    [connection sendDataToURL:@"/recipes" parameters:@{@"page": pageNumber} requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            errorButton.hidden = YES;
            errorButton = nil;
            [errorButton removeFromSuperview];
            [self parseRecipes:data];
        } else {
            ServerError *error = [[ServerError alloc] initWithData:data];
            error.delegate = self;
            [error handle];
        }
    }];
}
- (void) parseRecipes: (id) data{
    if(data != [NSNull null]){
        for(NSDictionary *recipe in data){
            Recipe *rec = [[Recipe alloc] initWithParameters:recipe];
            [recipes addObject:rec];
        }
        [self.tableView reloadData];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    } else {
        return recipes.count;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRecipe = recipes[indexPath.row];
    [self performSegueWithIdentifier:@"recipeDetail" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"recipeCell";
    Recipe *recipe;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        recipe = searchResults[indexPath.row];
    } else {
        recipe = recipes[indexPath.row];
    }
    
    RecipesListTableViewCell *cell = (RecipesListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipesListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell initWithRecipe:recipe];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"recipeDetail"]){
        RecipeDetailViewController *view = segue.destinationViewController;
        view.recipe = selectedRecipe;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
*/

- (IBAction)showSearchBar:(id)sender {
    if(!searchBarMain){
        searchBarMain = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBarMain contentsController:self];
        searchBarMain.delegate = self;
        searchDisplayController.delegate = self;
        searchDisplayController.searchResultsDataSource = self;
        
        self.tableView.tableHeaderView = searchBarMain;
        
        [self.searchDisplayController.searchBar becomeFirstResponder];
    } else {
        self.tableView.tableHeaderView = nil;
        searchBarMain = nil;
        [self.searchDisplayController.searchBar resignFirstResponder];
        [searchBarMain removeFromSuperview];
    }
    
}
- (IBAction)addRecipe:(id)sender {
    [self performSegueWithIdentifier:@"recipeForm" sender:self];
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[c] %@",
                                    searchText];
    
    searchResults = [recipes filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.tableView.tableHeaderView = nil;
    [self.searchDisplayController.searchBar resignFirstResponder];
    searchBarMain = nil;
    [searchBar removeFromSuperview];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 250
    ; // or some other height
}
- (void) clickOnUserImage:(User *)user{
    [self performSegueWithIdentifier:@"userProfile" sender:self];
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



@end
