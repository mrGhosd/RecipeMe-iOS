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
    [self setProfileInfo];
    [self setUserProfileImage:self.user];
}
- (void) setProfileInfo{
    self.userName.text = [[self.user correctNaming] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    if(self.user.recipesCount && self.user.commentsCount){
    NSArray *views = @[@{@"count": self.recipesCount, @"label": self.recipesLabel,
                         @"i18n": NSLocalizedString(@"profile_recipes", nil), @"count_val": self.user.recipesCount},
                       @{@"count": self.commentsCount, @"label": self.commentsLabel,
                         @"i18n": NSLocalizedString(@"profile_comments", nil), @"count_val": self.user.commentsCount},
                       @{@"count": self.followersCount, @"label": self.followersLabel,
                         @"i18n": NSLocalizedString(@"profile_followers", nil), @"count_val": [NSNumber numberWithInteger:self.user.followersIds.count]},
                       @{@"count": self.followingCount, @"label": self.followingLabel,
                         @"i18n": NSLocalizedString(@"profile_following", nil), @"count_val": [NSNumber numberWithInteger:self.user.followingIds.count]}];
    [self setProfileInfoViews:views];
    for(UIView *view in @[self.recipesView, self.commentsView, self.followersView, self.followingView]){
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoViewTap:)];
        singleTap.numberOfTapsRequired = 1;
        [view setUserInteractionEnabled:YES];
        [view addGestureRecognizer:singleTap];
    }
    }
}
- (void) setProfileInfoViews: (NSArray *) infoViews{
    for(NSDictionary *info in infoViews){
        UILabel *countLabel = info[@"count"];
        UILabel *viewLable = info[@"label"];
        NSString *label = info[@"i18n"];
        
        CGSize labelTextSize = [label sizeWithAttributes:@{}];
        CGSize labelFrame = viewLable.frame.size;
        if(labelTextSize.width > labelFrame.width){
            viewLable.font = [UIFont systemFontOfSize:8];
        }
        countLabel.text = [NSString stringWithFormat:@"%@", info[@"count_val"]];
        viewLable.text = info[@"i18n"];
    }
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
- (void) userInfoViewTap: (id) view{
    NSString *ID;
    UIView *clickedView = [view view];
    if([clickedView isEqual:self.recipesView]){
        ID = @"recipes";
    }
    if([clickedView isEqual:self.commentsView]){
        ID = @"comments";
    }
    if([clickedView isEqual:self.followersView]){
        ID = @"followers";
    }
    if([clickedView isEqual:self.followingView]){
        ID = @"following";
    }
    [self.delegate  clickUserInfoPanel:ID];
}
@end
