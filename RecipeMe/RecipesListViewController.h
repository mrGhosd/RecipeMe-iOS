//
//  RecipesListViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "UserDelegate.h"
#import "ServerErrorDelegate.h"
#import "RecipeCellDelegate.h"
@class RMCategory;

@interface RecipesListViewController : ViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate, UserDelegate, ServerErrorDelegate, RecipeCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *recipes;
@property (strong, nonatomic) RMCategory *category;
- (IBAction)showSearchBar:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
