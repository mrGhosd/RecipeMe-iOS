//
//  UserDetailInfoViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 15.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "CommentDelegate.h"

@interface UserDetailInfoViewController : ViewController <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchDisplayDelegate, CommentDelegate>

@property(strong, nonatomic) NSString *scopeID;
@property(strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end
