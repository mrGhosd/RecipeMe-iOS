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

@interface RecipesListViewController (){
    ServerConnection *connection;
    NSMutableArray *recipes;
    UISearchBar *searchBarMain;
    NSArray *searchResults;
    UISearchDisplayController *searchDisplayController;
}

@end

@implementation RecipesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    recipes = [NSMutableArray new];
    connection = [ServerConnection sharedInstance];
    [self.tableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    [self setNavigationAttributes];
    [self loadRecipesList];
    // Do any additional setup after loading the view.
}
- (void) setNavigationAttributes{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:.56 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"recipes", nil);
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"System" size:22.0], NSFontAttributeName, nil]];
    
}
- (void) loadRecipesList{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [connection sendDataToURL:@"/recipes" parameters:nil requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            [self parseRecipes:data];
        } else {
        
        }
    }];
}
- (void) parseRecipes: (id) data{
    for(NSDictionary *recipe in data){
        Recipe *rec = [[Recipe alloc] initWithParameters:recipe];
        [recipes addObject:rec];
    }
    [self.tableView reloadData];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
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
@end
