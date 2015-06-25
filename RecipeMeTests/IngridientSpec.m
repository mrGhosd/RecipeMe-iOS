//
//  IngridientSpec.m
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "Recipe.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import <OHHTTPStubs.h>
#import <OHHTTPStubsResponse.h>

SPEC_BEGIN(IngridientSpec)
describe(@"initWithParameters: (NSDictionary *) params", ^{
    __block Recipe *recipe;
    __block NSDictionary *recipeParams = @{@"id": @1, @"user_id": @1, @"category_id": @1, @"title": @"Title", @"description": @"Desc", @"ingridients_list": @[@{@"id": @1, @"name": @"Name", @"size": @"100"}]};
    
    beforeAll(^{
        recipe = [[Recipe alloc] initWithParameters:recipeParams];
    });
    
    context(@"steps are setted", ^{
        it(@"set parameters to new object", ^{
            [[[recipe.ingridients[0] name] should] equal:@"Name"];
        });
    });
    
    context(@"attribute is empty", ^{
        __block NSDictionary *recipeParams = @{@"id": @1, @"user_id": @1, @"category_id": @1, @"title": @"Title", @"description": @"Desc", @"ingridients_list": @[]};
        beforeAll(^{
            recipe = [[Recipe alloc] initWithParameters:recipeParams];
            
        });
        it(@"return nil", ^{
            [[recipe.ingridients should] equal:@[]];
        });
    });
});
SPEC_END