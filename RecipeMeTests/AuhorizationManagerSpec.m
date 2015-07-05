//
//  AuhorizationManagerSpec.m
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Kiwi.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import <OHHTTPStubs.h>
#import <OHHTTPStubsResponse.h>

#import "ServerConnection.h"
#import "AuthorizationManager.h"

SPEC_BEGIN(AuthorizationManagerSpec)
describe(@"#sharedInstance", ^{
    it(@"init object only once", ^{
        AuthorizationManager *auth = [AuthorizationManager sharedInstance];
        AuthorizationManager *con = [AuthorizationManager sharedInstance];
        [[auth should] equal:con];
    });
    
    it(@"Standart object initialization doesn't create a singleton object", ^{
        AuthorizationManager *auth = [AuthorizationManager sharedInstance];
        AuthorizationManager *con = [[AuthorizationManager alloc] init];
        [[auth shouldNot] equal:con];
    });
});

describe(@"Sign in with email and password", ^{
    __block ServerConnection *connection;
    __block BOOL result;
    __block id serverData;
    
    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });    
});
SPEC_END