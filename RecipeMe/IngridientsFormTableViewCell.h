//
//  IngridientsFormTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 24.07.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingridient.h"

@interface IngridientsFormTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *ingridientName;
@property (strong, nonatomic) IBOutlet UITextField *ingridientSize;
@property (strong, nonatomic) Ingridient *ingridient;
@end
