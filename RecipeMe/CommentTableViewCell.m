//
//  CommentTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "CommentTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "AuthorizationManager.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCommentData: (Comment *) comment{
    AuthorizationManager *auth = [AuthorizationManager sharedInstance];
    self.commentText.text = comment.text;
    self.commentCreatedAt.text = [comment friendlyCreatedAt];
    if(auth.currentUser && [comment.user.id isEqual:auth.currentUser.id]){
        self.currentUserComment.hidden = NO;
    } else {
        self.currentUserComment.hidden = YES;
    }
    self.commentRate.text = [NSString stringWithFormat:@"%@", comment.rate];
    NSURL *url = [NSURL URLWithString:comment.user.avatarUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.commentImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.commentImage.image = image;
    } failure:nil];
    self.commentImage.layer.cornerRadius = self.commentImage.frame.size.height / 2;
    self.commentImage.clipsToBounds = YES;
}

@end
