//
//  IngridientsFormTableViewCell.m
//  RecipeMe
//
//  Created by vsokoltsov on 24.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "IngridientsFormTableViewCell.h"

@implementation IngridientsFormTableViewCell

- (void)awakeFromNib {
    self.ingridientName.delegate = self;
    self.ingridientSize.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    [self customizeTextField:self.ingridientName withIcon:@"ingridientName" andPlaceholder:NSLocalizedString(@"ingridient_name", nil)];
    [self customizeTextField:self.ingridientSize withIcon:@"ingridientSize" andPlaceholder:NSLocalizedString(@"ingridient_size", nil)];
    [self.ingridientName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.ingridientSize addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // Initialization code
}
- (void) setIngridientData: (Ingridient *) ingridient{
    self.ingridient = ingridient;
    if(self.ingridient.id){
        self.ingridientName.enabled = NO;
        self.ingridientSize.enabled = NO;
    } else {
        self.ingridientName.enabled = YES;
        self.ingridientSize.enabled = YES;
    }
    self.ingridientName.text = self.ingridient.name;
    self.ingridientSize.text = self.ingridient.size;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) textFieldDidChange: (UITextField *) textField{
    if([textField isEqual:self.ingridientName]){
        self.ingridient.name = self.ingridientName.text;
    }
    if([textField isEqual:self.ingridientSize]){
        self.ingridient.size = self.ingridientSize.text;
    }
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
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    imgView.image = [UIImage imageNamed:iconName];
    textField.leftView = imgView;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    textField.attributedPlaceholder = str;
}

@end
