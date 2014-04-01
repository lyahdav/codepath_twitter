#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "MHPrettyDate.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *relativeTimeLabel;

@end

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.userNameLabel.text = tweet.userName;
    self.screenNameLabel.text = [@"@" stringByAppendingString:tweet.userScreenName];
    self.tweetTextLabel.text = tweet.text;
    self.relativeTimeLabel.text = [MHPrettyDate prettyDateFromDate:tweet.createdAt withFormat:MHPrettyDateShortRelativeTime];
    [self.userImage setImageWithURL:[NSURL URLWithString:tweet.userProfileImageURL]];
}

- (CGFloat)heightForTweet:(Tweet *)tweet {
    self.tweetTextLabel.text = tweet.text;

    CGSize constraint = CGSizeMake(self.tweetTextLabel.frame.size.width, CGFLOAT_MAX);
    CGFloat newTweetTextLabelHeight = [self.tweetTextLabel sizeThatFits:constraint].height;
    CGFloat originalTweetTextLabelHeight = self.tweetTextLabel.frame.size.height;
    CGFloat height = self.frame.size.height - originalTweetTextLabelHeight + newTweetTextLabelHeight;
    return height;
}

@end
