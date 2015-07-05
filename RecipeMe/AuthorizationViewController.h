//
//  AuthorizationViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"

@interface AuthorizationViewController : ViewController
@property (strong, nonatomic) IBOutlet UITextField *authEmailFied;
@property (strong, nonatomic) IBOutlet UITextField *authPasswordField;
@property (strong, nonatomic) IBOutlet UIView *innerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)switchViews:(id)sender;
@property (strong, nonatomic) NSString *type;
@end