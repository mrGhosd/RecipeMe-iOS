//
//  AuthorizationManager.m
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "AuthorizationManager.h"
#import "ServerConnection.h"
#import <UICKeyChainStore.h>

@implementation AuthorizationManager{
    UICKeyChainStore *store;
    
}
@synthesize completed = _completed;
@synthesize errored = _errored;

+(id) sharedInstance{
    static AuthorizationManager *auth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        auth = [[self alloc] init];
    });
    return auth;
}
- (void) signInUserWithEmail:(NSString *)email andPassword: (NSString *) password{
    [self getTokenWithEmail:email andPassword:password andComplition:^(id data, BOOL success){
        if(success){
            [self getCurrentUserProfileWithEmail:email andPassword:password];
        } else {
            if(self.delegate){
                [self.delegate failedAuthentication:data];
            } else {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"errorUserProfileDownloadMessage"
                 object:self];
            }
        }
    }];
}
- (void) getTokenWithEmail:(NSString *) email andPassword: (NSString *)password andComplition: (ResponseCopmlition) complition{
    store = [UICKeyChainStore keyChainStore];
    ResponseCopmlition response = [complition copy];
    [[ServerConnection sharedInstance] getTokenWithParameters: @{@"grant_type":@"password",
        @"email": email, @"password": password} andComplition:^(id data, BOOL success){
            if(success){
                [store setString:email forKey:@"email"];
                [store setString:password forKey:@"password"];
                [store setString:data[@"access_token"] forKey:@"access_token"];
                response(data, YES);
            } else {
                response(data, NO);
            }
    }];
}
- (void) getCurrentUserProfileWithEmail:(NSString *)email andPassword: (NSString *)password{
    [[ServerConnection sharedInstance] sendDataToURL:@"/users/profile" parameters:nil requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            self.currentUser = [[User alloc] initWithParams:data];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"currentUserWasReseived"
             object:data];
            if(self.delegate){
                [self.delegate successAuthentication:data];
            }
        } else {
            if(self.delegate){
                [self.delegate failedAuthentication:data];
            } else {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"errorUserProfileDownloadMessage"
                 object:data];
            }
        }
    }];
}
- (void) signUpWithParams:(NSDictionary *) params{
    [[ServerConnection sharedInstance] sendDataToURL:@"/users" parameters:@{@"user": params} requestType:@"POST" andComplition:^(id data, BOOL success){
        if(success){
            [self signInUserWithEmail:params[@"email"] andPassword:params[@"password"]];
        } else {
            [self.delegate failedRegistration:data];
        }
    }];
}
@end
