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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButtonTap:(id)sender {
    TwitterAPIClient *client = [TwitterAPIClient sharedInstanceWithAPIKey:@"TNRrE4CYkbhgxz9IfkVA" APISecret:@"u6aeBBNQddDQwzjwfqgZudwk6eXXdITgzODBsqn124" callbackURL:@"lytwitter://oauth"];
    [client loginWithSuccess:^{
        [client currentUserWithSuccess:^(User *currentUser) {
            [self showTweetsVC];
        } failure:^(NSError *error) {
            NSLog(@"Error getting current user: %@", [error localizedDescription]);
        }];
        
    }];
}

- (void)showTweetsVC {
    TweetsViewController *vc = [[TweetsViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

@end
