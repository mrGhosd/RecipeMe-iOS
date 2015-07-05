//
//  RegistrationView.h
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorizationDelegate.h"

@interface RegistrationView : UIView
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *passwordConfirmationField;
@property (strong, nonatomic) IBOutlet UIButton *regButton;
@property (strong, nonatomic) id<AuthorizationDelegate> delegate;
- (IBAction)signUp:(id)sender;

@end
