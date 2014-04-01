//
//  ComposeViewController.m
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterAPIClient.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleBordered target:self action:@selector(onTweetClick)];
    
    [self.tweetTextView becomeFirstResponder];

    self.nameLabel.text = [User currentUser].name;
    self.screenNameLabel.text = [@"@" stringByAppendingString:[User currentUser].screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:[User currentUser].profileImageURL]];
    
    if (self.inReplyToTweet != nil) {
        self.tweetTextView.text = [NSString stringWithFormat:@"@%@ ", self.inReplyToTweet.userScreenName];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)onCancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissWithCallback {
    if (self.tweetWasComposed) {
        self.tweetWasComposed();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetClick {
    if (self.inReplyToTweet != nil) {
        [[TwitterAPIClient sharedInstance] tweet:self.tweetTextView.text inReplyTo:self.inReplyToTweet withSuccess:^{
            [self dismissWithCallback];
        } failure:^(NSError *error) {
            NSLog(@"Error replying to tweet: %@", [error localizedDescription]);
        }];
    } else {
        [[TwitterAPIClient sharedInstance] tweet:self.tweetTextView.text withSuccess:^{
            [self dismissWithCallback];
        } failure:^(NSError *error) {
            NSLog(@"Error posting tweet: %@", [error localizedDescription]);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
