//
//  UserProfileView.h
//  RecipeMe
//
//  Created by vsokoltsov on 15.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface UserProfileView : UIView
@property (strong, nonatomic) IBOutlet UIButton *sidbarButton;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) User *user;
- (void) setUserData: (User *) user;
@end
