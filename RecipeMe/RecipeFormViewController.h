//
//  RecipeFormViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 18.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "Recipe.h"

@interface RecipeFormViewController : ViewController
@property (strong, nonatomic) Recipe *recipe;
@property (strong, nonatomic) IBOutlet UITextField *recipeTitle;
@property (strong, nonatomic) IBOutlet UITextField *recipeTime;
@property (strong, nonatomic) IBOutlet UITextField *recipePersons;
@property (strong, nonatomic) IBOutlet UITextField *recipeDifficult;
@property (strong, nonatomic) IBOutlet UITextField *recipeCategory;
@property (strong, nonatomic) IBOutlet UITextField *recipeTags;
@property (strong, nonatomic) IBOutlet UIView *formView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *formViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;
@property (strong, nonatomic) NSNumber *recipeImageId;
- (IBAction)saveRecipe:(id)sender;
- (IBAction)dismissForm:(id)sender;

@end
