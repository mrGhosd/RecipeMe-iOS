//
//  UserProfileTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 06.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserProfileTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation UserProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setUserData: (User *) user{
    self.userName.text = [user correctNaming];
    if([[user correctNaming] length] > 12){
        self.userNameMarginLeft.constant += [[user correctNaming] length] / 2;
    }
    self.cityName.text = user.city;
    NSURL *url = [NSURL URLWithString:user.avatarUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.userAvatar setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userAvatar.image = image;
    } failure:nil];
    self.userAvatar.clipsToBounds = YES;
    [self setUserAvatarSize];
}

- (void) setUserAvatarSize{
    self.userAvatar.backgroundColor = [UIColor whiteColor];
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height / 2;
    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userAvatar.layer.borderWidth = 2.5;
}
 @end
