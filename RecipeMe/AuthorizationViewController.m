//
//  AuthorizationViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "AuthorizationViewController.h"
#import "AuthorizationManager.h"
#import "RegistrationView.h"
#import "AuthorizationView.h"
#import "ServerError.h"
#import "UserViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface AuthorizationViewController (){
    AuthorizationView *authView;
    RegistrationView *regView;
}

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationPanel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorUserProfileDownload) name:@"errorUserProfileDownloadMessage" object:nil];
    [self setSegmentValue];
    [self setViews];
    [self setCurrentView:self.type];
}

-(void) setNavigationPanel{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
}

- (void) showLeftMenu{
    [kMainViewController setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"]];
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}
- (void) setSegmentValue{
    [self.segmentControl setTitle:NSLocalizedString(@"segment_auth", nil) forSegmentAtIndex:0];
    [self.segmentControl setTitle:NSLocalizedString(@"segment_reg", nil) forSegmentAtIndex:1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setViews{
    authView = [[[NSBundle mainBundle] loadNibNamed:@"AuthorizationView" owner:self options:nil] firstObject];
    regView = [[[NSBundle mainBundle] loadNibNamed:@"RegistrationView" owner:self options:nil] firstObject];
    authView.delegate = self;
    regView.delegate = self;
    [[AuthorizationManager sharedInstance] setDelegate:self];
    [self.innerView addSubview:authView];
    [self.innerView addSubview:regView];
}
- (void) setCurrentView: (NSString *) key{
    if([key isEqualToString:@"auth"]){
        regView.hidden = YES;
        authView.hidden = NO;
        [self.segmentControl setSelectedSegmentIndex:0];
    }
    if([key isEqualToString:@"reg"]){
        regView.hidden = NO;
        authView.hidden = YES;
        [self.segmentControl setSelectedSegmentIndex:1];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchViews:(id)sender {
    NSInteger selectedSegment = self.segmentControl.selectedSegmentIndex;
    
    if(selectedSegment == 0){
        [self setCurrentView:@"auth"];
    } else if(selectedSegment == 1){
        [self setCurrentView:@"reg"];
    }
}
- (void) successAuthentication:(id)user{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UserViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    viewController.user = [[AuthorizationManager sharedInstance] currentUser];
    [kNavigationController pushViewController:viewController animated:YES];
}
- (void) failedAuthentication:(id)error{
    ServerError *serverError = [[ServerError alloc] initWithData:error];
    serverError.delegate = self;
    [serverError handle];
}
- (void) failedRegistration:(id)error{
    ServerError *serverError = [[ServerError alloc] initWithData:error];
    serverError.delegate = self;
    [serverError handle];
}
- (void) handleServerErrorWithError:(id)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [error showErrorMessage:[error messageText]];
}
- (void) signInWithParams:(NSDictionary *)params{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AuthorizationManager sharedInstance] signInUserWithEmail:params[@"email"] andPassword:params[@"password"]];
}
- (void) signUpWithParams:(NSDictionary *)params{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AuthorizationManager sharedInstance] signUpWithParams:params];
}
-(void) handleServerFormErrorWithError:(id)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if([[error status] isEqual:@401]){
        [error showErrorMessage:NSLocalizedString(@"user_empty_error", nil)];
    }
    if([[error status] isEqual:@422]){
        NSString *fullMessage = @"";
        NSDictionary *wrapErr = [error message];
        if(wrapErr[@"email"]){
            NSString *message = [NSString stringWithFormat:@"email %@", wrapErr[@"email"][0]];
            fullMessage = [NSString stringWithFormat:@"%@", message];
        }
        if(wrapErr[@"password"]){
            NSString *message = [NSString stringWithFormat:@"password %@", wrapErr[@"password"][0]];
            fullMessage = [NSString stringWithFormat:@"%@ \n %@", fullMessage, message];
        }
        [error showErrorMessage:fullMessage];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"userProfile"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        UserViewController *controller = (UserViewController *)navController.topViewController;
        controller.user = [[AuthorizationManager sharedInstance] currentUser];
    }
}

- (void) keyboardWasShowOnField: (id) field withNotification: (id) notification{
    CGRect kbRawRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect scrollViewFrame = [self.scrollView.window convertRect:self.scrollView.frame fromView:self.scrollView.superview];
    
    // Calculate the area that is covered by the keyboard
    CGRect coveredFrame = CGRectIntersection(scrollViewFrame, kbRawRect);
    // Convert again to window coordinates to take rotations into account
    coveredFrame = [self.scrollView.window convertRect:self.scrollView.frame fromView:self.scrollView.superview];
    int offset;
    if([self.type isEqualToString:@"auth"]){
        offset = 100;
    } else if([self.type isEqualToString:@"reg"]){
        offset = 50;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, coveredFrame.size.height - offset, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect activeFieldRect = [field convertRect:[field bounds] toView:self.scrollView];
    [self.scrollView scrollRectToVisible:activeFieldRect animated:YES];
}
@end
