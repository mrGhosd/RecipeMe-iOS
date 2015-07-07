@protocol CommentDelegate <NSObject>

@optional
- (void) createComment: (NSMutableDictionary *) comment;
- (void) successCommentCreationCallback: (id) comment;
- (void) failureCommentCreationCallback: (id) error;

@end