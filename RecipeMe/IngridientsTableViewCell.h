//
//  IngridientsTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 25.06.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingridient.h"

@interface IngridientsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ingridientName;
@property (strong, nonatomic) IBOutlet UILabel *ingridientSize;
- (void) setIngridientData: (Ingridient *) ingridient;
@end
