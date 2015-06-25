//
//  Step.h
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Step : NSObject
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * recipeId;
@property (nonatomic, retain) NSString * imageUrl;
+ (NSMutableArray *) initializeFromArray: (NSMutableArray *) stepsList;
- (instancetype) initWithParameters: (NSDictionary *) params;
@end
