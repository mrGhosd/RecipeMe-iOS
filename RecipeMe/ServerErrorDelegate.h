//
//  ServerErrorDelegate.h
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

@protocol ServerErrorDelegate <NSObject>

@optional
- (void) handleServerErrorWithError:(id) error;
- (void) handleServerFormErrorWithError: (id) error;

@end
