//
//  Recipe.h
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "Step.h"
#import "RMCategory.h"
#import "RecipeCellDelegate.h"

@interface Recipe : NSObject
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSNumber * stepsCount;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * persons;
@property (nonatomic, retain) NSString * difficult;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSMutableArray *steps;
@property (nonatomic, retain) NSMutableArray *ingridients;
@property (nonatomic, retain) NSMutableArray *comments;
@property (nonatomic, retain) NSMutableArray *votedUsers;
@property (nonatomic, retain) RMCategory *category;
@property (nonatomic, retain) id<RecipeCellDelegate> delegate;

- (instancetype) initWithParameters: (NSDictionary *) params;
- (UIImage *) image;
- (void) upvoteFroRecipeWithCell: (id) cell;
@end
