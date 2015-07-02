//
//  StepTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "StepTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation StepTableViewCell

- (void)awakeFromNib {
    // Initialization code
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setStepData:(Step *) step{
    self.stepDescription.text = step.desc;
//    self.stepDescription.editable = NO;
//    self.stepDescription.selectable = YES;
//    self.stepDescription.scrollEnabled = NO;
    self.step = step;
    NSURL *url = [NSURL URLWithString:step.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.stepImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.stepImage.image = image;
    } failure:nil];
    self.stepImage.layer.cornerRadius = self.stepImage.frame.size.height / 2;
    self.stepImage.clipsToBounds = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.stepImage setUserInteractionEnabled:YES];
    [self.stepImage addGestureRecognizer:singleTap];
}
- (void) imageTap: (UIGestureRecognizer *) gesture{
    [self.delegate clickOnCellImage:self.step];
}
@end
