//
//  Feed.m
//  RecipeMe
//
//  Created by vsokoltsov on 16.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "Feed.h"
#import "ServerConnection.h"
#import "Recipe.h"
#import "Comment.h"

@implementation Feed
- (instancetype) initWithParameters: (NSDictionary *) params{
    if(self == [super init]){
        [self setParams:params];
    }
    return self;
}

- (void) setParams: (NSDictionary *) params{
    if(params[@"created_at"]) self.createdAt = [self correctConvertOfDate:params[@"created_at"]];
    if(params[@"entity"]) self.entity = params[@"entity"];
    if(params[@"user"]) self.user = [NSDictionary dictionaryWithDictionary:params[@"user"]];
    if(params[@"event_type"]) self.eventType = params[@"event_type"];
    if(params[@"object"] != [NSNull null]) self.object = [self defineObject:params[@"object"]];
    if(params[@"parent_object"] != [NSNull null]) self.parentObject = [self defineParentObject:params[@"parent_object"]];
}
- (NSString *) friendlyCreatedAt{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    return [formatter stringFromDate:self.createdAt];
}

- (NSDate *) correctConvertOfDate:(NSString *) date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
    NSDate *correctDate = [dateFormat dateFromString:date];
    return correctDate;
}
- (id) defineObject: (NSDictionary *) object{
    if(object[@"text"]){
        return [[Comment alloc] initWithParameters:object];
    } else if(object[@"title"]){
        return [[Recipe alloc] initWithParameters:object];
    } else {
        return object;
    }
}
- (id) defineParentObject: (NSDictionary *) object{
    if(object[@"text"]){
        return [[Comment alloc] initWithParameters:object];
    } else if(object[@"title"]){
        return [[Recipe alloc] initWithParameters:object];
    } else {
        return nil;
    }
}
- (NSString *) getFeedDescription{
    return [self returnFeedTitleAndDescription][@"text"];
}
- (NSMutableAttributedString *) getFeedTitle{
    return [self returnFeedTitleAndDescription][@"title"];
}

- (NSDictionary *) returnFeedTitleAndDescription{
    NSMutableDictionary *attrsList = [NSMutableDictionary new];
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] init];
    if([self.eventType isEqualToString:@"create"] && [self.entity isEqualToString:@"Comment"]){
        [self addDataToFeedDictionary:attrsList withTranslateString:NSLocalizedString(@"feed_add_comment", nil) feedText:[self.object text] andFeedTitle:[self.parentObject title]];
    } else if([self.eventType isEqualToString:@"create"] && [self.entity isEqualToString:@"Recipe"]){
        [self addDataToFeedDictionary:attrsList withTranslateString:NSLocalizedString(@"feed_add_recipe", nil) feedText:[self.object desc] andFeedTitle:[self.object title]];
    } else {
        if([self.parentObject isKindOfClass:[Comment class]]){
            [self addDataToFeedDictionary:attrsList withTranslateString:NSLocalizedString(@"feed_add_vote_comment", nil) feedText:[self.parentObject text] andFeedTitle:[self.parentObject title]];
        } else {
            [self addDataToFeedDictionary:attrsList withTranslateString:NSLocalizedString(@"feed_add_vote_recipe", nil) feedText:[self.parentObject desc] andFeedTitle:[self.parentObject title]];
        }
    }
    return attrsList;
}
- (NSMutableAttributedString *) returnAttributedTitle: (NSString *) title andAttributedString: (NSString *) mark{
    NSMutableAttributedString *feedTitle = [[NSMutableAttributedString alloc] initWithString: title];
    NSRange r = [title rangeOfString:mark];
    [feedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:r];
    return feedTitle;
}
- (void) addDataToFeedDictionary: (NSMutableDictionary *) dictionary withTranslateString: (NSString *) translateString feedText: (NSString *) feedText andFeedTitle: (NSString *) feedTitle{
    NSMutableAttributedString *attrString = [self returnAttributedTitle:[NSString stringWithFormat:@"%@ %@", translateString, feedTitle] andAttributedString:feedTitle];
    [dictionary setObject:attrString forKey:@"title"];
    [dictionary setObject:feedText forKey:@"text"];
}
- (NSString *) returnFeedMainImageURLString{
    NSString *imgUrl;
    if([self.entity isEqualToString:@"Vote"] &&
       [self.eventType isEqualToString:@"create"] &&
       [self.object isKindOfClass:[Comment class]]){
        imgUrl = [[ServerConnection sharedInstance] returnCorrectUrlPrefix: self.user[@"avatar_url"]];
    } else {
        if([self.object isKindOfClass:[Recipe class]]){
            imgUrl = [self.object imageUrl];
        } else {
            imgUrl = [self.parentObject imageUrl];
        }
    }
    return imgUrl;
}
@end
