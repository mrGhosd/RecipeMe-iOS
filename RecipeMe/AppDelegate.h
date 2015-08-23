//
//  AppDelegate.h
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMainViewController (MainViewController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController]
#define kNavigationController (UINavigationController *)[(MainViewController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] rootViewController]
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

