//
//  ProfileViewController.m
//  Twitter
//
//  Created by Liron Yahdav on 4/6/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetsViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileBGImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UIView *tweetsContainerView;

@end

@implementation ProfileViewController

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
    
    self.title = [self.user.screenName isEqualToString:[User currentUser].screenName] ? @"Me" : @"Profile";
    
    self.userNameLabel.text = self.user.name;
    self.userScreenNameLabel.text = [@"@" stringByAppendingString:self.user.screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageURL]];
    [self.profileBGImage setImageWithURL:[NSURL URLWithString:self.user.profileBGImageURL]];
    self.tweetCountLabel.text = [@(self.user.statusesCount) stringValue];
    self.followingCountLabel.text = [@(self.user.friendsCount) stringValue];
    self.followersCountLabel.text = [@(self.user.followersCount) stringValue];

    TweetsViewController *tweetsVC = [[TweetsViewController alloc] init];
    tweetsVC.timelineType = kUserTimeline;
    tweetsVC.screenNameForUserTimeline = self.user.screenName;
    tweetsVC.view.frame = CGRectMake(0, 0, self.tweetsContainerView.frame.size.width, self.tweetsContainerView.frame.size.height);
    [self addChildViewController:tweetsVC];
    [self.tweetsContainerView addSubview:tweetsVC.view];
    [tweetsVC didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
