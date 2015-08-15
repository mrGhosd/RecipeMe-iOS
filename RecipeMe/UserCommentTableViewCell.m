//
//  UserCommentTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 15.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserCommentTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "Recipe.h"
#import "User.h"
@implementation UserCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) initCommentData: (Comment *) comment{
    self.comment = comment;
    self.commentText.text = comment.text;
    self.userName.text = [[self.comment.user correctNaming] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    self.commentCreatedAt.text = [comment friendlyCreatedAt];
    [self setMainImage];
    [self setAvatarImage];
}
- (void) setMainImage{
    NSURL *url = [NSURL URLWithString:self.comment.recipe.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.recipeImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.recipeImage.image = image;
    } failure:nil];
    self.recipeImage.clipsToBounds = YES;
    self.recipeImage.layer.cornerRadius = self.recipeImage.frame.size.height / 2;
    
    
    
}
- (void) setAvatarImage{
    NSURL *url = [NSURL URLWithString:self.comment.user.avatarUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.userAvatar setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userAvatar.image = image;
    } failure:nil];
    self.userAvatar.clipsToBounds = YES;
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height / 2;
}
@end
