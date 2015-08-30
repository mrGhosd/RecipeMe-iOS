//
//  UserProfileFormViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 30.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "User.h"

@interface UserProfileFormViewController : ViewController
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@end
