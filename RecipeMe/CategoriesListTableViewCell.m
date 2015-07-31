//
//  CategoriesListTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 31.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "CategoriesListTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation CategoriesListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCategoryData: (RMCategory *) category{
    self.category = category;
    self.categoryTitle.text = category.title;
    [self setCategoryImageData:category];
}

- (void) setCategoryImageData: (RMCategory *) category{
    NSURL *url = [NSURL URLWithString:category.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"category.png"];
    [self.categoryImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.categoryImage.image = image;
    } failure:nil];
    self.categoryImage.clipsToBounds = YES;
    self.categoryImage.layer.cornerRadius = self.categoryImage.frame.size.height / 2;
    self.categoryImage.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.categoryImage setUserInteractionEnabled:YES];
    [self.categoryImage addGestureRecognizer:singleTap];
}
- (void) imageTap: (id) sender{
    [self.delegate clickOnImage:self.category];
}
@end
