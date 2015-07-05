//
//  AuthorizationViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "AuthorizationViewController.h"
#import "RegistrationView.h"
#import "AuthorizationView.h"

@interface AuthorizationViewController (){
    AuthorizationView *authView;
    RegistrationView *regView;
}

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSegmentValue];
    [self setViews];
    [self setCurrentView:self.type];
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
@end
