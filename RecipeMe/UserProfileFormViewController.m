//
//  UserProfileFormViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 30.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "UserProfileFormViewController.h"
#import "UserViewController.h"
#import <UIImageView+AFNetworking.h>
#import "ServerConnection.h"
@interface UserProfileFormViewController (){
    UIActionSheet *userImagePopup;
    UIImagePickerController *avatarPicker;
}

@end

@implementation UserProfileFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomBarButtons];
    [self setDefaultData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DefautInfo setters
- (void) setDefaultData{
    [self setPlaceholders];
    [self setImageData];
    if(self.user.surname != [NSNull null]) self.surnameField.text = self.user.surname;
    if(self.user.name != [NSNull null]) self.nameField.text = self.user.name;
    if(self.user.nickname != [NSNull null]) self.nickName.text = self.user.nickname;
}

- (void) setImageData{
    NSURL *url = [NSURL URLWithString:self.user.avatarUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"user8.png"];
    [self.userAvatar setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userAvatar.image = image;
    } failure:nil];
    self.userAvatar.clipsToBounds = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.userAvatar setUserInteractionEnabled:YES];
    [self.userAvatar addGestureRecognizer:singleTap];
}

- (void) imageTap:(id) sender{
    userImagePopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"recipe_image_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:
                        NSLocalizedString(@"recipe_image_collection", nil),
                        NSLocalizedString(@"recipe_image_camera", nil),
                        nil];
    userImagePopup.tag = 1;
    [userImagePopup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
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

- (void) callImagePicker: (UIImagePickerControllerSourceType *) type andValue: (BOOL) value{
        avatarPicker = [[UIImagePickerController alloc] init];
        avatarPicker.delegate = self;
        avatarPicker.allowsEditing = YES;
        avatarPicker.sourceType = type;
        [self presentViewController:avatarPicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSString *imageableType;
    self.userAvatar.image = chosenImage;
    imageableType = @"Recipe";
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void) setPlaceholders{
    [self.surnameField setPlaceholder:NSLocalizedString(@"profile_surname", nil)];
    [self.nameField setPlaceholder:NSLocalizedString(@"profile_name", nil)];
    [self.nickName setPlaceholder:NSLocalizedString(@"profile_nickname", nil)];
}

- (void) setCustomBarButtons{
    UIButton* customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"success-check.png"] forState:UIControlStateNormal];
    [customButton setTitle:NSLocalizedString(@"profile_save_form", nil) forState:UIControlStateNormal];
    [customButton sizeToFit];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"check-failed.png"] forState:UIControlStateNormal];
    [leftButton setTitle:NSLocalizedString(@"profile_cancel_form", nil) forState:UIControlStateNormal];
    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [customButton addTarget:self action:@selector(updateUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.rightBarButtonItem = customBarButtonItem; // or self.navigationItem.rightBarButtonItem
}

#pragma mark - BarButtomItems actions

- (void) backButton: (UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableDictionary *) paramsForUser{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:self.user.id forKey:@"id"];
    if(![self.surnameField.text  isEqual: @""]) [params setObject:self.surnameField.text forKey:@"surname"];
    if(![self.nameField.text  isEqual: @""]) [params setObject:self.nameField.text forKey:@"name"];
    if(![self.nickName.text  isEqual: @""]) [params setObject:self.nickName.text forKey:@"nickname"];
//    NSMutableDictionary *userParam = [NSMutableDictionary new];
//    [userParam setObject:params forKey:@"user"];
    return params;
}
- (void) updateUserProfile: (UIButton *) button{
    [[ServerConnection sharedInstance] uploadDataWithParams:[self paramsForUser] url: @"/users/update_profile" image:self.userAvatar.image andComplition:^(id data, BOOL success){
        if(success){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
        
        }
    }];
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
