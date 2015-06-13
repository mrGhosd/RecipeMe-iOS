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

@interface Recipe : NSObject
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSNumber * stepsCount;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * persons;
@property (nonatomic, retain) NSString * difficult;
@property (nonatomic, retain) User *user;
- (instancetype) initWithParameters: (NSDictionary *) params;
- (UIImage *) image;
@end
