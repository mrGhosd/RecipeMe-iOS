//
//  CommentViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 08.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "CommentViewController.h"
#import "ServerError.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentTextView.text = self.comment.text;
    [self.saveButton setTitle:NSLocalizedString(@"comment_save_changes", nil) forState:UIControlStateNormal];
    [self.cancellButton setTitle:NSLocalizedString(@"comment_cancel_changes", nil) forState:UIControlStateNormal];
    self.saveButton.layer.cornerRadius = 8.0;
    self.cancellButton.layer.cornerRadius = 8.0;
    self.saveButton.backgroundColor = [UIColor greenColor];
    self.cancellButton.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveChanges:(id)sender {
    if([self.commentTextView.text isEqualToString:@""]){
        ServerError *error = [[ServerError alloc] init];
        [error showErrorMessage:NSLocalizedString(@"comment_empty", nil)];
    } else {
        self.comment.text = self.commentTextView.text;
    }
}

- (IBAction)cancelChanges:(id)sender {
}
@end
