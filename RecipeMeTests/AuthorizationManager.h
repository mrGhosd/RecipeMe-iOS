//
//  AuthorizationManager.h
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "AuthorizationDelegate.h"

typedef void(^ResponseCopmlition)(id data, BOOL success);
typedef void (^requestCompletedBlock)(id);
typedef void(^requestErrorBlock)(NSError *);

@interface AuthorizationManager : NSObject
@property(strong, nonatomic) User *currentUser;
@property (nonatomic, copy) requestCompletedBlock completed;
@property (nonatomic, copy) requestErrorBlock errored;
@property(strong, nonatomic) id<AuthorizationDelegate> delegate;
+ (id) sharedInstance;
- (void) signInUserWithEmail:(NSString *)email andPassword: (NSString *) password;
- (void) signUpWithParams:(NSDictionary *) params;
@end
