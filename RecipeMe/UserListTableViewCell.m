//
//  UserListTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 15.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserListTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "AuthorizationManager.h"

@implementation UserListTableViewCell{
    AuthorizationManager *auth;
}

- (void)awakeFromNib {
    auth = [AuthorizationManager sharedInstance];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) initWithUserData: (User *) user{
    self.user = user;
    [self setAvatarImage];
    [self setFollowedIconData];
    self.userName.text = [[self.user correctNaming] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    self.recipesCount.text = [NSString stringWithFormat:@"%@", self.user.recipesCount];
    self.commentsCount.text = [NSString stringWithFormat:@"%@", self.user.commentsCount];
    self.followersCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.followersIds.count];
    self.followingCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.followingIds.count];
}
- (void) setAvatarImage{
    NSURL *url = [NSURL URLWithString:self.user.avatarUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.userAvatar setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userAvatar.image = image;
    } failure:nil];
    self.userAvatar.clipsToBounds = YES;
    self.userAvatar.backgroundColor = [UIColor whiteColor];
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height / 2;
}

- (void) setFollowedIconData{
    if(auth.currentUser){
        if([auth.currentUser.followingIds containsObject:self.user.id]){
            self.followedIcon.image = [UIImage imageNamed:@"followedIcon.png"];
            self.followedIcon.hidden = NO;
        } else {
            self.followedIcon.hidden = YES;
        }
    }
}

@end
