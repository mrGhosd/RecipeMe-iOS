//
//  StepsFormTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 24.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Step.h"
#import "StepCellDelegate.h"

@interface StepsFormTableViewCell : UITableViewCell <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *stepImage;
@property (strong, nonatomic) IBOutlet UITextView *stepText;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) Step *step;
@property (strong, nonatomic) id<StepCellDelegate> delegate;
@property (strong, nonatomic) NSNumber *stepImageId;
@property (nonatomic) float currentHeight;
@end
