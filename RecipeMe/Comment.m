//
//  Comment.m
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "Comment.h"
#import "ServerConnection.h"

@implementation Comment
+ (NSMutableArray *) initializeFromArray: (NSMutableArray *) commentsList{
    NSMutableArray *comments = [NSMutableArray new];
    for(NSDictionary *commentDictionary in commentsList){
        Comment *comment = [[Comment alloc] initWithParameters:commentDictionary];
        [comments addObject:comment];
    }
    return comments;
}
- (instancetype) initWithParameters: (NSDictionary *) params{
    if(self == [super init]){
        [self setParams:params];
    }
    return self;
}
- (void) setParams: (NSDictionary *) params{
    if(params[@"id"]) self.id = params[@"id"];
    if(params[@"text"]) self.text = params[@"text"];
    if(params[@"user_id"]) self.userId = params[@"user_id"];
    if(params[@"user"]) self.user = [[User alloc] initWithParams:params[@"user"]];
    if(params[@"recipe_id"]) self.recipeId = params[@"recipe_id"];
    if(params[@"rate"]) self.rate = params[@"rate"];
}
- (void) create: (NSMutableDictionary *) params{
    [[ServerConnection sharedInstance] sendDataToURL:@"/comments" parameters:@{@"comment": params} requestType:@"POST" andComplition:^(id data, BOOL success){
        if(success){
            [self.delegate successCommentCreationCallback:data];
        } else {
            [self.delegate failureCommentCreationCallback:data];
        }
    }];
}
@end
