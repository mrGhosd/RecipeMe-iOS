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
    if(params[@"created_at"]) self.createdAt = [self correctConvertOfDate:params[@"created_at"]];
}
- (void) create: (NSMutableDictionary *) params{
    [[ServerConnection sharedInstance] sendDataToURL:[NSString stringWithFormat:@"/recipes/%@/comments", params[@"recipe_id"]] parameters:@{@"comment": params} requestType:@"POST" andComplition:^(id data, BOOL success){
        if(success){
            [self.delegate successCommentCreationCallback:data];
        } else {
            [self.delegate failureCommentCreationCallback:data];
        }
    }];
}
- (void) deleteFromServer{
    [[ServerConnection sharedInstance] sendDataToURL:[NSString stringWithFormat:@"/recipes/%@/comments/%@", self.recipeId, self.id] parameters:nil requestType:@"DELETE" andComplition:^(id data, BOOL success){
        if(success){
            [self.delegate succesDeleteCallback:self];
        } else {
            [self.delegate failureDeleteCallback:self];
        }
    }];
}
- (void) updateToServer{
    [[ServerConnection sharedInstance] sendDataToURL:[NSString stringWithFormat:@"/recipes/%@/comments/%@", self.recipeId, self.id] parameters:@{@"comment": @{@"user_id": self.userId, @"recipe_id": self.recipeId, @"text": self.text}} requestType:@"PUT" andComplition:^(id data, BOOL success){
        if(success){
            [self.delegate successUpdateCallback:data];
        } else {
            [self.delegate failureUpdateCallback:data];
        }
    }];
}
- (NSString *) friendlyCreatedAt{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSDate *currentDate = [formatter dateFromString:self.createdAt];
    formatter.dateStyle = NSDateFormatterLongStyle;
    return [formatter stringFromDate:self.createdAt];
}

- (NSDate *) correctConvertOfDate:(NSString *) date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *correctDate = [dateFormat dateFromString:date];
    return correctDate;
}
@end
