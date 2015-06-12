//
//  ServerConnection.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ServerConnection.h"

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

@end
