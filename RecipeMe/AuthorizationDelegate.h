
@protocol AuthorizationDelegate <NSObject>

@optional
- (void) successAuthentication: (id) user;
- (void) failedAuthentication: (id) error;
@end