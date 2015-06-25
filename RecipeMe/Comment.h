//
//  Comment.h
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSNumber *userId;
@property (nonatomic, retain) NSNumber *recipeId;
@property (nonatomic, retain) NSNumber *rate;
+ (NSMutableArray *) initializeFromArray: (NSMutableArray *) commentsList;
- (instancetype) initWithParameters: (NSDictionary *) params;

@end
