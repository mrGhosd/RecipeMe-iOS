//
//  IngridientsFormTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 24.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingridient.h"
#import "FormDelegate.h"

@interface IngridientsFormTableViewCell : UITableViewCell <UITextFieldDelegate, FormDelegate>
@property (strong, nonatomic) IBOutlet UITextField *ingridientName;
@property (strong, nonatomic) IBOutlet UITextField *ingridientSize;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) id<FormDelegate> delegate;
@property (strong, nonatomic) Ingridient *ingridient;
- (void) setIngridientData: (Ingridient *) ingridient;
@end
