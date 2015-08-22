//
//  FeedTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 22.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "FeedDelegate.h"

@interface FeedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *feedCreatedAt;
@property (strong, nonatomic) Feed *feed;
@property (strong, nonatomic) id <FeedDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *feedImage;
@property (strong, nonatomic) IBOutlet UILabel *feedTitle;
@property (strong, nonatomic) IBOutlet UILabel *feedDescription;
- (void) setFeedData: (Feed *) feed;
@end
