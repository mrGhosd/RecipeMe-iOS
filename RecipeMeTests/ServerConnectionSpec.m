//
//  ServerConnection.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
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

SPEC_BEGIN(ServerConnectionSpec)
describe(@"#sharedInstance", ^{
    it(@"init object only once", ^{
        ServerConnection *connection = [ServerConnection sharedInstance];
        ServerConnection *con = [ServerConnection sharedInstance];
        [[connection should] equal:con];
    });
    
    it(@"Standart object initialization doesn't create a singleton object", ^{
        ServerConnection *connection = [ServerConnection sharedInstance];
        ServerConnection *con = [[ServerConnection alloc] init];
        [[connection shouldNot] equal:con];
    });
});
describe(@"#getTokenWithParameters:(NSDictionary *)params andComplition:(ResponseCopmlition) complition", ^(void){
    
});
SPEC_END