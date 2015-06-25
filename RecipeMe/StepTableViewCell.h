//
//  StepTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Step.h"
@interface StepTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *stepImage;
@property (strong, nonatomic) IBOutlet UITextView *stepDescription;
- (void) setStepData:(Step *) step;
@end
