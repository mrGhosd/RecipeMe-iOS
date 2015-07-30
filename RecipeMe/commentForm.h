//
//  commentForm.h
//  RecipeMe
//
//  Created by vsokoltsov on 30.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentDelegate.h"

@interface commentForm : UIView <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
- (IBAction)createComment:(id)sender;
@property(strong, nonatomic) id<CommentDelegate> delegate;
@end
