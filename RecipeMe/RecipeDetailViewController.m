//
//  RecipeDetailViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 14.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "RecipesListTableViewCell.h"

@interface RecipeDetailViewController (){
    NSMutableArray *ingridients;
    NSMutableArray *steps;
}

@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ingridients = [NSMutableArray arrayWithArray:@[@"Ingridient 1", @"ingridient 2", @"ingridient 3",
                                                   @"Ingridient 1", @"ingridient 2", @"ingridient 3",
                                                   @"Ingridient 1", @"ingridient 2", @"ingridient 3",
                                                   @"Ingridient 1", @"ingridient 2", @"ingridient 3"]];
    steps = [NSMutableArray arrayWithArray:@[@"step 1", @"step 2", @"step 3", @"step 4", @"step 5", @"step 6"]];
    
    [self setIngridientsTableViewHeight];
    [self.recipeInfoTableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.recipeInfoTableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    // Do any additional setup after loading the view.
}
- (void) setIngridientsTableViewHeight{
    self.ingiridnetsTableHeightConstraint.constant = ingridients.count * 44.0;
    self.stepTableViewHeightConstraint.constant = steps.count * 44.0;
    self.viewHeightConstraint.constant = self.ingiridnetsTableHeightConstraint.constant + self.stepTableViewHeightConstraint.constant + 320;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([tableView isEqual:self.recipeInfoTableView]){
        return 1;
    } else if([tableView isEqual:self.ingridientsTableView]){
        return ingridients.count;
    } else {
        return steps.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
    
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
    } else {
        static NSString *CellIdentifier = @"stepCell";
        UITableViewCell *cell = [self.stepsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = steps[indexPath.row];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
