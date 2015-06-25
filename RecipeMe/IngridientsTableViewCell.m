//
//  IngridientsTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "IngridientsTableViewCell.h"

@implementation IngridientsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setIngridientData: (Ingridient *) ingridient{
    self.ingridientName.text = ingridient.name;
    self.ingridientSize.text = ingridient.size;
}
@end
