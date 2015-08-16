//
//  Feed.m
//  RecipeMe
//
//  Created by vsokoltsov on 16.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "Feed.h"
#import "ServerConnection.h"

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
    if(params[@"object"]) self.object = params[@"object"];
    if(params[@"parent_object"]) self.parentObject = params[@"parent_object"];
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
@end
