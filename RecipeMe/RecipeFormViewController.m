//
//  RecipeFormViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 18.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipeFormViewController.h"

@interface RecipeFormViewController ()

@end

@implementation RecipeFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formViewHeightConstraint.constant += 500.0;
    [self setNamesForInputs];
    // Do any additional setup after loading the view.
}
- (void) setNamesForInputs{
    [self.navigationBar.items[0] setTitle:@"Recipe Form"];
    [self.saveButton setTitle:NSLocalizedString(@"save_recipe", nil)];
    [self.cancelButton setTitle:NSLocalizedString(@"cancel_recipe", nil)];
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

- (IBAction)saveRecipe:(id)sender {
}

- (IBAction)dismissForm:(id)sender {
}
@end
