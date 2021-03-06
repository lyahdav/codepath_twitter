//
//  TweetsViewController.m
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "TweetsViewController.h"
#import "TwitterAPIClient.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "ProfileViewController.h"

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TweetCell *prototypeCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRootViewController;

@end

@implementation TweetsViewController

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
    
    switch (self.timelineType) {
        case kHomeTimeline:
            self.title = @"Home";
            break;
        case kMentionsTimeline:
            self.title = @"Mentions";
        default:
            break;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(onNewTap)];
    
    UINib *tweetCell = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCell forCellReuseIdentifier:@"TweetCell"];

    [self loadTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowUserProfileNotification:) name:@"showUserProfile" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isRootViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"poppingVC" object:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isRootViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushingVC" object:self];
    }
}

- (void)loadTweets {
    void (^onSuccess)(NSArray *) = ^(NSArray *tweets) {
        self.tweets = [tweets mutableCopy];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    };
    
    switch (self.timelineType) {
        case kHomeTimeline:
            [[TwitterAPIClient sharedInstance] homeTimelineWithSuccess:onSuccess];
            break;
        case kMentionsTimeline:
            [[TwitterAPIClient sharedInstance] mentionsTimelineWithSuccess:onSuccess];
            break;
        case kUserTimeline:
            [[TwitterAPIClient sharedInstance] userTimelineByScreenName:self.screenNameForUserTimeline withSuccess:onSuccess];
            break;
            
        default:
            break;
    }
}

- (void)onNewTap {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.tweetWasComposed = ^{
        [self loadTweets];
    };
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)onShowUserProfileNotification:(NSNotification *)notification {
    if (self.timelineType == kUserTimeline) {
        return;
    }
    
    NSString *screenName = notification.userInfo[@"screenName"];
    [[TwitterAPIClient sharedInstance] userByScreenName:screenName withSuccess:^(User *user) {
        ProfileViewController *vc = [[ProfileViewController alloc] init];
        vc.skipEmbed = YES;
        vc.user = user;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isRootViewController {
    return (self.timelineType != kUserTimeline) || [self.screenNameForUserTimeline isEqualToString:[User currentUser].screenName];
}

#pragma mark - UITableViewDelegate

- (TweetCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _prototypeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.prototypeCell heightForTweet:self.tweets[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewController *vc = [[TweetViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

@end
