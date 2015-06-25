//
//  Ingridient.h
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingridient : NSObject
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * size;
+ (NSMutableArray *) initializeFromArray: (NSMutableArray *) ingridientsList;
- (instancetype) initWithParameters: (NSDictionary *) params;
@end
