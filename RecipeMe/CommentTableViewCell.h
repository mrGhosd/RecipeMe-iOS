//
//  CommentTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import <SWTableViewCell.h>
@interface CommentTableViewCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *commentImage;
@property (strong, nonatomic) IBOutlet UILabel *commentText;
- (void) setCommentData: (Comment *) comment;
@property (strong, nonatomic) IBOutlet UILabel *commentCreatedAt;

@end
