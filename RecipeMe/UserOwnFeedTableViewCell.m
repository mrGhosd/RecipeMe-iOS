//
//  UserOwnFeedTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 16.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserOwnFeedTableViewCell.h"
#import "ServerConnection.h"
#import <UIImageView+AFNetworking.h>
#import <TTTAttributedLabel.h>
#import "Comment.h"

@implementation UserOwnFeedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) initWithFeed: (Feed *) feed{
    self.feed = feed;
    [self setImageView];
    [self setFeedDescription];
    self.feedCreatedAt.text = [self.feed friendlyCreatedAt];
}
- (void) setImageView{
    NSString *imgUrl = [self.feed  returnFeedMainImageURLString];
    NSURL *url = [NSURL URLWithString:imgUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.feedImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.feedImage.image = image;
    } failure:nil];
    self.feedImage.clipsToBounds = YES;
    self.feedImage.layer.cornerRadius = self.feedImage.frame.size.height / 2;
}
- (void) setFeedDescription{
    self.eventTitle.attributedText = [self.feed getFeedTitle];
    self.eventDescription.text = [self.feed getFeedDescription];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkRecipeTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.eventTitle setUserInteractionEnabled:YES];
    [self.eventTitle addGestureRecognizer:singleTap];
}
- (void) linkRecipeTap: (UITapGestureRecognizer *)tapRecognizer{
    id sendObject = self.feed.parentObject == nil ? self.feed.object : self.feed.parentObject;
    [self.delegate moveToFeedObject:sendObject];
}
@end
