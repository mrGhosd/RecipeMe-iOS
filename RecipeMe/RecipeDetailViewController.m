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
#import "StepHeaderTableViewCell.h"
#import "IngridientsTableViewCell.h"
#import "IngridientHeaderTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentHeaderTableViewCell.h"
#import <MBProgressHUD.h>
#import "ServerConnection.h"
#import "Step.h"
#import "Comment.h"
#import "Ingridient.h"
#import "commentForm.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>

@interface RecipeDetailViewController (){
    int selectedIndex;
    float currentCellHeight;
    ServerConnection *connection;
    NSMutableArray *ingridients;
    NSMutableArray *steps;
    NSMutableArray *comments;
}

@end

@implementation RecipeDetailViewController

float const stepHeight = 70;
float const commentHeight = 50;
float const defaultCellHeight = 44;
float const recipeCellInfoHeight = 250;

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex = -1;
    connection = [ServerConnection sharedInstance];
    
    [self loadRecipe];
    [self.recipeInfoTableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.recipeInfoTableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    [self.stepsTableView registerClass:[StepTableViewCell class] forCellReuseIdentifier:@"stepCell"];
    [self.stepsTableView registerNib:[UINib nibWithNibName:@"StepTableViewCell" bundle:nil]
                   forCellReuseIdentifier:@"stepCell"];
    
    [self.stepsTableView registerClass:[StepHeaderTableViewCell class] forCellReuseIdentifier:@"stepHeaderCell"];
    [self.stepsTableView registerNib:[UINib nibWithNibName:@"StepHeaderTableViewCell" bundle:nil]
              forCellReuseIdentifier:@"stepHeaderCell"];
    
    [self.ingridientsTableView registerClass:[IngridientsTableViewCell class] forCellReuseIdentifier:@"ingridientsCell"];
    [self.ingridientsTableView registerNib:[UINib nibWithNibName:@"IngridientsTableViewCell" bundle:nil]
              forCellReuseIdentifier:@"ingridientsCell"];
    
    [self.ingridientsTableView registerClass:[IngridientHeaderTableViewCell class] forCellReuseIdentifier:@"ingridientsHeaderCell"];
    [self.ingridientsTableView registerNib:[UINib nibWithNibName:@"IngridientHeaderTableViewCell" bundle:nil]
                    forCellReuseIdentifier:@"ingridientsHeaderCell"];
    
    [self.commentsTableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil]
                    forCellReuseIdentifier:@"commentCell"];
    
    [self.commentsTableView registerClass:[CommentHeaderTableViewCell class] forCellReuseIdentifier:@"commentHeaderCell"];
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"CommentHeaderTableViewCell" bundle:nil]
                    forCellReuseIdentifier:@"commentHeaderCell"];

    // Do any additional setup after loading the view.
}
- (void) setIngridientsTableViewHeight{
    self.ingiridnetsTableHeightConstraint.constant = ingridients.count * commentHeight;
    self.stepTableViewHeightConstraint.constant = steps.count * stepHeight;
    self.commentsTableViewHeightConstraint.constant = comments.count * defaultCellHeight;
    self.viewHeightConstraint.constant = self.ingiridnetsTableHeightConstraint.constant + self.stepTableViewHeightConstraint.constant + self.commentsTableViewHeightConstraint.constant + self.recipeInfoTableView.frame.size.height;
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
        ingridients = [NSMutableArray arrayWithArray:self.recipe.ingridients];
        comments = [NSMutableArray arrayWithArray:self.recipe.comments];
//        [steps addObjectsFromArray:self.recipe.steps];
        [self setIngridientsTableViewHeight];
        [steps insertObject:@"Шаги" atIndex:0];
        [ingridients insertObject:@"Ингридиенты" atIndex:0];
        [comments insertObject:@"Комментарии" atIndex:0];
        [self.recipeInfoTableView reloadData];
        [self.stepsTableView reloadData];
        [self.ingridientsTableView reloadData];
        [self.commentsTableView reloadData];
    }
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if([tableView isEqual:self.ingridientsTableView]){
        if(indexPath.row ==0){
            static NSString *CellIdentifier = @"ingridientsHeaderCell";
            IngridientHeaderTableViewCell *cell = (IngridientHeaderTableViewCell *)[self.ingridientsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.title.text = ingridients[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
        static NSString *CellIdentifier = @"ingridientsCell";
        Ingridient *ingridient = ingridients[indexPath.row];
        IngridientsTableViewCell *cell = (IngridientsTableViewCell *)[self.ingridientsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IngridientsTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
            cell.ingridientName.text = ingridient.name;
            cell.ingridientSize.text = ingridient.size;
        return cell;
        }
    } else if([tableView isEqual:self.stepsTableView]){
        if(indexPath.row == 0){
            static NSString *CellIdentifier = @"stepHeaderCell";
            StepHeaderTableViewCell *cell = (StepHeaderTableViewCell *)[self.stepsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.title.text = steps[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            static NSString *CellIdentifier = @"stepCell";
            Step *step = steps[indexPath.row];
            StepTableViewCell *cell = (StepTableViewCell *)[self.stepsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StepTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell setStepData:step];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
            [tap setNumberOfTapsRequired:1];
            [cell.stepDescription addGestureRecognizer:tap];
            return cell;
        }
    } else {
        if(indexPath.row == 0){
            static NSString *CellIdentifier = @"commentHeaderCell";
            CommentHeaderTableViewCell *cell = (CommentHeaderTableViewCell *)[self.commentsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.title.text = comments[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            static NSString *CellIdentifier = @"commentCell";
            Comment *comment = comments[indexPath.row];
            CommentTableViewCell *cell = (CommentTableViewCell *)[self.commentsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell setCommentData:comment];
            return cell;
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:self.stepsTableView] || [tableView isEqual:self.commentsTableView]){
        [self rowWasSelected:tableView inIndexPAth:indexPath];
    }
}

- (void) rowWasSelected: (UITableView *) tableView inIndexPAth: (NSIndexPath *) indexPath{
    if([tableView isEqual:self.stepsTableView]){
        [self.view endEditing:YES];
        if(selectedIndex == indexPath.row){
            selectedIndex = -1;
            [self changeCellTextHeightAt:indexPath withCondition:NO];
            [self.stepsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
        
        if(selectedIndex != -1){
            NSIndexPath *prevPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            selectedIndex = indexPath.row;
            [self changeCellTextHeightAt:indexPath withCondition:NO];
            [self.stepsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        selectedIndex = indexPath.row;
        [self changeCellTextHeightAt:indexPath withCondition:YES];
        [self.stepsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}
- (void) changeViewHeight: (float) value to: (BOOL) condition{
    if(condition){
        self.stepTableViewHeightConstraint.constant += value - 70.0;
        self.viewHeightConstraint.constant += self.stepTableViewHeightConstraint.constant - 300.0;
    } else{
        self.stepTableViewHeightConstraint.constant -= value - 70.0;
        self.viewHeightConstraint.constant -= self.stepTableViewHeightConstraint.constant + 424.0;
    }
}
- (void) changeCellTextHeightAt:(NSIndexPath *)path withCondition: (BOOL) value{
    CGSize size = [[steps[path.row] desc] sizeWithAttributes:nil];
    currentCellHeight = size.width / 9;
    [self changeViewHeight:currentCellHeight to:value];
//    self.stepTableViewHeightConstraint.constant += currentCellHeight;
//    self.viewHeightConstraint.constant += self.stepTableViewHeightConstraint.constant;
//    [self.stepsTableView cellForRowAtIndexPath:path];
}
-(void)tapped:(UITapGestureRecognizer *)recognizer{
    NSIndexPath *path = [self.stepsTableView indexPathForCell:[[recognizer.view superview] superview]];
    [self.stepsTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.recipeInfoTableView]){
        return recipeCellInfoHeight;
    } else if([tableView isEqual:self.stepsTableView]){
        if(indexPath.row == 0){
            return defaultCellHeight;
        } else {
            if(selectedIndex == indexPath.row){
                return currentCellHeight;
            } else {
                return stepHeight;
            }
        }
    } else if([tableView isEqual:self.commentsTableView]){
        if(indexPath.row == 0){
            return defaultCellHeight;
        } else {
            return commentHeight;
        }
        
    } else {
        return defaultCellHeight;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if([tableView isEqual:self.commentsTableView]){
        return 110;
    } else {
        return 0;
    }
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if([tableView isEqual:self.commentsTableView]){
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
//        view.backgroundColor = [UIColor greenColor];
//        return view;
//    } else {
//        return nil;
//    }
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if([tableView isEqual:self.commentsTableView]){
        commentForm *form = [[[NSBundle mainBundle] loadNibNamed:@"commentFormView" owner:self options:nil] firstObject];
        return form;
    } else {
        return nil;
    }   
}
- (void) viewDidDisappear:(BOOL)animated{
    self.recipe = nil;
    self.commentsTableView = nil;
    self.stepsTableView = nil;
    self.ingridientsTableView = nil;
    comments = nil;
    steps = nil;
    ingridients = nil;
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
