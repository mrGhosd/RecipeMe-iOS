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
#import "AuthorizationManager.h"
#import "CategoryHeaderView.h"
#import "CategoriesDetailViewController.h"
#import <SIOSocket/SIOSocket.h>
#import <LGDrawer.h>
#import <LGButton.h>
#import "MainViewController.h"
#import "AppDelegate.h"

@interface RecipesListViewController (){
    AuthorizationManager *auth;
    ServerConnection *connection;
    NSMutableArray *recipes;
    NSArray *searchResults;
    NSNumber *pageNumber;
    UIRefreshControl *refreshControl;
    UISearchBar *searchBarMain;
    Recipe *selectedRecipe;
    UIButton *errorButton;
    NSString *requestURL;
    UISearchDisplayController *searchDisplayController;
    SIOSocket *recipeSocket;
    UIApplication *app;
    LGFilterView *filterView;
    LGButton *titleButton;
    NSArray *titlesArray;
    NSArray *filterParams;
    NSString *filterAttr;
    MainViewController *viewController;
}
@property SIOSocket *socket;
@end

@implementation RecipesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignedIn:) name:@"currentUserWasReseived" object:nil];
    viewController = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
    app = [UIApplication sharedApplication];
    auth = [AuthorizationManager sharedInstance];
    titlesArray = @[NSLocalizedString(@"filter_rate", nil), NSLocalizedString(@"filter_comments", nil), NSLocalizedString(@"filter_steps", nil), NSLocalizedString(@"filter_ingridients", nil)];
    filterParams = @[@"rate", @"comments_count", @"steps_count", @"recipe_ingridients_count"];
    filterAttr = filterParams.firstObject;
    pageNumber = @1;
    recipes = [NSMutableArray new];
    connection = [ServerConnection sharedInstance];
    [self setNavigationPanel];
    [self setupFilterViewsWithTransitionStyle:LGFilterViewTransitionStyleTop];
    [self.tableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    [self setNavigationAttributes];
    [self refreshInit];
    if(self.category){
        requestURL  = [NSString stringWithFormat:@"/categories/%@/recipes", self.category.id];
    } else {
        requestURL = @"/recipes";
    }
    if(self.recipes){
        recipes = self.recipes;
    } else {
        [self loadRecipesList];
    }
    [self setNavigationBarButtons];
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        pageNumber = [NSNumber numberWithInteger:[pageNumber integerValue] + 1];
        [self loadRecipesList];
        [tableView finishInfiniteScroll];
    }];
    
    [SIOSocket socketWithHost: @"http://127.0.0.1:5001" response: ^(SIOSocket *socket) {
        self.socket = socket;
        
        __weak typeof(self) weakSelf = self;
        self.socket.onConnect = ^(){
            NSLog(@"Success connection");
        };
        
        self.socket.onDisconnect = ^(){
            NSLog(@"Disconnected");
        };
        
        self.socket.onReconnect = ^(NSInteger count){
        
        };
        
        self.socket.onError = ^(NSDictionary *error){
            
        };
        
        [self.socket on:@"rtchange" callback:^(SIOParameterArray *args){
            app.networkActivityIndicatorVisible = YES;
            NSDictionary *params = [args firstObject];
            if([params[@"resource"] isEqualToString:@"Recipe"]){
                if([params[@"action"] isEqualToString:@"create"]){
                    [self handleSocketRecipeCreate:params[@"obj"]];
                }
                if([params[@"action"] isEqualToString:@"destroy"]){
                    [self handleSocketRecipeDestroy:params[@"obj"]];
                }
                if([params[@"action"] isEqualToString:@"attributes-change"]){
                    [self handleSocketRecipeUpdate:params[@"obj"]];
                }
            }
        }];
    }];
    
    
    
    // Do any additional setup after loading the view.
}
- (void) userSignedIn: (NSNotification *) notifictation{
    User *currentUser = [[User alloc] initWithParams:notifictation.object];
    self.navigationItem.rightBarButtonItems = [NSArray new];
    [self setNavigationBarButtons];
//    [self setVoteMark:self.recipe andUser:currentUser];
}
- (LGDrawer *) setCustomArrowImage{
    return [LGDrawer drawArrowWithImageSize:CGSizeMake(11.f, 8.f)
                                       size:CGSizeMake(9.f, 6.f)
                                     offset:CGPointZero
                                     rotate:0.f
                                  thickness:2.f
                                  direction:LGDrawerDirectionBottom
                            backgroundColor:nil
                                      color:[UIColor whiteColor]
                                       dash:nil
                                shadowColor:nil
                               shadowOffset:CGPointZero
                                 shadowBlur:0.f];
}
- (void) setCustomTitleButtonWithArrow: (UIImage *) arrowImage{
    titleButton = [LGButton new];
    titleButton.adjustsAlphaWhenHighlighted = YES;
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.tag = 0;
    [titleButton setTitle:titlesArray.firstObject forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(toggleFilterView:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton setImage:arrowImage forState:UIControlStateNormal];
    titleButton.imagePosition = LGButtonImagePositionRight;
    titleButton.titleLabel.font = [UIFont systemFontOfSize:20.f];
    [titleButton sizeToFit];
    self.navigationItem.titleView = titleButton;
}

- (void) setFilterAttributes{
    
}

- (void)setupFilterViewsWithTransitionStyle:(LGFilterViewTransitionStyle)style
{
    UIImage *arrowImage = [self setCustomArrowImage];
    [self setCustomTitleButtonWithArrow:arrowImage];
    
    filterView = [[LGFilterView alloc] initWithTitles:titlesArray
                                          actionHandler:^(LGFilterView *filterView, NSString *title, NSUInteger index)
                    {
                        [titleButton setTitle:title forState:UIControlStateNormal];
                        titleButton.tag = index;
                    }
                                          cancelHandler:nil];
    filterView.delegate = self;
    filterView.transitionStyle = style;
    filterView.numberOfLines = 0;
    filterView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}
- (void) toggleFilterView: (UIButton *) btn{
    if(!filterView.isShowing){
        filterView.selectedIndex = titleButton.tag;
        [filterView showInView:self.view animated:YES completionHandler:nil];
    } else {
        [filterView dismissAnimated:YES completionHandler:nil];
    }
}
- (void) setNavigationBarButtons{
    if(auth.currentUser){
        UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searcIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSearchBar:)];
        UIBarButtonItem *addRecipe = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addRecipe.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(addRecipe:)];
        self.navigationItem.rightBarButtonItems = [self.navigationItem.rightBarButtonItems arrayByAddingObjectsFromArray:@[search, addRecipe]];
    } else {
        UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searcIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSearchBar:)];
        self.navigationItem.rightBarButtonItems = [self.navigationItem.rightBarButtonItems arrayByAddingObjectsFromArray:@[search]];
    }
}
- (void) setNavigationAttributes{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251/255.0 green:28/255.0 blue:.56 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"recipes", nil);
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
    [kMainViewController setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"]];
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
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
    [connection sendDataToURL:requestURL parameters:@{@"page": pageNumber, @"filter_attr": filterAttr} requestType:@"GET" andComplition:^(id data, BOOL success){
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
    recipe.delegate = self;
    RecipesListTableViewCell *cell = (RecipesListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipesListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell initWithRecipe:recipe andCurrentUser:auth.currentUser];
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
    if([segue.identifier isEqualToString:@"categoryDetail"]){
        CategoriesDetailViewController *view = segue.destinationViewController;
        view.category = self.category;
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

- (void) successUpvoteCallbackWithRecipe:(id)recipe cell:(id)cell andData:(id)data{
    data[@"rate"] > [recipe rate] ? [cell userVoted] : [cell userReVoted];
    [recipe setRate:data[@"rate"]];
}

- (void) failureUpvoteCallbackWithRecipe:(id)error{
    
}

#pragma mark - Recipes Category list
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.category){
        CategoryHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"CategoryHeaderView" owner:self options:nil] firstObject];
        view.categoryTitle.text = self.category.title;
        view.categoryDesc.text = self.category.desc;
        
        NSURL *url = [NSURL URLWithString:self.category.imageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailCategory:)];
        singleTap.numberOfTapsRequired = 1;
        [view setUserInteractionEnabled:YES];
        [view addGestureRecognizer:singleTap];
        UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
        [view.categoryImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            view.categoryImage.image = image;
        } failure:nil];
        view.categoryImage.clipsToBounds = YES;
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.category){
        return 124;
    } else {
        return 0;
    }
}
- (void) showDetailCategory: (id) sender{
    [self performSegueWithIdentifier:@"categoryDetail" sender:self];
}
- (void) handleSocketRecipeCreate: (NSDictionary *) recipe{
    Recipe *rec = [[Recipe alloc] initWithParameters:recipe];
    [recipes insertObject:rec atIndex:0];
    [self.tableView reloadData];
    [self hideNetworkActivityIndicator];
}
- (void) handleSocketRecipeDestroy: (NSDictionary *) recipe{
    NSInteger *recipeIndex = [self indexOfRecipe:recipe[@"id"]];
    [recipes removeObjectAtIndex:recipeIndex];
    [self.tableView reloadData];
    [self hideNetworkActivityIndicator];
}
- (NSInteger) indexOfRecipe: (NSNumber *) recipeId{
    NSInteger *searchId;
    for(Recipe *recipe in recipes){
        if([recipe.id isEqualToNumber:recipeId]){
            searchId = [recipes indexOfObject:recipe];
        }
    }
    return searchId;
}
- (void) handleSocketRecipeUpdate: (NSDictionary *) recipe{
    NSInteger *recipeIndex = [self indexOfRecipe:recipe[@"id"]];
    Recipe *updRecipe = [recipes objectAtIndex:recipeIndex];
    [updRecipe setParams:recipe];
    [self.tableView reloadData];
}
- (void) hideNetworkActivityIndicator{
    app.networkActivityIndicatorVisible = NO;
}

#pragma  mark - LGFilterViewDelegate methods
- (void) filterView:(LGFilterView *)filterView buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index{
    filterAttr = filterParams[index];
    [self loadLatestRecipes];
}
@end
