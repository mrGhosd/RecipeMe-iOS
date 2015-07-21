//
//  RecipeFormViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 18.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "RecipeFormViewController.h"
#import "ServerConnection.h"

@interface RecipeFormViewController (){
    ServerConnection *connection;
}

@end

@implementation RecipeFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    connection = [ServerConnection sharedInstance];
    self.formViewHeightConstraint.constant += 500.0;
    [self setNamesForInputs];
    // Do any additional setup after loading the view.
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
