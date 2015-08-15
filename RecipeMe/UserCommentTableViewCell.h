//
//  UserCommentTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 15.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
@interface UserCommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;
@property (strong, nonatomic) IBOutlet UIView *userView;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *commentText;
@property (strong, nonatomic) IBOutlet UILabel *commentCreatedAt;
@property (strong, nonatomic) Comment *comment;
- (void) initCommentData: (Comment *) comment;
@end
