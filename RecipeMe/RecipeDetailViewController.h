//
//  RecipeDetailViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 14.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "Recipe.h"

@interface RecipeDetailViewController : ViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *recipeInfoTableView;
@property (strong, nonatomic) IBOutlet UITableView *ingridientsTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ingiridnetsTableHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (strong, nonatomic) Recipe *recipe;
@end