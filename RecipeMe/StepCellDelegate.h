#import "Step.h"
@protocol StepCellDelegate <NSObject>

@optional

- (void) clickOnCellImage: (Step *) step;

@end
