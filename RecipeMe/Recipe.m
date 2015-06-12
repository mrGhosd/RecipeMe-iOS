//
//  Recipe.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe
- (instancetype) initWithParameters: (NSDictionary *) params{
    if(self == [super init]){
        [self setParams:params];
    }
    return self;
}

- (void) setParams: (NSDictionary *)params{
//    self.id = params[@"id"];
    
//    self.objectId = params[@"id"];
//    self.userId = params[@"user_id"];
//    self.categoryId = params[@"category_id"];
//    self.rate = params[@"rate"];
//    self.views = params[@"views"];
//    self.title = params[@"title"];
//    self.isClosed = (BOOL)[params[@"is_closed"] boolValue];
//    self.createdAt = [self correctConvertOfDate:params[@"created_at"]];
//    self.answersCount = params[@"answers_count"];
//    self.commentsCount = params[@"comments_count"];
//    self.tags = params[@"tag_list"];
//    self.text = params[@"text"];
}
@end
