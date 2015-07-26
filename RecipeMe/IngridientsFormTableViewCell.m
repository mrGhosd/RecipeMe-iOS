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
    [self.ingridientName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.ingridientSize addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // Initialization code
}
- (void) setIngridientData: (Ingridient *) ingridient{
    self.ingridient = ingridient;
    if(self.ingridient.id){
        self.ingridientName.text = self.ingridient.name;
        self.ingridientSize.text = self.ingridient.size;
        self.ingridientName.enabled = NO;
        self.ingridientSize.enabled = NO;
    } else {
        self.ingridientName.text = @"";
        self.ingridientSize.text = @"";
        self.ingridientName.enabled = YES;
        self.ingridientSize.enabled = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) textFieldDidChange: (UITextField *) textField{
    if([textField isEqual:self.ingridientName]){
        self.ingridient.name = self.ingridientName.text;
    }
    if([textField isEqual:self.ingridientSize]){
        self.ingridient.size = self.ingridientSize.text;
    }
}
- (void) textFieldDidEndEditing:(UITextField *)textField{
}
@end
