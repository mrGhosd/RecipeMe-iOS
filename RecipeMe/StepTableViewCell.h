//
//  StepTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Step.h"
#import "StepCellDelegate.h"

@interface StepTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *stepImage;
@property (strong, nonatomic) IBOutlet UILabel *stepDescription;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descHeightConstraint;
@property (strong, nonatomic) id<StepCellDelegate> delegate;
@property (strong, nonatomic) Step *step;
- (void) setStepData:(Step *) step;
@end
