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
#import "RecipeFormHeader.h"
#import "IngridientsFormTableViewCell.h"
#import "Ingridient.h"
#import "StepsFormTableViewCell.h"
#import "RMCategory.h"
#import <UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>


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
    float prevStepHeight;
    NSMutableArray *ingridients;
    NSMutableArray *steps;
    StepsFormTableViewCell *selectedCell;
    UIActionSheet *recipeImagePopup;
    UIActionSheet *stepImagePopup;
    UIImagePickerController *recipePicker;
    UIImagePickerController *stepPicker;
    float keyboardHeight;
}

@end

@implementation RecipeFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recipeTitle.delegate = self;
    categories = [NSMutableArray new];
    connection = [ServerConnection sharedInstance];
    auth = [AuthorizationManager sharedInstance];
    //Категории должны загружатся в первую очередь
    [self defaultFormConfig];
    [self loadCategoriesList];
    [self setNamesForInputs];
    // Do any additional setup after loading the view.
}

- (void) registerCellClasses{
    [self.ingridientsTableView registerClass:[IngridientsFormTableViewCell class] forCellReuseIdentifier:@"ingridientsCell"];
    [self.ingridientsTableView registerNib:[UINib nibWithNibName:@"IngridientsFormTableViewCell" bundle:nil]
                   forCellReuseIdentifier:@"ingridientsCell"];
    
    [self.stepsTableView registerClass:[StepsFormTableViewCell class] forCellReuseIdentifier:@"stepsCell"];
    [self.stepsTableView registerNib:[UINib nibWithNibName:@"StepsFormTableViewCell" bundle:nil]
                    forCellReuseIdentifier:@"stepsCell"];
}
- (void) defaultFormConfig{
    [self registerCellClasses];
    self.formViewHeightConstraint.constant += 110.0;
    self.recipeDescription.delegate = self;
    [self setInputPlaceholders];
    ingridients = [NSMutableArray new];
    steps = [NSMutableArray new];
    difficultIDs = @[@"easy", @"medium", @"hard"];
    difficults = @[NSLocalizedString(@"recipes_difficult_easy", nil),
                   NSLocalizedString(@"recipes_difficult_medium", nil),
                   NSLocalizedString(@"recipes_difficult_hard", nil)];
    [self setFormHeader];
    [self.recipeDescription sizeToFit];
    [self.recipeDescription layoutIfNeeded];
    [self setDifficultPickerView];
    [self setCategoryPickerView];
    
}
- (void) setFormHeader{
    if(self.recipe){
        [self.navigationBar.items[0] setTitle:NSLocalizedString(@"recipe_edit_form_title", nil)];
    }else{
        [self.navigationBar.items[0] setTitle:NSLocalizedString(@"recipe_new_form_title", nil)];
    }
    
    [self.saveButton setTitle:NSLocalizedString(@"save_recipe", nil)];
    [self.cancelButton setTitle:NSLocalizedString(@"cancel_recipe", nil)];
//    self.saveButton.title = ;
}
- (void) loadCategoriesList{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [connection sendDataToURL:@"/categories" parameters:nil requestType:@"GET" andComplition:^(id data, BOOL success){
        if(success){
            [self parseCategories:data];
        } else {
            
        }
    }];
}

- (void) parseCategories:(id)data{
    if(data != [NSNull null]){
        for(NSDictionary *category in data){
            RMCategory *cat = [[RMCategory alloc] initWithParameters:category];
            [categories addObject:cat];
        }
        if(self.recipe){
            [self updateRecipe];
        }
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    [self customizeTextField:self.recipeTitle withIcon:@"recipeTitleIcon.png" andPlaceholder:NSLocalizedString(@"form_title", nil)];
    [self customizeTextField:self.recipeTime withIcon:@"recipeTimeIcon.png" andPlaceholder:NSLocalizedString(@"form_time", nil)];
    [self customizeTextField:self.recipePersons withIcon:@"recipePersonsIcon.png" andPlaceholder:NSLocalizedString(@"form_persons", nil)];
    [self customizeTextField:self.recipeDifficult withIcon:@"recipeDifficultIcon.png" andPlaceholder:NSLocalizedString(@"form_difficult", nil)];
    [self customizeTextField:self.recipeCategory withIcon:@"category.png" andPlaceholder:NSLocalizedString(@"form_category", nil)];
    [self setRecipeDescriptionApperance];
    [self setTableViewApperance];
}
- (void) setRecipeDescriptionApperance{
    self.recipeDescription.backgroundColor = [UIColor clearColor];
    self.recipeDescription.textColor = [UIColor whiteColor];
    self.recipeDescription.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.recipeDescription.layer.borderWidth = 2.0;
    self.recipeDescription.layer.cornerRadius = 8.0;
}
- (void)setTableViewApperance{
    self.ingridientsTableView.backgroundColor = [UIColor clearColor];
    self.stepsTableView.backgroundColor = [UIColor clearColor];
}
- (void) updateRecipe{
    [self setRecipeMainImage];
    self.recipeTitle.text = self.recipe.title;
    self.recipePersons.text = [NSString stringWithFormat:@"%@", self.recipe.persons];
    self.recipeTime.text = [NSString stringWithFormat:@"%@", self.recipe.time];
    self.recipeDescription.text = self.recipe.desc;
    [self setRecipeDifficultValue];
    [self setRecipeCategoryValue];
    [self setRecipeIngridients];
    [self setRecipeSteps];
}

- (void) setRecipeIngridients{
    for(Ingridient *ingridient in self.recipe.ingridients){
        [ingridients addObject:ingridient];
        [self.ingridientsTableView reloadData];
        [self increaseViewsHeight:YES];
    }
}

- (void) setRecipeSteps{
    for(Step *step in self.recipe.steps){
        [steps addObject:step];
        [self.stepsTableView reloadData];
        [self increaseViewsHeight:NO];
    }
}

- (void) setRecipeDifficultValue{
    NSString *recipeDifficultTitle = [NSString stringWithFormat:@"recipes_difficult_%@", self.recipe.difficult];
    self.recipeDifficult.text = NSLocalizedString(recipeDifficultTitle, nil);
    NSInteger index = [difficults indexOfObject:NSLocalizedString(recipeDifficultTitle, nil)];
    selectedDifficult = difficultIDs[index];
}

- (void) setRecipeCategoryValue{
    for(RMCategory *cat in categories){
        if([cat.id isEqual:self.recipe.categoryId]){
            selectedCategory = cat.id;
            self.recipeCategory.text = cat.title;
        }
    }
}

- (void) setRecipeMainImage{
    NSURL *url = [NSURL URLWithString:self.recipe.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"recipes_placeholder.png"];
    [self.recipeImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.recipeImage.image = image;
    } failure:nil];
    self.recipeImage.clipsToBounds = YES;
}
- (void) setNamesForInputs{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.recipeImage setUserInteractionEnabled:YES];
    [self.recipeImage addGestureRecognizer:singleTap];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tapDetected: (id) sender{
    recipeImagePopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"recipe_image_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:
                            NSLocalizedString(@"recipe_image_collection", nil),
                            NSLocalizedString(@"recipe_image_camera", nil),
                            nil];
    recipeImagePopup.tag = 1;
    [recipeImagePopup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([popup isEqual:recipeImagePopup]){
        switch(buttonIndex){
            case 0:
                [self callImagePicker:UIImagePickerControllerSourceTypePhotoLibrary andValue:YES];
                break;
            case 1:
                [self callImagePicker:UIImagePickerControllerSourceTypeCamera andValue:YES];
                break;
            case 2:
                break;
        }
    }
    if([popup isEqual:stepImagePopup]){
        switch(buttonIndex){
            case 0:
                [self callImagePicker:UIImagePickerControllerSourceTypePhotoLibrary andValue:NO];
                break;
            case 1:
                [self callImagePicker:UIImagePickerControllerSourceTypeCamera andValue:NO];
                break;
            case 2:
                break;
        }
    }
}

- (void) callImagePicker: (UIImagePickerControllerSourceType *) type andValue: (BOOL) value{
    if(value){
        recipePicker = [[UIImagePickerController alloc] init];
        recipePicker.delegate = self;
        recipePicker.allowsEditing = YES;
        recipePicker.sourceType = type;
        [self presentViewController:recipePicker animated:YES completion:NULL];
    } else {
        stepPicker = [[UIImagePickerController alloc] init];
        stepPicker.delegate = self;
        stepPicker.allowsEditing = YES;
        stepPicker.sourceType = type;
        [self presentViewController:stepPicker animated:YES completion:NULL];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSString *imageableType;
    if([picker isEqual:recipePicker]){
        imageableType = @"Recipe";
    }
    if([picker isEqual:stepPicker]){
        imageableType = @"Step";
    }
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [connection uploadImage:chosenImage withParams:@{@"imageable_type": imageableType} andComplition:^(id data, BOOL success){
        NSString *imageableType;
        if(success){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([picker isEqual:recipePicker]){
                self.recipeImage.image = chosenImage;
                self.recipeImageId = data[@"id"];
            }
            if([picker isEqual:stepPicker]){
                selectedCell.stepImage.image = chosenImage;
                selectedCell.stepImageId = data[@"id"];
                selectedCell.step.imageId = data[@"id"];
            }
        } else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"system-error-title", nil) message: NSLocalizedString(@"image_upload_failure_message", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
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
        return [categories[row] title];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:difficultPicker]){
        self.recipeDifficult.text = difficults[row];
        selectedDifficult = difficultIDs[row];
    } else {
        self.recipeCategory.text = [categories[row] title];
        selectedCategory = [categories[row] id];
    }
}

#pragma mark - Save and Cancel Form event handlers
- (NSDictionary *) getRecipeFormData{
    NSMutableDictionary *recipeParams = [NSMutableDictionary dictionaryWithDictionary:[self setParamsForRecipe]];
    if(ingridients.count > 0){
        [recipeParams setObject:[self setIngridientAttributes] forKey:@"recipe_ingridients_attributes"];
    }
    if(steps.count > 0){
        [recipeParams setObject:[self setStepsAttributes] forKey:@"steps_attributes"];
    }
    return recipeParams;
}
- (NSMutableDictionary *) setParamsForRecipe{
    NSMutableDictionary *recipeParams = [NSMutableDictionary new];
    if(self.recipeTitle.text) [recipeParams setObject:self.recipeTitle.text forKey:@"title"];
    if(selectedCategory) [recipeParams setObject:selectedCategory forKey:@"category_id"];
    if(self.recipeDescription.text) [recipeParams setObject:self.recipeDescription.text forKey:@"description"];
    if(selectedDifficult) [recipeParams setObject:selectedDifficult forKey:@"difficult"];
    if(auth.currentUser.id) [recipeParams setObject:auth.currentUser.id forKey:@"user_id"];
    if(self.recipeTime.text) [recipeParams setObject:self.recipeTime.text forKey:@"time"];
    if(self.recipePersons.text) [recipeParams setObject:self.recipePersons.text forKey:@"persons"];
    if(self.recipeImageId) [recipeParams setObject:@{@"id": self.recipeImageId} forKey:@"image_attributes"];
    return recipeParams;
}

- (NSMutableArray *) setIngridientAttributes{
    NSMutableArray *ingridientsAttributes = [NSMutableArray new];
    for(Ingridient *ingridient in ingridients){
        NSMutableDictionary *ingridientParams = [NSMutableDictionary new];
        if(ingridient.size) [ingridientParams setObject:ingridient.size forKey:@"size"];
        if(ingridient.name){
            NSMutableDictionary *attrsForIngridient = [NSMutableDictionary new];
            if(ingridient.id) [attrsForIngridient setObject:ingridient.id forKey:@"id"];
            if(ingridient.name) [attrsForIngridient setObject:ingridient.name forKey:@"name"];
            [ingridientParams setObject:attrsForIngridient forKey:@"ingridient_attributes"];
        }
        [ingridientsAttributes addObject:ingridientParams];
    }
    return ingridientsAttributes;
}
- (NSMutableArray *) setStepsAttributes{
    NSMutableArray *stepsAttributes = [NSMutableArray new];
    for(Step *step in steps){
        NSMutableDictionary *stepParams = [NSMutableDictionary new];
        if(step.id) [stepParams setObject:step.id forKey:@"id"];
        if(step.desc) [stepParams setObject:step.desc forKey:@"description"];
        if(step.imageId) {
            NSDictionary *dict = @{@"id": step.imageId};
            [stepParams setObject:dict forKey:@"image"];
        }
        [stepsAttributes addObject:stepParams];
    }
    return stepsAttributes;
}
- (IBAction)saveRecipe:(id)sender {
    [self setDefaultApperanceForRecipeElements];
    [self setDefaultCellApperanceForIngridientCells];
    [self setDefaulCellApperanceForStepsCells];
    NSString *url;
    NSString *requestType;
    if(self.recipe){
        url = [NSString stringWithFormat:@"/recipes/%@", self.recipe.id];
        requestType = @"PUT";
    } else {
        url = @"/recipes";
        requestType = @"POST";
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [connection sendDataToURL:url parameters:[self getRecipeFormData] requestType:requestType andComplition:^(id data, BOOL success){
        if(success){
            if(requestType == @"POST"){
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"recipeWasCreated"
                 object:data];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            ServerError *error = [[ServerError alloc] initWithData:data];
            error.delegate = self;
            [error handle];
        }
    }];
}

- (void) handleServerFormErrorWithError: (id) error{
    NSDictionary *errorMessage = [error message];
    [self handleRecipeErrors:errorMessage];
    if(errorMessage[@"steps"]){
        [self handleStepsErrors:errorMessage[@"steps"]];
    }
    if(errorMessage[@"ingridients"]){
        [self handleIngridientsErrors:errorMessage[@"ingridients"]];
    }
}
- (void) handleServerErrorWithError:(id) error{
    if([[error status] isEqualToNumber:@0]){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"system-error-title", nil) message: NSLocalizedString(@"recipe_save_failure_message", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
    }
}
- (void) handleRecipeErrors:(NSDictionary *) errors{
    if(errors[@"title"]) [self setColorToElement:self.recipeTitle withColor:[UIColor redColor]];
    if(errors[@"description"]) [self setColorToElement:self.recipeDescription withColor:[UIColor redColor]];
    if(errors[@"time"]) [self setColorToElement:self.recipeTime withColor:[UIColor redColor]];
    if(errors[@"persons"]) [self setColorToElement:self.recipePersons withColor:[UIColor redColor]];
    if(errors[@"difficult"]) [self setColorToElement:self.recipeDifficult withColor:[UIColor redColor]];
    if(errors[@"category_id"]) [self setColorToElement:self.recipeCategory withColor:[UIColor redColor]];
    if(errors[@"image"]) [self setColorToElement:self.recipeImage withColor:[UIColor redColor]];
}
- (void) setColorToElement: (id) field withColor: (UIColor *) color{
    [[field layer] setBorderColor:[color CGColor]];
    [[field layer] setBorderWidth:2.0];
    [[field layer] setCornerRadius:8.0];
}
- (void) setDefaultApperanceForRecipeElements{
    self.recipeTitle.layer.borderColor = [[UIColor clearColor] CGColor];
    self.recipeImage.layer.borderColor = [[UIColor clearColor] CGColor];
    self.recipePersons.layer.borderColor = [[UIColor clearColor] CGColor];
    self.recipeTime.layer.borderColor = [[UIColor clearColor] CGColor];
    self.recipeDifficult.layer.borderColor = [[UIColor clearColor] CGColor];
    self.recipeCategory.layer.borderColor = [[UIColor clearColor] CGColor];
    self.recipeDescription.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void) setDefaulCellApperanceForStepsCells{
    NSArray *cells = [self.stepsTableView visibleCells];
    for(StepsFormTableViewCell *cell in cells){
        cell.stepImage.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.stepText.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
}

- (void) setDefaultCellApperanceForIngridientCells{
    NSArray *cells = [self.ingridientsTableView visibleCells];
    for(IngridientsFormTableViewCell *cell in cells){
        cell.ingridientName.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.ingridientSize.layer.borderColor = [[UIColor clearColor] CGColor];
    }
}

- (void) handleIngridientsErrors: (NSArray *) ingridientsErrors{
    NSArray *cells = [self.ingridientsTableView visibleCells];
    for(int i = 0; i < ingridientsErrors.count; i++){
        IngridientsFormTableViewCell *cell = (IngridientsFormTableViewCell *) cells[i];
        if(ingridientsErrors[i][[NSString stringWithFormat:@"%d", i]][@"size"]){
            cell.ingridientSize.layer.borderColor = [[UIColor redColor] CGColor];
            cell.ingridientSize.layer.borderWidth = 2.0;
            cell.ingridientSize.layer.cornerRadius = 8.0;
        }
        if(ingridientsErrors[i][[NSString stringWithFormat:@"%d", i]][@"name"]){
            cell.ingridientName.layer.borderColor = [[UIColor redColor] CGColor];
            cell.ingridientName.layer.borderWidth = 2.0;
            cell.ingridientName.layer.cornerRadius = 8.0;

        }
    }
}

- (void) handleStepsErrors: (NSArray *) stepsErrors{
    NSArray *cells = [self.stepsTableView visibleCells];
    for(int i = 0; i < stepsErrors.count; i++){
        StepsFormTableViewCell *cell = (StepsFormTableViewCell *) cells[i];
        if(stepsErrors[i][[NSString stringWithFormat:@"%d", i]][@"description"]){
            cell.stepText.layer.borderColor = [[UIColor redColor] CGColor];
        }
        if(stepsErrors[i][[NSString stringWithFormat:@"%d", i]][@"image"]){
            cell.stepImage.layer.borderColor = [[UIColor redColor] CGColor];
            cell.stepImage.layer.borderWidth = 3.0;
            cell.stepImage.layer.cornerRadius = 8.0;
        }
    }
}
- (IBAction)dismissForm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) increaseViewsHeight: (BOOL) value{
    if(value){
        float tableViewHeight = 44.0;
        self.ingridientsTableViewHeightConstraint.constant += tableViewHeight;
        self.formViewHeightConstraint.constant += tableViewHeight;
        [self.ingridientsTableView reloadData];
    } else {
        float tableViewHeight = 60.0;
        self.stepsTableViewHeightConstraint.constant += tableViewHeight;
        self.formViewHeightConstraint.constant += tableViewHeight;
        [self.stepsTableView reloadData];
    }
}

- (void) decreaseViewsHeight: (BOOL) value{
    if(value){
        float tableViewHeight = 44.0;
        self.ingridientsTableViewHeightConstraint.constant -= tableViewHeight;
        self.formViewHeightConstraint.constant -= tableViewHeight;
        [self.ingridientsTableView reloadData];
    } else {
        float tableViewHeight = 60.0;
        self.stepsTableViewHeightConstraint.constant -= tableViewHeight;
        self.formViewHeightConstraint.constant -= tableViewHeight;
        [self.stepsTableView reloadData];
    }
}

#pragma - mark UITextView delegate
- (void) textViewDidChange:(UITextView *)textView{
    if([textView isEqual:self.recipeDescription]){
        if(previousDescHeight - self.recipeDescription.contentSize.height != 0){
            previousDescHeight = self.recipeDescription.contentSize.height;
            self.recipeDescriptionTextViewHeight.constant = self.recipeDescription.contentSize.height;
            self.formViewHeightConstraint.constant += self.recipeDescription.contentSize.height / 5;
        }
    }
    
}

#pragma mark - UITableView Delegate and DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.ingridientsTableView]){
        return 44;
    } else {
        return 60.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.ingridientsTableView) {
        return ingridients.count;
        
    } else {
        return steps.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.ingridientsTableView]){
        static NSString *CellIdentifier = @"ingridientsCell";
        IngridientsFormTableViewCell *cell = (IngridientsFormTableViewCell *) [self.ingridientsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Ingridient *ingridient = ingridients[indexPath.row];
        [cell setIngridientData:ingridient];
         [cell.deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        static NSString *CellIdentifier = @"stepsCell";
        StepsFormTableViewCell *cell = (StepsFormTableViewCell *) [self.stepsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setStepData:steps[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell.deleteButton addTarget:self action:@selector(deleteStepButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void) deleteButton: (id) sender{
    NSIndexPath *indexPath = [self.ingridientsTableView indexPathForCell:[[sender superview] superview]];
    Ingridient *ingridient = ingridients[indexPath.row];
    if(ingridient.id){
        [ingridient destroy];
    }
    [ingridients removeObjectAtIndex:indexPath.row];
    [self decreaseViewsHeight:YES];

}

- (void) deleteStepButton: (id) sender{
    NSIndexPath *indexPath = [self.stepsTableView indexPathForCell:[[sender superview] superview]];
    Step *step = steps[indexPath.row];
    if(step.id){
        [step destroy];
    }
    [steps removeObjectAtIndex:indexPath.row];
    [self decreaseViewsHeight:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RecipeFormHeader *view = [[[NSBundle mainBundle] loadNibNamed:@"RecipeFormHeader" owner:self options:nil] firstObject];
    if([tableView isEqual:self.ingridientsTableView]){
        view.headerTitle.text = NSLocalizedString(@"ingridients", nil);
        [view.headerButton addTarget:self action:@selector(addIngridient:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        view.headerTitle.text = NSLocalizedString(@"steps", nil);
        [view.headerButton addTarget:self action:@selector(addStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    return view;
}
#pragma mark - Steps and Ingridients adding on form
- (void) addIngridient: (id) sender{
    Ingridient *ingridient = [[Ingridient alloc] init];
    [ingridients addObject:ingridient];
    [self increaseViewsHeight:YES];
}
- (void) addStep: (id) sender{
    Step *step = [[Step alloc] init];
    [steps addObject:step];
    [self increaseViewsHeight:NO];
}

#pragma mark - StepCellDelegate methods
- (void) increaseStepsTableViewBy: (float) value{
    if(prevStepHeight - value != 0){
        prevStepHeight = value;
        if(value > 0){
            self.stepsTableViewHeightConstraint.constant += value;
            self.formViewHeightConstraint.constant += value;
        } else {
            self.stepsTableViewHeightConstraint.constant -= value;
            self.formViewHeightConstraint.constant -= value;
        }
    }
}

- (void) selectImageForCell:(StepsFormTableViewCell *) cell{
    selectedCell = cell;
    stepImagePopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"recipe_image_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:
                        NSLocalizedString(@"recipe_image_collection", nil),
                        NSLocalizedString(@"recipe_image_camera", nil),
                        nil];
    stepImagePopup.tag = 1;
    [stepImagePopup showInView:self.view];
}

#pragma mark - RecipeFormFields CustomizationView
- (void) customizeTextField: (UITextField *) textField withIcon: (NSString *) iconName andPlaceholder: (NSString *) placeholder{
    textField.layer.masksToBounds = YES;
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    imgView.image = [UIImage imageNamed:iconName];
    textField.leftView = imgView;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    textField.attributedPlaceholder = str;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *keyboardValues = [notification userInfo];
    id keyboardSize = keyboardValues[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrame = [keyboardSize CGRectValue];
    int orientation = (int)[[UIDevice currentDevice] orientation];
    float prevViewHeight = self.formViewHeightConstraint.constant;
    keyboardHeight = keyboardFrame.size.height;
    self.formViewHeightConstraint.constant += keyboardHeight;
}
- (void) keyboardWillHide:(NSNotification *) notification{
    self.formViewHeightConstraint.constant -= keyboardHeight;
    keyboardHeight = 0;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void) textFieldDidBeginEditing:(UITextField *)textField{
}

@end
