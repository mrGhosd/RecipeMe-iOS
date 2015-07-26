//
//  StepsFormTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 24.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "StepsFormTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation StepsFormTableViewCell{
    float previousTextHeight;
}

- (void)awakeFromNib {
    // Initialization code
    self.stepText.delegate = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.stepImage setUserInteractionEnabled:YES];
    [self.stepImage addGestureRecognizer:singleTap];
}
- (void) tapDetected: (id) sender{
    [self.delegate selectImageForCell:self];
}

- (void) setStepData: (Step *) step{
    self.step = step;
    if(step.id){
        NSURL *url = [NSURL URLWithString:step.imageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
        [self.stepImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.stepImage.image = image;
        } failure:nil];
        self.stepImage.clipsToBounds = YES;
        self.stepText.text = self.step.desc;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) textViewDidChange:(UITextView *)textView{
    self.step.desc = textView.text;
}
@end
