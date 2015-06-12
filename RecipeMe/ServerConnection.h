//
//  ServerConnection.h
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^ResponseCopmlition)(id data, BOOL success);
typedef void (^requestCompletedBlock)(id);
typedef void(^requestErrorBlock)(NSError *);

@interface ServerConnection : NSObject
@property (nonatomic, copy) requestCompletedBlock completed;
@property (nonatomic, copy) requestErrorBlock errored;

+ (id) sharedInstance;
@end
