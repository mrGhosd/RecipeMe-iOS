//
//  RecipesListTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipesListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;
- (void) initWithRecipe: (Recipe *) recipe;
@end
