//
//  CategoriesDetailViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 08.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "CategoriesDetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import <FSImageViewer/FSBasicImage.h>
#import <FSImageViewer/FSBasicImageSource.h>

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
    self.title = self.category.title;
    self.categoryDesc.text = self.category.desc;
    CGSize size  = [self.category.desc sizeWithAttributes:nil];
    if(size.width > self.viewHeightConstraint.constant){
        self.viewHeightConstraint.constant = size.width / 3;
    }
    
    NSURL *url = [NSURL URLWithString:self.category.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.categoryImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.categoryImage.image = image;
    } failure:nil];
    self.categoryImage.clipsToBounds = YES;
    self.categoryImage.layer.cornerRadius = self.categoryImage.frame.size.height / 2;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.categoryImage setUserInteractionEnabled:YES];
    [self.categoryImage addGestureRecognizer:singleTap];
}

- (void) imageTap: (id) sender{
    FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:self.category.imageUrl] name:self.category.title];
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:@[firstPhoto]];
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
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
