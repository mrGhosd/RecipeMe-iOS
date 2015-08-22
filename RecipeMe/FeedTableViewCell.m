//
//  FeedTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 22.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "FeedTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "ServerConnection.h"
@implementation FeedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setAvatarImage{
    NSURL *url = [NSURL URLWithString:self.feed.user[@"avatar_url"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.userAvatar setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userAvatar.image = image;
    } failure:nil];
    self.userAvatar.clipsToBounds = YES;
    self.userAvatar.backgroundColor = [UIColor whiteColor];
    self.userAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userAvatar.layer.borderWidth = 2.0;
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height / 2;
}

- (void) setFeedImageData{
    NSURL *url = [NSURL URLWithString:[self.feed returnFeedMainImageURLString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.feedImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.feedImage.image = image;
    } failure:nil];
    self.feedImage.clipsToBounds = YES;
    self.feedImage.backgroundColor = [UIColor whiteColor];
    self.feedImage.layer.cornerRadius = self.feedImage.frame.size.height / 2;
}

- (void) setFeedData: (Feed *) feed{
    self.feed = feed;
    self.feedCreatedAt.text = [feed friendlyCreatedAt];
    self.feedTitle.attributedText = [self.feed getFeedTitle];
    self.feedDescription.text = [self.feed getFeedDescription];
    self.userName.text = self.feed.user[@"name"];
    [self setAvatarImage];
    [self setFeedImageData];
}

@end
