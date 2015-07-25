//
//  StepsFormTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 24.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "StepsFormTableViewCell.h"

@implementation StepsFormTableViewCell{
    float previousTextHeight;
}

- (void)awakeFromNib {
    // Initialization code
    self.stepText.delegate = self;
    self.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.stepImage setUserInteractionEnabled:YES];
    [self.stepImage addGestureRecognizer:singleTap];
}
- (void) tapDetected: (id) sender{
    [self.delegate selectImageForCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) textViewDidChange:(UITextView *)textView{
    self.step.desc = textView.text;
}
@end
