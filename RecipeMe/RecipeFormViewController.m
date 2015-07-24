//
//  RecipeFormViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 18.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipeFormViewController.h"
#import "ServerConnection.h"
#import "AuthorizationManager.h"

@interface RecipeFormViewController (){
    ServerConnection *connection;
    AuthorizationManager *auth;
    UIPickerView *difficultPicker;
    UIPickerView *categoriesPicker;
    NSMutableArray *difficults;
    NSArray *difficultIDs;
    NSMutableArray *categories;
    NSString *selectedDifficult;
    NSNumber *selectedCategory;
    float previousDescHeight;
}

@end

@implementation RecipeFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    connection = [ServerConnection sharedInstance];
    auth = [AuthorizationManager sharedInstance];
    //Категории должны загружатся в первую очередь
    [self loadCategoriesList];
    [self defaultFormConfig];
    if(self.recipe){
        [self updateRecipe];
    } else {
        [self createRecipe];
    }
    [self setNamesForInputs];
    // Do any additional setup after loading the view.
}
- (void) defaultFormConfig{
//    self.formViewHeightConstraint.constant += 500.0;
    self.recipeDescription.delegate = self;
    [self setInputPlaceholders];
    difficultIDs = @[@"easy", @"medium", @"hard"];
    difficults = @[NSLocalizedString(@"recipes_difficult_easy", nil),
                   NSLocalizedString(@"recipes_difficult_medium", nil),
                   NSLocalizedString(@"recipes_difficult_hard", nil)];
    [self.recipeDescription sizeToFit];
    [self.recipeDescription layoutIfNeeded];
    [self setDifficultPickerView];
    [self setCategoryPickerView];
}

- (void) loadCategoriesList{
    [connection sendDataToURL:@"/categories" parameters:nil requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            [self parseCategories:data];
        } else {
            
        }
    }];
}

- (void) parseCategories:(id)data{
    categories = [NSArray arrayWithArray:data];
}


- (void) createRecipe{

}
- (void) setDifficultPickerView{
    difficultPicker = [[UIPickerView alloc] init];
    difficultPicker.delegate = self;
    difficultPicker.dataSource = self;
    self.recipeDifficult.inputView = difficultPicker;
}

- (void) setCategoryPickerView{
    categoriesPicker = [[UIPickerView alloc] init];
    categoriesPicker.delegate = self;
    categoriesPicker.dataSource = self;
    self.recipeCategory.inputView = categoriesPicker;
}
- (void) setInputPlaceholders{
    [self.recipeTitle setPlaceholder:NSLocalizedString(@"form_title", nil)];
    [self.recipeTime setPlaceholder:NSLocalizedString(@"form_time", nil)];
    [self.recipePersons setPlaceholder:NSLocalizedString(@"form_persons", nil)];
    [self.recipeDifficult setPlaceholder:NSLocalizedString(@"form_difficult", nil)];
    [self.recipeCategory setPlaceholder:NSLocalizedString(@"form_category", nil)];
    [self.recipeDifficult setPlaceholder:NSLocalizedString(@"form_difficult", nil)];
    [self.recipeTags setPlaceholder:NSLocalizedString(@"form_tags", nil)];
}

- (void) updateRecipe{

}

- (void) setNamesForInputs{
    [self.navigationBar.items[0] setTitle:@"Recipe Form"];
    [self.saveButton setTitle:NSLocalizedString(@"save_recipe", nil)];
    [self.cancelButton setTitle:NSLocalizedString(@"cancel_recipe", nil)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.recipeImage setUserInteractionEnabled:YES];
    [self.recipeImage addGestureRecognizer:singleTap];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tapDetected: (id) sender{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"recipe_image_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:
                            NSLocalizedString(@"recipe_image_collection", nil),
                            NSLocalizedString(@"recipe_image_camera", nil),
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex)
    {
        case 0:
            [self callImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 1:
            [self callImagePicker:UIImagePickerControllerSourceTypeCamera];
            break;
        case 2:
            break;
    }
}

- (void) callImagePicker: (UIImagePickerControllerSourceType *) type{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = type;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.recipeImage.image = chosenImage;
    [connection uploadImage:chosenImage withParams:@{@"imageable_type": @"Recipe"} andComplition:^(id data, BOOL success){
        if(success){
            self.recipeImageId = data[@"id"];
        } else {
            
        }
    }];
    [picker dismissViewControllerAnimated:YES completion:NULL];    
}

- (void) changeAllViewsHeights:(float) value result: (BOOL) result{
    if(result){
        self.formViewHeightConstraint.constant += value;
        self.recipeDescriptionTextViewHeight.constant += value;
    } else {
        self.formViewHeightConstraint.constant -= value;
        self.recipeDescriptionTextViewHeight.constant -= value;
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
#pragma mark - PickerView delegate methods
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual:difficultPicker]){
        return difficults.count;
    } else {
        return categories.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    if([pickerView isEqual:difficultPicker]){
        return difficults[row];
    } else {
        return categories[row][@"title"];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:difficultPicker]){
        self.recipeDifficult.text = difficults[row];
        selectedDifficult = difficultIDs[row];
    } else {
        self.recipeCategory.text = categories[row][@"title"];
        selectedCategory = categories[row][@"id"];
    }
//    pickerView.removeFromSuperview;
}

#pragma mark - Save and Cancel Form event handlers
- (NSDictionary *) getRecipeFormData{
    return @{@"title": self.recipeTitle.text, @"category_id": selectedCategory, @"tag_list": self.recipeTags.text,
             @"image": @{@"id": self.recipeImageId}, @"description": self.recipeDescription.text, @"difficult": selectedDifficult, @"user_id": auth.currentUser.id, @"time": self.recipeTime.text, @"persons": self.recipePersons.text};
}
- (IBAction)saveRecipe:(id)sender {
    [connection sendDataToURL:@"/recipes" parameters:[self getRecipeFormData] requestType:@"POST" andComplition:^(id data, BOOL success){
        if(success){
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
        
        }
    }];
}

- (IBAction)dismissForm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - mark UITextView delegate
- (void) textViewDidChange:(UITextView *)textView{
    NSString *text = self.recipeDescription.text;
    if(previousDescHeight - self.recipeDescription.contentSize.height != 0){
        previousDescHeight = self.recipeDescription.contentSize.height;
        self.recipeDescriptionTextViewHeight.constant = self.recipeDescription.contentSize.height;
        self.formViewHeightConstraint.constant += self.recipeDescription.contentSize.height / 8;
    }
    
//    [self changeAllViewsHeights:self.recipeDescription.contentSize.height result:YES];
//    self.recipeDescription.frame = newFrame;
}
@end
