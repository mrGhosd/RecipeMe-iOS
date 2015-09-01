//
//  UserViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "UserDelegate.h"
#import "FeedDelegate.h"
#import "ServerErrorDelegate.h"
@interface UserViewController : ViewController <UITableViewDataSource, UITableViewDelegate, UserDelegate, FeedDelegate, ServerErrorDelegate>
@property(strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@end
