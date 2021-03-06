//
//  UserProfileTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 06.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <SWTableViewCell.h>

@interface UserProfileTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userNameMarginLeft;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *cityName;
- (void) setUserData: (User *) user;
@end
