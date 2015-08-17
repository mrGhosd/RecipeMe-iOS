//
//  Feed.h
//  RecipeMe
//
//  Created by vsokoltsov on 16.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject
- (instancetype) initWithParameters: (NSDictionary *) params;
@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) NSString *eventType;
@property (strong, nonatomic) NSString *entity;
@property (strong, nonatomic) id object;
@property (strong, nonatomic) id parentObject;
@property (strong, nonatomic) NSDate *createdAt;
- (instancetype) initWithParameters: (NSDictionary *) params;
- (NSString *) friendlyCreatedAt;
- (NSString *) returnFeedMainImageURLString;
- (NSString *) getFeedDescription;
- (NSMutableAttributedString *) getFeedTitle;
@end
