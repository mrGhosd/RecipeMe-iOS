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
    NSString *stepDescription;
}

- (void)awakeFromNib {
    // Initialization code
    stepDescription = NSLocalizedString(@"recipe_step_description", nil);
    self.stepText.delegate = self;
    [self setKeyboardNotifications];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    self.backgroundColor = [UIColor clearColor];
    self.stepImage.image = [UIImage imageNamed:@"stepImagePlaceholder.png"];
    self.stepText.backgroundColor = [UIColor clearColor];
    self.stepText.textColor = [UIColor whiteColor];
    self.stepText.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.stepText.layer.borderWidth = 2.0;
    self.stepText.layer.cornerRadius = 10.0;
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
        if([self.step.desc isEqualToString:@""]){
            self.stepText.text = stepDescription;
            self.stepText.textColor = [UIColor lightGrayColor];
        } else {
            self.stepText.text = self.step.desc;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification *) notification{
    if([self.stepText isFirstResponder]){
        [self.delegate keyboardWasShowOnField:self.stepText withNotification:notification];
    }
}

#pragma mark UITextView placeholder
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    if([textView isEqual:self.stepText] && [textView.text isEqualToString:stepDescription]){
        self.stepText.text = @"";
        self.stepText.textColor = [UIColor whiteColor];
    }
    return YES;
}
- (void) textViewDidEndEditing:(UITextView *)textView{
    if([textView isEqual:self.stepText] && [textView.text isEqualToString:@""]){
        self.stepText.textColor = [UIColor lightGrayColor];
        self.stepText.text = stepDescription;
    }
}

- (void) textViewDidChange:(UITextView *)textView{
    self.step.desc = textView.text;
    
    if(self.stepText.text.length == 0){
        self.stepText.textColor = [UIColor lightGrayColor];
        self.stepText.text = stepDescription;
        [self.stepText resignFirstResponder];
    }
}
@end
