//
//  LoginViewController.m
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterAPIClient.h"
#import "TweetsViewController.h"
#import "User.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation LoginViewController

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
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BirdCell"];

    TwitterAPIClient *client = [TwitterAPIClient sharedInstanceWithAPIKey:@"TNRrE4CYkbhgxz9IfkVA" APISecret:@"u6aeBBNQddDQwzjwfqgZudwk6eXXdITgzODBsqn124" callbackURL:@"lytwitter://oauth"];
    if ([client isAuthorized]) {
        [self getCurrentUserAndShowTweetsVC];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButtonTap:(id)sender {
    [[TwitterAPIClient sharedInstance] loginWithSuccess:^{
        [self getCurrentUserAndShowTweetsVC];
    }];
}

- (void)getCurrentUserAndShowTweetsVC {
    [[TwitterAPIClient sharedInstance] currentUserWithSuccess:^(User *currentUser) {
        [self showTweetsVC];
    } failure:^(NSError *error) {
        NSLog(@"Error getting current user: %@", [error localizedDescription]);
    }];
}

- (void)showTweetsVC {
    TweetsViewController *vc = [[TweetsViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSArray *images = nil;
    if (images == nil) {
        images = @[@"bird_black_48_0", @"bird_blue_48", @"bird_gray_48"];
    }
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"BirdCell" forIndexPath:indexPath];
    if (cell.contentView.subviews.count == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[indexPath.row % 3]]];
        [cell.contentView addSubview:imageView];
    }
    return cell;
}

@end
