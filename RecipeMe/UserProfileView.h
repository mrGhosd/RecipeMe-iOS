//
//  UserProfileView.h
//  RecipeMe
//
//  Created by vsokoltsov on 15.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserDelegate.h"
@interface UserProfileView : UIView
@property (strong, nonatomic) IBOutlet UIButton *sidbarButton;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) User *user;
- (void) setUserData: (User *) user;
@property (strong, nonatomic) id <UserDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *recipesView;
@property (strong, nonatomic) IBOutlet UIView *commentsView;
@property (strong, nonatomic) IBOutlet UIView *followersView;
@property (strong, nonatomic) IBOutlet UIView *followingView;
@property (strong, nonatomic) IBOutlet UILabel *recipesCount;
@property (strong, nonatomic) IBOutlet UILabel *recipesLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsCount;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *followersCount;
@property (strong, nonatomic) IBOutlet UILabel *followersLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingCount;
@property (strong, nonatomic) IBOutlet UILabel *followingLabel;
@end
