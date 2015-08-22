//
//  NewsFeedViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 19.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "FeedDelegate.h"
@interface NewsFeedViewController : ViewController <UITableViewDataSource, UITableViewDelegate, FeedDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
