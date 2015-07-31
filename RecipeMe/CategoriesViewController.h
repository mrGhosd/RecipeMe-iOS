//
//  CategoriesViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 31.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "CategoryDelegate.h"
#import "ServerErrorDelegate.h"
@interface CategoriesViewController : ViewController <UITableViewDataSource, UITableViewDataSource, CategoryDelegate, ServerErrorDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
