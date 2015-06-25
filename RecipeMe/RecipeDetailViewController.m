//
//  RecipeDetailViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 14.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "RecipesListTableViewCell.h"
#import "StepTableViewCell.h"
#import <MBProgressHUD.h>
#import "ServerConnection.h"
#import "Step.h"

@interface RecipeDetailViewController (){
    ServerConnection *connection;
    NSMutableArray *ingridients;
    NSMutableArray *steps;
    NSMutableArray *comments;
}

@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    connection = [ServerConnection sharedInstance];
    ingridients = [NSMutableArray arrayWithArray:@[@"Ingridient 1", @"ingridient 2", @"ingridient 3",
                                                   @"Ingridient 1", @"ingridient 2", @"ingridient 3",
                                                   @"Ingridient 1", @"ingridient 2", @"ingridient 3",
                                                   @"Ingridient 1", @"ingridient 2", @"ingridient 3"]];
    comments = [NSMutableArray arrayWithArray:@[@"c 1", @"c 2", @"c 3", @"c 4", @"c 5", @"c 6"]];
    [self loadRecipe];
    [self.recipeInfoTableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.recipeInfoTableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    [self.stepsTableView registerClass:[StepTableViewCell class] forCellReuseIdentifier:@"stepCell"];
    [self.stepsTableView registerNib:[UINib nibWithNibName:@"StepTableViewCell" bundle:nil]
                   forCellReuseIdentifier:@"stepCell"];

    // Do any additional setup after loading the view.
}
- (void) setIngridientsTableViewHeight{
    self.ingiridnetsTableHeightConstraint.constant = ingridients.count * 44.0;
    self.stepTableViewHeightConstraint.constant = steps.count * 44.0;
    self.commentsTableViewHeightConstraint.constant = comments.count * 75.0;
    self.viewHeightConstraint.constant = self.ingiridnetsTableHeightConstraint.constant + self.stepTableViewHeightConstraint.constant + self.commentsTableViewHeightConstraint.constant + self.recipeInfoTableView.frame.size.height - 290;
}

- (void) loadRecipe{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
//    [refreshControl endRefreshing];
    [connection sendDataToURL:[NSString stringWithFormat:@"/recipes/%@", self.recipe.id] parameters:nil requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            [self parseRecipe:data];
        } else {
            
        }
    }];
}
- (void) parseRecipe: (id) data{
    if(data != [NSNull null]){
        self.recipe = [[Recipe alloc] initWithParameters:data];
        steps = [NSMutableArray arrayWithArray:self.recipe.steps];
//        [steps addObjectsFromArray:self.recipe.steps];
//        [steps insertObject:@"Шаги" atIndex:0];
        [self.recipeInfoTableView reloadData];
        [self.stepsTableView reloadData];
        [self.ingridientsTableView reloadData];
        [self.commentsTableView reloadData];
    }
    [self setIngridientsTableViewHeight];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    if([tableView isEqual:self.recipeInfoTableView]){
        return 1;
    } else if([tableView isEqual:self.ingridientsTableView]){
        return ingridients.count;
    } else if([tableView isEqual:self.stepsTableView]){
        return steps.count;
    } else {
        return comments.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.recipeInfoTableView]){
        static NSString *CellIdentifier = @"recipeCell";
        RecipesListTableViewCell *cell = (RecipesListTableViewCell *)[self.recipeInfoTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipesListTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell initWithRecipe:self.recipe];
        return cell;
    } else if([tableView isEqual:self.ingridientsTableView]){
        static NSString *CellIdentifier = @"ingridientsCell";
        UITableViewCell *cell = [self.ingridientsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = ingridients[indexPath.row];
        return cell;
    } else if([tableView isEqual:self.stepsTableView]){
        static NSString *CellIdentifier = @"stepCell";
//        if(indexPath.row == 0){
//            UITableViewCell *cell = (UITableViewCell *)[self.stepsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            cell.textLabel.text = steps[0];
//            return cell;
//        } else {
            Step *step = steps[indexPath.row];
            StepTableViewCell *cell = (StepTableViewCell *)[self.stepsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StepTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell setStepData:step];
            return cell;
//        }
    } else {
        static NSString *CellIdentifier = @"commentCell";
        UITableViewCell *cell = [self.commentsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = comments[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.recipeInfoTableView]){
        return 250;
    } else {
        return 44;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([tableView isEqual:self.commentsTableView]){
        return 30;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if([tableView isEqual:self.commentsTableView]){
        return 100;
    } else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if([tableView isEqual:self.commentsTableView]){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
        view.backgroundColor = [UIColor greenColor];
        return view;
    } else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if([tableView isEqual:self.commentsTableView]){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
        view.backgroundColor = [UIColor redColor];
        return view;
    } else {
        return nil;
    }
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
