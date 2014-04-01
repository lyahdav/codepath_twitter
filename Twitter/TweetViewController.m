//
//  TweetViewController.m
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterAPIClient.h"
#import "ComposeViewController.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateCountLabels {
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    self.favoriteCountLabel.text = [@(self.tweet.favoriteCount) stringValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Tweet";
    
    self.nameLabel.text = self.tweet.userName;
    self.screenNameLabel.text = [@"@" stringByAppendingString:self.tweet.userScreenName];
    self.tweetLabel.text = self.tweet.text;
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:self.tweet.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    [self updateCountLabels];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet.userProfileImageURL]];
    self.favoriteButton.selected = self.tweet.isFavorite;
    self.retweetButton.selected = self.tweet.isRetweeted;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFavoriteTap:(UIButton *)sender {
    if (!sender.selected) {
        [[TwitterAPIClient sharedInstance] favorite:self.tweet withSuccess:nil failure:^(NSError *error) {
            NSLog(@"Failure favoriting Tweet: %@", [error localizedDescription]);
        }];
    } else {
        [[TwitterAPIClient sharedInstance] unFavorite:self.tweet withSuccess:nil failure:^(NSError *error) {
            NSLog(@"Failure unfavoriting Tweet: %@", [error localizedDescription]);
        }];
    }
    sender.selected = !sender.selected;
    self.tweet.isFavorite = sender.selected;
    [self updateCountLabels];
}

- (IBAction)onRetweetTap:(UIButton *)sender {
    if (!sender.selected) {
        [[TwitterAPIClient sharedInstance] reTweet:self.tweet withSuccess:nil failure:^(NSError *error) {
            NSLog(@"Failure retweeting: %@", [error localizedDescription]);
        }];
        sender.selected = YES;
        self.tweet.isRetweeted = sender.selected;
        [self updateCountLabels];
    } else {
        // disallow un-retweeting for now
    }
}

- (IBAction)onReplyTap:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.inReplyToTweet = self.tweet;
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

@end
