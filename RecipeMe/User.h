//
//  User.h
//  RecipeMe
//
//  Created by vsokoltsov on 13.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, retain) NSString * avatarUrl;
- (instancetype) initWithParams: (NSDictionary *) params;
@end
