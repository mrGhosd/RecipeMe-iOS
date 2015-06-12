//
//  RecipesListViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 12.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipesListViewController.h"
#import "RecipesListTableViewCell.h"
#import "ServerConnection.h"
#import "Recipe.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>

@interface RecipesListViewController (){
    ServerConnection *connection;
    NSMutableArray *recipes;
}

@end

@implementation RecipesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    recipes = [NSMutableArray new];
    connection = [ServerConnection sharedInstance];
    [self.tableView registerClass:[RecipesListTableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipesListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"recipeCell"];
    [self loadRecipesList];
    // Do any additional setup after loading the view.
}

- (void) loadRecipesList{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [connection sendDataToURL:@"/recipes" parameters:nil requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            [self parseRecipes:data];
        } else {
        
        }
    }];
}
- (void) parseRecipes: (id) data{
    for(NSDictionary *recipe in data){
        Recipe *rec = [[Recipe alloc] initWithParameters:recipe];
        [recipes addObject:rec];
    }
    [self.tableView reloadData];
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
    return recipes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"recipeCell";
    Recipe *recipe = recipes[indexPath.row];
    __weak RecipesListTableViewCell *cell = (RecipesListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipesListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSURL *url = [NSURL URLWithString:recipe.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"kartofel.jpg"];
    [cell.imageView setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageView.image = image;
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.imageView.clipsToBounds = YES;
        
    } failure:nil];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
