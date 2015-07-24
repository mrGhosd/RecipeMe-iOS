//
//  IngridientsFormTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 24.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "IngridientsFormTableViewCell.h"

@implementation IngridientsFormTableViewCell

- (void)awakeFromNib {
    self.ingridientName.delegate = self;
    self.ingridientSize.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) textFieldDidEndEditing:(UITextField *)textField{
    if([textField isEqual:self.ingridientName]){
        self.ingridient.name = self.ingridientName.text;
    }
    if([textField isEqual:self.ingridientSize]){
        self.ingridient.size = self.ingridientSize.text;
    }
}
@end
