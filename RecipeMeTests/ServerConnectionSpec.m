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
    __block ServerConnection *connection;
    __block BOOL result;
    __block id serverData;
    
    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });
    
    context(@"failed request", ^{
        it(@"return false if status 404", ^{
            [OHHTTPStubs stubRequestsPassingTest:^(NSURLRequest *request){
                return YES;
            } withStubResponse:^(NSURLRequest *request){
                return [OHHTTPStubsResponse responseWithJSONObject:@[@"data"] statusCode:404 headers:@{@"Content-Type": @"application/json"}];
            }];
            
            [[ServerConnection sharedInstance] getTokenWithParameters:@{@"foo": @"bar"} andComplition:^(id data, BOOL success){
                result = success;
            }];
            
            [[expectFutureValue(theValue(result)) shouldEventually] beFalse];
        });
        
        it(@"return error data if request is failed", ^{
            [OHHTTPStubs stubRequestsPassingTest:^(NSURLRequest *request){
                return YES;
            } withStubResponse:^(NSURLRequest *request){
                return [OHHTTPStubsResponse responseWithJSONObject:@[@"data"] statusCode:404 headers:@{@"Content-Type": @"application/json"}];
            }];
            
            [[ServerConnection sharedInstance] getTokenWithParameters:@{@"foo": @"bar"} andComplition:^(id data, BOOL success){
                serverData = data;
            }];
            
            [[expectFutureValue(serverData) shouldEventually] beKindOfClass:[NSDictionary class]];
            [[expectFutureValue(serverData[@"error"]) shouldEventually] beKindOfClass:[NSError class]];
        });
    });
    
    context(@"success request", ^{
        it(@"return true if status 200", ^{
            [OHHTTPStubs stubRequestsPassingTest:^(NSURLRequest *request){
                return YES;
            } withStubResponse:^(NSURLRequest *request){
                return [OHHTTPStubsResponse responseWithJSONObject:@[@"data"] statusCode:200 headers:@{@"Content-Type": @"application/json"}];
            }];
            
            [[ServerConnection sharedInstance] getTokenWithParameters:@{@"foo": @"bar"} andComplition:^(id data, BOOL success){
                result = success;
            }];
            
            [[expectFutureValue(theValue(result)) shouldEventually] beTrue];
        });
        
        it(@"return success data if status true", ^{
            [OHHTTPStubs stubRequestsPassingTest:^(NSURLRequest *request){
                return YES;
            } withStubResponse:^(NSURLRequest *request){
                return [OHHTTPStubsResponse responseWithJSONObject:@[@"data"] statusCode:200 headers:@{@"Content-Type": @"application/json"}];
            }];
            
            [[ServerConnection sharedInstance] getTokenWithParameters:@{@"foo": @"bar"} andComplition:^(id data, BOOL success){
                serverData = data;
            }];
            
            [[expectFutureValue(serverData) shouldEventually] equal:@[@"data"]];
        });
    });
});

describe(@"sendDataToURL:(NSString *) url parameters: (NSMutableDictionary *)params requestType:(NSString *)type andComplition:(ResponseCopmlition) complition", ^{
    
    __block ServerConnection *connection;
    __block BOOL result;
    __block id serverData;
    
    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });
    
    context(@"success request", ^{
        it(@"return true if status 200", ^{
            [OHHTTPStubs stubRequestsPassingTest:^(NSURLRequest *request){
                return YES;
            } withStubResponse:^(NSURLRequest *request){
                return [OHHTTPStubsResponse responseWithJSONObject:@[@"data"] statusCode:200 headers:@{@"Content-Type": @"application/json"}];
            }];
            [[ServerConnection sharedInstance] sendDataToURL:@"/recipes" parameters:@{@"foo": @"bar"} requestType:@"GET" andComplition:^(id data, BOOL success){
                result = success;
            }];
            
            [[expectFutureValue(theValue(result)) shouldEventually] beTrue];
        });
        
        it(@"return success data if status true", ^{
            [OHHTTPStubs stubRequestsPassingTest:^(NSURLRequest *request){
                return YES;
            } withStubResponse:^(NSURLRequest *request){
                return [OHHTTPStubsResponse responseWithJSONObject:@[@"data"] statusCode:200 headers:@{@"Content-Type": @"application/json"}];
            }];
            
            [[ServerConnection sharedInstance] sendDataToURL:@"/recipes" parameters:@{@"foo": @"bar"} requestType:@"GET" andComplition:^(id data, BOOL success){
                serverData = data;
            }];
            
            [[expectFutureValue(serverData) shouldEventually] equal:@[@"data"]];
        });
    });
    
    context(@"failed request", ^{
        it(@"return false if status 404", ^{
            [OHHTTPStubs stubRequestsPassingTest:^(NSURLRequest *request){
                return YES;
            } withStubResponse:^(NSURLRequest *request){
                return [OHHTTPStubsResponse responseWithJSONObject:@[@"data"] statusCode:404 headers:@{@"Content-Type": @"application/json"}];
            }];
            [[ServerConnection sharedInstance] sendDataToURL:@"/recipes" parameters:@{@"foo": @"bar"} requestType:@"GET" andComplition:^(id data, BOOL success){
                result = success;
            }];
            
            [[expectFutureValue(theValue(result)) shouldEventually] beFalse];
        });
        
        it(@"return error if request failed", ^{
            [OHHTTPStubs stubRequestsPassingTest:^(NSURLRequest *request){
                return YES;
            } withStubResponse:^(NSURLRequest *request){
                return [OHHTTPStubsResponse responseWithJSONObject:@[@"data"] statusCode:404 headers:@{@"Content-Type": @"application/json"}];
            }];
            
            [[ServerConnection sharedInstance] sendDataToURL:@"/recipes" parameters:@{@"foo": @"bar"} requestType:@"GET" andComplition:^(id data, BOOL success){
                serverData = data;
            }];
            
            [[expectFutureValue(serverData) shouldEventually] beKindOfClass:[NSDictionary class]];
            [[expectFutureValue(serverData[@"error"]) shouldEventually] beKindOfClass:[NSError class]];
        });
    });
    
});
SPEC_END