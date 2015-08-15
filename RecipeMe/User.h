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
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * dateOfBirth;
@property (nonatomic, retain) NSMutableArray * followersIds;
@property (nonatomic, retain) NSMutableArray * followingIds;
- (instancetype) initWithParams: (NSDictionary *) params;
- (NSString *) correctNaming;
@end
