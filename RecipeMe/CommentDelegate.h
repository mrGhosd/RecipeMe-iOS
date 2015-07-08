@protocol CommentDelegate <NSObject>

@optional
- (void) createComment: (NSMutableDictionary *) comment;
- (void) successCommentCreationCallback: (id) comment;
- (void) failureCommentCreationCallback: (id) error;
- (void) succesDeleteCallback: (id) comment;
- (void) failureDeleteCallback: (id) error;
- (void) successUpdateCallback: (id) comment;
- (void) failureUpdateCallback: (id) error;
@end