//
//  FeedTableViewCell.h
//  RecipeMe
//
//  Created by vsokoltsov on 22.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface FeedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) Feed *feed;
- (void) setFeedData: (Feed *) feed;
@end
