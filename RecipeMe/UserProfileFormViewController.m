//
//  UserProfileFormViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 30.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserProfileFormViewController.h"
#import "UserViewController.h"
@interface UserProfileFormViewController ()

@end

@implementation UserProfileFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomBarButtons];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCustomBarButtons{
    UIButton* customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"success-check.png"] forState:UIControlStateNormal];
    [customButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [customButton sizeToFit];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"check-failed.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.rightBarButtonItem = customBarButtonItem; // or self.navigationItem.rightBarButtonItem
}

- (void) backButton: (UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
