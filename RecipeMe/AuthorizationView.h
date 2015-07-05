//
//  AuthorizationView.h
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorizationDelegate.h"
@interface AuthorizationView : UIView
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) id<AuthorizationDelegate> delegate;
- (IBAction)signIn:(id)sender;
@end
