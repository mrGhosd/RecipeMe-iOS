#import "Step.h"

@protocol StepCellDelegate <NSObject>

@optional

- (void) clickOnCellImage: (Step *) step;
- (void) increaseStepsTableViewBy: (float) value;
- (void) selectImageForCell:(UITableViewCell *) cell;
@end
