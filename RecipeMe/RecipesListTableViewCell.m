//
//  RecipesListTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipesListTableViewCell.h"

@implementation RecipesListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initWithRecipe: (Recipe *) recipe{
    UIImage *recipeImg = [recipe image];
    if(recipeImg) self.recipeImage.image = [recipe image];
}

@end
