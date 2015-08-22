@protocol FeedDelegate <NSObject>

@optional

- (void) moveToFeedObject: (id) object;
- (void) clickOnCellImage: (id) object;
- (void) moveToUserProfile: (id) user;
@end