@protocol CommentDelegate <NSObject>

@optional
- (void) createComment: (NSMutableDictionary *) comment;

@end