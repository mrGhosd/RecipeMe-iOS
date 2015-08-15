#import "User.h"
@protocol UserDelegate <NSObject>

@optional

- (void) clickOnUserImage: (User *) user;
- (void) clickUserInfoPanel: (NSString *) panelIdentifier;
@end
