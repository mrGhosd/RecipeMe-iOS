//
//  Step.m
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "Step.h"
#import "ServerConnection.h"

@implementation Step
+ (NSMutableArray *) initializeFromArray: (NSMutableArray *) stepsList{
    NSMutableArray *steps = [NSMutableArray new];
    for(NSDictionary *stepDictionary in stepsList){
        Step *step = [[Step alloc] initWithParameters:stepDictionary];
        [steps addObject:step];
    }
    return steps;
}
- (instancetype) initWithParameters: (NSDictionary *) params{
    if(self == [super init]){
        [self setParams:params];
    }
    return self;
}

- (void) setParams: (NSDictionary *) params{
    if(params[@"id"]) self.id = params[@"id"];
    if(params[@"recipe_id"]) self.recipeId = params[@"recipe_id"];
    if(params[@"description"]) self.desc = params[@"description"];
    if(params[@"image"] != [NSNull null] && params[@"image"][@"name"][@"url"]) self.imageUrl = [[ServerConnection sharedInstance] returnCorrectUrlPrefix:params[@"image"][@"name"][@"url"]];
}

- (UIImage *) image{
    UIImage *img  =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[ServerConnection sharedInstance] returnCorrectUrlPrefix:self.imageUrl]]]];
    return img;
}
@end
