//
//  UserProfileFormViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 30.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserProfileFormViewController.h"

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
    [customButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [customButton sizeToFit];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem; // or self.navigationItem.rightBarButtonItem
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
