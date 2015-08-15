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
@interface UserViewController : ViewController <UITableViewDataSource, UITableViewDelegate, UserDelegate>
@property(strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
