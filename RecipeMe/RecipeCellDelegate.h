@protocol RecipeCellDelegate <NSObject>

@optional

- (void) clickOnCellWithImage: (UIImage *) image;
- (void) successUpvoteCallbackWithRecipe: (id) recipe cell: (id) cell andData: (id) data;
- (void) failureUpvoteCallbackWithRecipe: (id) error;
@end
