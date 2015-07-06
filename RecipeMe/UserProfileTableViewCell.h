//
//  UserProfileTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 06.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
- (void) setUserData: (User *) user;
@end
