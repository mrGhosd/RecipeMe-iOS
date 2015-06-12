//
//  RecipesListViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipesListViewController.h"
#import "RecipesListTableViewCell.h"

@interface RecipesListViewController (){
    NSMutableArray *recipes;
}

@end

@implementation RecipesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"recipeCell";
    RecipesListTableViewCell *cell = (RecipesListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipesListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
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
