//
//  RecipesListTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipesListTableViewCell.h"

@implementation RecipesListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.infoView.layer.opacity = 0.9;
}
@end
