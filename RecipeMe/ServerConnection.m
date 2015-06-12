//
//  ServerConnection.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ServerConnection.h"
#define MAIN_URL @"http://localhost:3000"
@implementation ServerConnection
static ServerConnection *sharedSingleton_ = nil;

@synthesize completed = _completed;
@synthesize errored = _errored;

+ (id) sharedInstance{
    static ServerConnection *connection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connection = [[self alloc] init];
    });
    return connection;
}

- (void) getTokenWithParameters:(NSDictionary *)params andComplition:(ResponseCopmlition) complition{
    ResponseCopmlition response = [complition copy];
    NSMutableURLRequest *request = [[[AFJSONRequestSerializer new] requestWithMethod:@"POST"
                                                                           URLString:[NSString stringWithFormat: @"%@/oauth/token", MAIN_URL]
                                                                          parameters: params
                                                                               error:nil] mutableCopy];
    
    AFHTTPRequestOperation *requestAPI = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer new];
    serializer.readingOptions = NSJSONReadingAllowFragments;
    requestAPI.responseSerializer = serializer;
    
    [requestAPI setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        response(responseObject, YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *errorDict = @{@"operation": operation, @"error": error};
        response(errorDict, NO);
    }];
    
    [requestAPI start];
}

@end
