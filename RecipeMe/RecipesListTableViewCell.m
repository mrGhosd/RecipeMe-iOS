//
//  RecipesListTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipesListTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation RecipesListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) initWithRecipe: (Recipe *) recipe{
    [self setMainImage:recipe];
    [self setAvatarImage:recipe];
    [self setInfoView];
}
- (void) setMainImage: (Recipe *) recipe{
    NSURL *url = [NSURL URLWithString:recipe.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.recipeImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.recipeImage.image = image;
    } failure:nil];
    self.recipeImage.clipsToBounds = YES;
}

- (void) setAvatarImage: (Recipe *) recipe{
    NSURL *url = [NSURL URLWithString:recipe.user.avatarUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.userAvatar setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userAvatar.image = image;
    } failure:nil];
    self.userAvatar.clipsToBounds = YES;
}
- (void) setInfoView{
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
//    effectView.frame = self.infoView.bounds;
//    
//    UIVisualEffectView *vibrantView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
//    effectView.frame = self.infoView.bounds;
//
//    
//    [self.infoView addSubview:effectView];
//    [self.imageView addSubview:vibrantView];
    self.infoView.layer.opacity = 0.95;
    self.userAvatar.backgroundColor = [UIColor whiteColor];
//    self.userAvatar.layer.zPosition = 100;
}
@end
