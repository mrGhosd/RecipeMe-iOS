//
//  CategoriesDetailViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 08.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "CategoriesDetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface CategoriesDetailViewController ()

@end

@implementation CategoriesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCategoryData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initCategoryData{
    self.categoryTitle.text = self.category.title;
    self.categoryDesc.text = self.category.desc;
    
    NSURL *url = [NSURL URLWithString:self.category.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.categoryImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.categoryImage.image = image;
    } failure:nil];
    self.categoryImage.clipsToBounds = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
