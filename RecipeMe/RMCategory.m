//
//  RMCategory.m
//  RecipeMe
//
//  Created by vsokoltsov on 26.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RMCategory.h"

@implementation RMCategory
- (instancetype) initWithParameters: (NSDictionary *) params{
    if(self == [super init]){
        [self setParams:params];
    }
    return self;
}
- (void) setParams: (NSDictionary *)params{
    if(params[@"id"]) self.id = params[@"id"];
    if(params[@"title"]) self.title = params[@"title"];
    if(params[@"description"]) self.desc = params[@"description"];

}
@end
