//
//  CategoriesListTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 31.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCategory.h"
#import "CategoryDelegate.h"

@interface CategoriesListTableViewCell : UITableViewCell
- (void) setCategoryData: (RMCategory *) category;
@property (strong, nonatomic) RMCategory *category;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;
@property (strong, nonatomic) IBOutlet UILabel *categoryTitle;
@property (strong, nonatomic) id<CategoryDelegate> delegate;
@end
