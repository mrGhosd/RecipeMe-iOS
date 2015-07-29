//
//  RecipesListTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipesListTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "AuthorizationManager.h"

@implementation RecipesListTableViewCell

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignedIn:) name:@"currentUserWasReseived" object:nil];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeartIcon:)];
    singleTap.numberOfTapsRequired = 1;
    [self.heartIcon setUserInteractionEnabled:YES];
    [self.heartIcon addGestureRecognizer:singleTap];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) initWithRecipe: (Recipe *) recipe andCurrentUser: (User *) user{
    self.recipe = recipe;
    [self setMainImage:recipe];
    [self setAvatarImage:recipe];
    [self setInfoViewData:recipe];
    if(user){
        [self setVoteMark:self.recipe andUser:user];
    }
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
    self.user = recipe.user;
    NSURL *url = [NSURL URLWithString:recipe.user.avatarUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.userAvatar setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userAvatar.image = image;
    } failure:nil];
    self.userAvatar.clipsToBounds = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.userAvatar setUserInteractionEnabled:YES];
    [self.userAvatar addGestureRecognizer:singleTap];
}
- (void) setInfoViewData: (Recipe *) recipe{
    self.infoView.layer.opacity = 0.95;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.recipeTitle.text = recipe.title;
    NSString *key = [NSString stringWithFormat:@"recipes_difficult_%@", recipe.difficult];
    self.recipeDifficult.text = NSLocalizedString(key, nil);
    self.recipePersons.text = [NSString stringWithFormat:@"%@", recipe.persons];
    NSString *timeKey = NSLocalizedString(@"recipes_time", nil);
    self.recipeTime.text = [NSString stringWithFormat:@"%@ %@", recipe.time, timeKey];
    [self setUserAvatarSize];
}
- (void) userSignedIn: (NSNotification *) notifictation{
    User *currentUser = [[User alloc] initWithParams:notifictation.object];
    [self setVoteMark:self.recipe andUser:currentUser];
}
- (void) setUserAvatarSize{
    self.userAvatar.backgroundColor = [UIColor whiteColor];
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height / 2;
    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userAvatar.layer.borderWidth = 2.5;
}
- (void) setVoteMark: (Recipe *)recipe andUser: (User *) user{
    if(user && [recipe.votedUsers containsObject:user.id] ){
        [self userVoted];
    } else {
        [self userReVoted];
    }
}
- (void) imageTap: (UIGestureRecognizer *) recognizer{
    [self.delegate clickOnUserImage:self.user];
}

- (void) tapHeartIcon: (id) sender{
    [self.recipe upvoteFroRecipeWithCell:self];
}

- (void) userVoted{
    self.heartIcon.image = [UIImage imageNamed:@"filledHeartIcon.png"];
}
- (void) userReVoted{
    self.heartIcon.image = [UIImage imageNamed:@"heartIcon.png"];
}
@end
