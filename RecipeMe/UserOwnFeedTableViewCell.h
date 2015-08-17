//
//  UserOwnFeedTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 16.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "FeedDelegate.h"

@interface UserOwnFeedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *feedImage;
@property (strong, nonatomic) IBOutlet UILabel *feedCreatedAt;
@property (strong, nonatomic) IBOutlet UILabel *eventDescription;
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) id <FeedDelegate> delegate;
@property (strong, nonatomic) Feed *feed;
- (void) initWithFeed: (Feed *) feed;
@end
