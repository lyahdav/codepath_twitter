#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) Tweet *tweet;

- (CGFloat)heightForTweet:(Tweet *)tweet;

@end
