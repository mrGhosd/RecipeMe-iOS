//
//  CategoryHeaderView.h
//  RecipeMe
//
//  Created by vsokoltsov on 07.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;
@property (strong, nonatomic) IBOutlet UILabel *categoryTitle;
@property (strong, nonatomic) IBOutlet UILabel *categoryDesc;

@end
