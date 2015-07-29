//
//  RecipesListTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "RecipeCellDelegate.h"
#import "UserDelegate.h"

@interface RecipesListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;
@property (strong, nonatomic) IBOutlet UILabel *recipeDifficult;
@property (strong, nonatomic) IBOutlet UILabel *recipeTime;
@property (strong, nonatomic) IBOutlet UILabel *recipePersons;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *recipeTitle;
@property (strong, nonatomic) IBOutlet UIImageView *heartIcon;
@property (strong, nonatomic) Recipe *recipe;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) id <RecipeCellDelegate, UserDelegate> delegate;
- (void) setInfoView;
- (void) initWithRecipe: (Recipe *) recipe andCurrentUser: (User *) user;
@property (strong, nonatomic) IBOutlet UIView *infoView;
- (void) userVoted;
- (void) userReVoted;
@end
