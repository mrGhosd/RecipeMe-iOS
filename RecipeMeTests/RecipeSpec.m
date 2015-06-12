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
    
    context(@"attribute is set", ^{
        it(@"set parameters to new object", ^{
            [[recipe.id should] equal:recipeParams[@"id"]];
            [[recipe.userId should] equal:recipeParams[@"user_id"]];
            [[recipe.categoryId should] equal:recipeParams[@"category_id"]];
            [[recipe.title should] equal:recipeParams[@"title"]];
            [[recipe.desc should] equal:recipeParams[@"description"]];
        });
    });
    
    context(@"attribute is empty", ^{
        it(@"return nil", ^{
            [[recipe.commentsCount should] beNil];
            [[recipe.stepsCount should] beNil];
            [[recipe.imageUrl should] beNil];
        });
    });
});
SPEC_END