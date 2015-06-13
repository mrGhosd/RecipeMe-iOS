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
    [self setInfoViewData:recipe];
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
- (void) setInfoViewData: (Recipe *) recipe{
    self.infoView.layer.opacity = 0.95;
    self.recipeTitle.text = recipe.title;
    NSString *key = [NSString stringWithFormat:@"recipes_difficult_%@", recipe.difficult];
    self.recipeDifficult.text = NSLocalizedString(key, nil);
    self.recipePersons.text = [NSString stringWithFormat:@"%@", recipe.persons];
    self.recipeTime.text = [NSString stringWithFormat:@"%@ min.", recipe.time];
    [self setUserAvatarSize];
}

- (void) setUserAvatarSize{
    self.userAvatar.backgroundColor = [UIColor whiteColor];
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height / 2;
    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userAvatar.layer.borderWidth = 2.5;
}
@end
