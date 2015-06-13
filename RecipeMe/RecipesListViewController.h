//
//  RecipesListViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"

@interface RecipesListViewController : ViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)showSearchBar:(id)sender;

@end
