//
//  ServerConnection.h
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#define MAIN_HOST @"http://localhost"
#define MAIN_URL @"http://localhost:3000"
//#define MAIN_URL @"http://10.1.1.31:3000"
//#define MAIN_URL @"http://188.166.99.8"

typedef void(^ResponseCopmlition)(id data, BOOL success);
typedef void (^requestCompletedBlock)(id);
typedef void(^requestErrorBlock)(NSError *);

@interface ServerConnection : NSObject
@property (nonatomic, copy) requestCompletedBlock completed;
@property (nonatomic, copy) requestErrorBlock errored;

+ (id) sharedInstance;
- (void) getTokenWithParameters:(NSDictionary *)params andComplition:(ResponseCopmlition) complition;
- (void) sendDataToURL:(NSString *) url parameters: (NSMutableDictionary *)params requestType:(NSString *)type andComplition:(ResponseCopmlition) complition;
- (NSString *)returnCorrectUrlPrefix:(NSString *)string;
- (void)uploadImage: (UIImage *) image withParams: (NSDictionary *) params andComplition:(ResponseCopmlition) complition;
- (void)uploadDataWithParams: (NSDictionary *) params url: (NSString *) url image: (UIImage *) image andComplition:(ResponseCopmlition) complition;
@end
