//
//  Comment.h
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Recipe.h"
#import "CommentDelegate.h"

@interface Comment : NSObject
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSNumber *userId;
@property (nonatomic, retain) NSNumber *recipeId;
@property (nonatomic, retain) NSNumber *rate;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Recipe *recipe;
@property (nonatomic, retain) id<CommentDelegate> delegate;
+ (NSMutableArray *) initializeFromArray: (NSMutableArray *) commentsList;
- (instancetype) initWithParameters: (NSDictionary *) params;
- (void) create: (NSMutableDictionary *) params;
- (NSString *) friendlyCreatedAt;
- (void) deleteFromServer;
- (void) updateToServer;
@end
