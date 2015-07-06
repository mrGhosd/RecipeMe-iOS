//
//  commentForm.m
//  RecipeMe
//
//  Created by vsokoltsov on 30.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "commentForm.h"
#import "ServerError.h"
#import "AuthorizationManager.h"
@implementation commentForm{
    AuthorizationManager *auth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)createComment:(id)sender {
    auth = [AuthorizationManager sharedInstance];
    if([self.commentTextView.text isEqualToString:@""]){
        [[[ServerError alloc] init] showErrorMessage:NSLocalizedString(@"comment_empty", nil)];
    } else {
        NSMutableDictionary *comment = [[NSMutableDictionary alloc] initWithDictionary:@{@"text": self.commentTextView.text}];
        [self.delegate createComment:comment];
    }
}
@end
