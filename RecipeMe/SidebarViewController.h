//
//  SidebarViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 04.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *signOutButton;
- (IBAction)signOut:(id)sender;

@end
