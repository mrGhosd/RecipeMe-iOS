//
//  AuthorizationView.m
//  RecipeMe
//
//  Created by vsokoltsov on 05.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "AuthorizationView.h"

@implementation AuthorizationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self customizeTextField:self.emailField withIcon:@"authMailIcon.png" andPlaceholder:NSLocalizedString(@"email", nil)];
    [self customizeTextField:self.passwordField withIcon:@"authPasswordField.png" andPlaceholder:NSLocalizedString(@"password", nil)];
    [self.loginButton setTitle:NSLocalizedString(@"sign_in_button", nil) forState:UIControlStateNormal];
        
    // Do any additional setup after loading the view.
}

- (void) customizeTextField: (UITextField *) textField withIcon: (NSString *) iconName andPlaceholder: (NSString *) placeholder{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 19)];
    imgView.image = [UIImage imageNamed:iconName];
    textField.leftView = imgView;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    textField.attributedPlaceholder = str;
}
- (IBAction)signIn:(id)sender {
}
@end
