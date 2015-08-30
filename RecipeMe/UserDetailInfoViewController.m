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
#import <UIScrollView+InfiniteScroll.h>
#import "Comment.h"
#import "UserCommentTableViewCell.h"
#import "RecipeDetailViewController.h"
#import <SWTableViewCell.h>
#import "CommentViewController.h"
#import "UserListTableViewCell.h"
#import "UserViewController.h"

@interface UserDetailInfoViewController (){
    ServerConnection *connection;
    AuthorizationManager *auth;
    Recipe *selectedRecipe;
    Comment *selectedComment;
    User *selectedUser;
    NSNumber *page;
    NSMutableArray *userObjects;
    NSMutableArray *searchResults;
    UISearchBar *searchBarMain;
    UISearchDisplayController *searchDisplayController;
    UIRefreshControl *refreshControl;
}

@end

@implementation UserDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    [self.tableView registerClass:[UserCommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserCommentTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"commentCell"];
    [self.tableView registerClass:[UserListTableViewCell class] forCellReuseIdentifier:@"userCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"userCell"];
    [self initSearchBar];
    [self refreshInit];
    userObjects = [NSMutableArray new];
    page = @1;
    connection = [ServerConnection sharedInstance];
    auth = [AuthorizationManager sharedInstance];
    self.title = [self setTitleForView];
    [self loadUserInfoData];
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        page = [NSNumber numberWithInteger:[page integerValue] + 1];
        [self loadUserInfoData];
        [tableView finishInfiniteScroll];
    }];
    // Do any additional setup after loading the view.
}
- (void) loadUserInfoData{
    [refreshControl endRefreshing];
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
    if([self.scopeID isEqualToString:@"comments"]){
        [self parseCommentsData:data];
    }
    if([self.scopeID isEqualToString:@"following"] || [self.scopeID isEqualToString:@"followers"]){
        [self parseUserInfoData: data];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    userObjects = [NSMutableArray new];
    page = @1;
    [self loadUserInfoData];
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

- (void) viewWillAppear:(BOOL)animated{
    [self setBGToTableView];
}

- (void) parseCommentsData:(id) data{
    if(data != [NSNull null]){
        for(NSDictionary *comment in data){
            Comment *comm = [[Comment alloc] initWithParameters:comment];
            [userObjects addObject:comm];
        }
        [self.tableView reloadData];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void) parseUserInfoData: (id) data{
    if(data != [NSNull null]){
        for(NSDictionary *user in data){
            User *usr = [[User alloc] initWithParams:user];
            [userObjects addObject:usr];
        }
        [self.tableView reloadData];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return searchResults.count;
    }
    return userObjects.count;
    
}
- (void) setBGToTableView{
    UIImageView *view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"sidebarBg.png"];
    self.tableView.backgroundView = view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(userObjects.count != nil){
        [self setBGToTableView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    } else{
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, self.view.layer.frame.size.width, 500)];
        messageLabel.text = [self setLabelForEmptyList];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.scopeID isEqualToString:@"recipes"]){
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
    if([self.scopeID isEqualToString:@"comments"]){
        static NSString *CellIdentifier = @"commentCell";
        Comment *comment;
        if (tableView == self.searchDisplayController.searchResultsTableView){
            comment = searchResults[indexPath.row];
        } else {
            comment = userObjects[indexPath.row];
        }
        UserCommentTableViewCell *cell = (UserCommentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCommentTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell initCommentData:comment];
        
        if([auth.currentUser.id isEqualToNumber:comment.user.id]){
                NSMutableArray *rightUtilityButtons = [NSMutableArray new];
                [rightUtilityButtons sw_addUtilityButtonWithColor:
                 [UIColor greenColor] icon:[UIImage imageNamed:@"edit-32.png"]];
                [rightUtilityButtons sw_addUtilityButtonWithColor:
                 [UIColor redColor] icon:[UIImage imageNamed:@"delete_sign-32.png"]];
                cell.rightUtilityButtons = rightUtilityButtons;
                cell.delegate = self;
        }
        return cell;
    } else {
        static NSString *CellIdentifier = @"userCell";
        User *user;
        if (tableView == self.searchDisplayController.searchResultsTableView){
            user = searchResults[indexPath.row];
        } else {
            user = userObjects[indexPath.row];
        }
        UserListTableViewCell *cell = (UserListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserListTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell initWithUserData:user];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgViewSmall.png"]];
        return cell;
    }
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Comment *comment = userObjects[indexPath.row];
    selectedComment = comment;
    switch (index) {
        case 0:{
            [self performSegueWithIdentifier:@"editComment" sender:self];
            break;
        }
        case 1:{
            [MBProgressHUD showHUDAddedTo:self.view
                                 animated:YES];
            [comment deleteFromServer];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.scopeID isEqualToString:@"recipes"]){
        return 250;
    } else if([self.scopeID isEqualToString:@"comments"]){
        return 92;
    } else {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.scopeID isEqualToString:@"recipes"]){
        selectedRecipe = userObjects[indexPath.row];
        [self performSegueWithIdentifier:@"recipeView" sender:self];
    }
    if([self.scopeID isEqualToString:@"followers"] || [self.scopeID isEqualToString:@"following"]){
        selectedUser = userObjects[indexPath.row];
        [self performSegueWithIdentifier:@"profileView" sender:self];
    }
}

#pragma UISearchBar and UISearchBarController
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate;
    if([self.scopeID isEqualToString:@"recipes"]){
        resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[c] %@",
                                    searchText];
    }
    if([self.scopeID isEqualToString:@"comments"]){
        resultPredicate = [NSPredicate
                           predicateWithFormat:@"text contains[c] %@",
                           searchText];
    }
    if([self.scopeID isEqualToString:@"following"] || [self.scopeID isEqualToString:@"followers"]){
        resultPredicate = [NSPredicate
                               predicateWithFormat:@"name contains[c] %@ OR surname contains[c] %@ OR nickname contains[c] %@",
                               searchText, searchText, searchText];
    }
    searchResults = [userObjects filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController: (UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
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
- (void) clickOnRecipeImage:(id)recipe{
    selectedRecipe = recipe;
    [self performSegueWithIdentifier:@"recipeView" sender:self];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"recipeView"]){
        RecipeDetailViewController *view = segue.destinationViewController;
        view.recipe = selectedRecipe;
    }
    if([segue.identifier isEqualToString:@"editComment"]){
        CommentViewController *view = segue.destinationViewController;
        view.comment = selectedComment;
    }
    if([segue.identifier isEqualToString:@"profileView"]){
        UserViewController *view = segue.destinationViewController;
        view.user = selectedUser;
    }
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - CommentDelegate methods
- (void) succesDeleteCallback:(Comment *)comment{
    [userObjects removeObject:comment];
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void) failureDeleteCallback:(id)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
#pragma mark - Votes callback
- (void) successUpvoteCallbackWithRecipe:(id)recipe cell:(id)cell andData:(id)data{
    data[@"rate"] > [recipe rate] ? [cell userVoted] : [cell userReVoted];
    [recipe setRate:data[@"rate"]];
}

- (void) failureUpvoteCallbackWithRecipe:(id)error{
    
}

- (NSString *) setLabelForEmptyList{
    NSString *emptyDescriptionLabel;
    if([self.scopeID isEqualToString:@"recipes"]){
        emptyDescriptionLabel = NSLocalizedString(@"empty_recipes", nil);
    }
    if([self.scopeID isEqualToString:@"comments"]){
        emptyDescriptionLabel = NSLocalizedString(@"empty_comments", nil);
    }
    if([self.scopeID isEqualToString:@"followers"]){
        emptyDescriptionLabel = NSLocalizedString(@"empty_followers", nil);
    }
    if([self.scopeID isEqualToString:@"following"]){
        emptyDescriptionLabel = NSLocalizedString(@"empty_following", nil);
    }
    NSString *fullEmptyString = [NSString stringWithFormat:@"%@ %@", [self.user correctNaming], emptyDescriptionLabel];
    return fullEmptyString;
}
- (NSString *) setTitleForView{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    NSString *title;
    if([self.scopeID isEqualToString:@"recipes"]){
        title = NSLocalizedString(@"recipes_title", nil);
    }
    if([self.scopeID isEqualToString:@"comments"]){
        title = NSLocalizedString(@"comments_title", nil);
    }
    if([self.scopeID isEqualToString:@"followers"]){
        title = NSLocalizedString(@"followers_title", nil);
    }
    if([self.scopeID isEqualToString:@"following"]){
        title = NSLocalizedString(@"following_title", nil);
    }
    return title;
}
@end
