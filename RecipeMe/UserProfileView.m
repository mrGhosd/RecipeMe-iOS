//
//  UserProfileView.m
//  RecipeMe
//
//  Created by vsokoltsov on 15.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserProfileView.h"
#import <UIImageView+AFNetworking.h>
@implementation UserProfileView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) setUserData: (User *) user{
    self.user = user;
    self.userName.text = [[self.user correctNaming] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self setUserProfileImage:self.user];
}
- (void) setUserProfileImage: (User *) user{
    
    NSURL *url = [NSURL URLWithString:user.avatarUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.userProfileImageView setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userProfileImageView.image = image;
    } failure:nil];
    self.userProfileImageView.clipsToBounds = YES;
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height / 2;
    self.userProfileImageView.layer.masksToBounds = YES;

    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.userProfileImageView setUserInteractionEnabled:YES];
    [self.userProfileImageView addGestureRecognizer:singleTap];
}

- (void) profileImageTap: (id) sender{
    
}
@end
