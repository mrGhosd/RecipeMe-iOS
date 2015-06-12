//
//  RecipeSpec.m
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

#import "Recipe.h"

SPEC_BEGIN(RecipeSpec)
describe(@"initWithParameters: (NSDictionary *) params", ^{
    __block Recipe *recipe;
    __block NSDictionary *recipeParams = @{@"id": @1, @"user_id": @1, @"category_id": @1, @"title": @"Title", @"description": @"Desc"};
    
    beforeAll(^{
        recipe = [[Recipe alloc] initWithParameters:recipeParams];
    });
    it(@"set parameters to new object", ^{
        [[recipe.id should] equal:recipeParams[@"id"]];
    });
});
SPEC_END