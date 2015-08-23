//
//  MainViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 23.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import <LGSideMenuController.h>

@interface MainViewController : LGSideMenuController
- (void) setRooteViewController: (NSString *) controllerID;
@end
