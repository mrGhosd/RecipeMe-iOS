//
//  UserCommentTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 15.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "CommentDelegate.h"
#import <SWTableViewCell.h>

@interface UserCommentTableViewCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;
@property (strong, nonatomic) IBOutlet UIView *userView;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *commentText;
@property (strong, nonatomic) IBOutlet UILabel *commentCreatedAt;
@property (strong, nonatomic) Comment *comment;
@property (strong, nonatomic) id<CommentDelegate> delegate;
- (void) initCommentData: (Comment *) comment;
@end
