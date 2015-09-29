//
//  UserProfileFormViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 30.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "User.h"

@interface UserProfileFormViewController : ViewController <UITextFieldDelegate>
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UITextField *surnameField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *nickName;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@end
