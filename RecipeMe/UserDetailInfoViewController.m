//
//  UserDetailInfoViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 15.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserDetailInfoViewController.h"
#import "ServerConnection.h"
#import "Recipe.h"
#import "RecipesListTableViewCell.h"
#import "AuthorizationManager.h"
#import <MBProgressHUD.h>

@interface UserDetailInfoViewController (){
    ServerConnection *connection;
    AuthorizationManager *auth;
    NSNumber *page;
    NSMutableArray *userObjects;
    NSMutableArray *searchResults;
    UISearchBar *searchBarMain;
    UISearchDisplayController *searchDisplayController;
}

@end

@implementation UserDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    [self initSearchBar];
    userObjects = [NSMutableArray new];
    page = @1;
    connection = [ServerConnection sharedInstance];
    auth = [AuthorizationManager sharedInstance];
    [self loadUserInfoData];
    // Do any additional setup after loading the view.
}
- (void) loadUserInfoData{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [connection sendDataToURL:[NSString stringWithFormat:@"/users/%@/%@", self.user.id, self.scopeID] parameters:[NSMutableDictionary dictionaryWithObject:page forKey:@"page"] requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            [self parseInfoData:data];
        } else {
        
        }
    }];
}

- (void) initSearchBar{
    self.searchBar.delegate = self;
}
- (void) parseInfoData: (id) data{
    if([self.scopeID isEqualToString:@"recipes"]){
        [self parseRecipesData:data];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.scopeID = nil;
    self.user = nil;
}
- (void) parseRecipesData:(id) data{
    if(data != [NSNull null]){
        for(NSDictionary *recipe in data){
            Recipe *rec = [[Recipe alloc] initWithParameters:recipe];
            [userObjects addObject:rec];
        }
        [self.tableView reloadData];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return userObjects.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"recipeCell";
    Recipe *recipe;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        recipe = searchResults[indexPath.row];
    } else {
        recipe = userObjects[indexPath.row];
    }
    recipe.delegate = self;
    RecipesListTableViewCell *cell = (RecipesListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipesListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell initWithRecipe:recipe andCurrentUser:auth.currentUser];
//    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

#pragma UISearchBar and UISearchBarController
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[c] %@",
                                    searchText];
    
    searchResults = [userObjects filteredArrayUsingPredicate:resultPredicate];
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
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 250
    ; // or some other height
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
