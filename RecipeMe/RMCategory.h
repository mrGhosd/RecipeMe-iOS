//
//  RMCategory.h
//  RecipeMe
//
//  Created by vsokoltsov on 26.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMCategory : NSObject
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
- (instancetype) initWithParameters: (NSDictionary *) params;
@end
