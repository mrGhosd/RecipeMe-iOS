//
//  CommentViewController.h
//  RecipeMe
//
//  Created by vsokoltsov on 08.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "Comment.h"

@interface CommentViewController : ViewController
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property(strong, nonatomic) Comment *comment;
@property (strong, nonatomic) IBOutlet UIButton *cancellButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentFormheightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentActionViewBottomMarginConstraint;
- (IBAction)saveChanges:(id)sender;
- (IBAction)cancelChanges:(id)sender;
@end
