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
    self.feedCreatedAt.text = [self.feed friendlyCreatedAt];
    [self setFeedDescription];
}
- (void) setImageView{
    NSString *imgUrl;
    if([self.feed.entity isEqualToString:@"Vote"] &&
       [self.feed.eventType isEqualToString:@"create"] &&
       self.feed.object[@"text"]){
        imgUrl = [[ServerConnection sharedInstance] returnCorrectUrlPrefix: self.feed.user[@"avatar_url"]];
    } else {
        if(self.feed.object[@"image"]){
            imgUrl = [[ServerConnection sharedInstance] returnCorrectUrlPrefix: self.feed.object[@"image"][@"url"]];
        } else {
            imgUrl = [[ServerConnection sharedInstance] returnCorrectUrlPrefix: self.feed.parentObject[@"image"][@"url"]];
        }
    }
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
    if([self.feed.eventType isEqualToString:@"create"] && [self.feed.entity isEqualToString:@"Comment"]){
        NSString *feedTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"feed_add_comment", nil), self.feed.parentObject[@"title"]];
        self.eventTitle.text = feedTitle;
        self.eventDescription.text = self.feed.object[@"text"];
    }
    if([self.feed.eventType isEqualToString:@"create"] && [self.feed.entity isEqualToString:@"Recipe"]){
        NSString *feedTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"feed_add_recipe", nil), self.feed.object[@"title"]];
        self.eventDescription.text = self.feed.object[@"description"];
    }
    if([self.feed.eventType isEqualToString:@"create"] && [self.feed.entity isEqualToString:@"Vote"]){
        NSString *feedTitle;
        if(self.feed.parentObject[@"text"]){
            feedTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"feed_add_vote_comment", nil), self.feed.parentObject[@"title"]];
            self.eventDescription.text = self.feed.parentObject[@"text"];
        } else {
            feedTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"feed_add_vote_recipe", nil), self.feed.parentObject[@"title"]];
            self.eventDescription.text = self.feed.parentObject[@"description"];
        }
        self.eventTitle.text = feedTitle;
    }
}
@end
