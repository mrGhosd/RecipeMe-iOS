//
//  Ingridient.m
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "Ingridient.h"
#import "ServerConnection.h"

@implementation Ingridient
+ (NSMutableArray *) initializeFromArray: (NSMutableArray *) ingridientsList{
    NSMutableArray *ingridients = [NSMutableArray new];
    for(NSDictionary *ingridientDictionary in ingridientsList){
        Ingridient *ingridient = [[Ingridient alloc] initWithParameters:ingridientDictionary];
        [ingridients addObject:ingridient];
    }
    return ingridients;
}
- (instancetype) initWithParameters: (NSDictionary *) params{
    if(self == [super init]){
        [self setParams:params];
    }
    return self;
}

- (void) setParams: (NSDictionary *) params{
    if(params[@"id"]) self.id = params[@"id"];
    if(params[@"name"]) self.name = params[@"name"];
    if(params[@"recipe"]) self.recipeId = params[@"recipe"];
    if(params[@"size"]) self.size = params[@"size"];
}
- (void) save{
    NSString *url;
    NSString *requestType;
//    if(self.id){
//        url = [NSString stringWithFormat:@"/recipes/%@/ingridients/%@", self.recipeId, self.id];
//        requestType = @"PUT";
//    } else {
        url = [NSString stringWithFormat:@"/recipes/%@/ingridients", self.recipeId];
        requestType = @"POST";
//    }
    [[ServerConnection sharedInstance] sendDataToURL:url parameters:@{@"name": self.name, @"in_size": self.size} requestType:requestType andComplition:^(id data, BOOL success){
        if(success){
        
        } else {
        
        }
    }];
}

- (void) destroy{
    [[ServerConnection sharedInstance] sendDataToURL:[NSString stringWithFormat:@"/recipes/%@/ingridients/%@", self.recipeId, self.id] parameters:nil requestType:@"DELETE" andComplition:^(id data, BOOL success){
        if(success){
            
        } else {
            
        }
    }];
}
@end
