//
//  SidebarContainerViewController.m
//  Twitter
//
//  Created by Liron Yahdav on 4/6/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "SidebarContainerViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "TwitterAPIClient.h"
#import "EmbeddedViewController.h"
#include <math.h>
#import "SidebarProfileCell.h"

#define SIDEBAR_ITEMS @[@"Profile", @"Home", @"Mentions", @"Sign Out"]

const CGFloat kMinContainerWidth = 50.0;
const CGFloat kMaxSidebarWidth = 320.0 - kMinContainerWidth;

@interface SidebarContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *sidebarView;
@property (weak, nonatomic) IBOutlet UITableView *sidebarTableView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *contentViewTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHorizontalSpaceConstraint;
@property (nonatomic, strong) EmbeddedViewController *contentViewController;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) BOOL sidebarVisible;
@end

@implementation SidebarContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentViewController = [[TweetsViewController alloc] init];

    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPushingVCNotification:) name:@"pushingVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPoppingVCNotification:) name:@"poppingVC" object:nil];
    
    self.contentViewTapGestureRecognizer.enabled = NO;
    
    [self.sidebarTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"item"];
    UINib *sidebarProfileCell = [UINib nibWithNibName:@"SidebarProfileCell" bundle:nil];
    [self.sidebarTableView registerNib:sidebarProfileCell forCellReuseIdentifier:@"SidebarProfileCell"];
}

- (void)onPushingVCNotification:(NSNotification *)notification {
    self.panGestureRecognizer.enabled = NO;
}

- (void)onPoppingVCNotification:(NSNotification *)notification {
    self.panGestureRecognizer.enabled = YES;
}

- (void)hideSidebarAnimated {
    [UIView animateWithDuration:0.5 animations:^{
        self.contentViewHorizontalSpaceConstraint.constant = 0.0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.contentViewTapGestureRecognizer.enabled = NO;
        self.sidebarVisible = NO;
    }];
}

- (void)showSidebarAnimated {
    [UIView animateWithDuration:0.5 animations:^{
        self.contentViewHorizontalSpaceConstraint.constant = kMaxSidebarWidth;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.contentViewTapGestureRecognizer.enabled = YES;
        self.sidebarVisible = YES;
    }];
}

- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = point;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (self.sidebarVisible) {
            self.contentViewHorizontalSpaceConstraint.constant = kMaxSidebarWidth + point.x - self.panStartPoint.x;
        } else {
            self.contentViewHorizontalSpaceConstraint.constant = fmax(point.x - self.panStartPoint.x, 0.0);
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
        if (velocity.x > 0) {
            [self showSidebarAnimated];
        } else {
            [self hideSidebarAnimated];
        }
    }
}

- (IBAction)onContentViewTap:(id)sender {
    [self hideSidebarAnimated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setContentViewController:(EmbeddedViewController *)contentViewController {
    _contentViewController = contentViewController;

    contentViewController.sidebarDelegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    [self addChildViewController:nc];
    [self.contentView addSubview:nc.view];
    [nc didMoveToParentViewController:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SIDEBAR_ITEMS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SidebarProfileCell *cell = [self.sidebarTableView dequeueReusableCellWithIdentifier:@"SidebarProfileCell" forIndexPath:indexPath];
        cell.user = [User currentUser];
        return cell;
    } else {
        UITableViewCell *cell = [self.sidebarTableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
        cell.textLabel.text = SIDEBAR_ITEMS[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.sidebarTableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0: { // profile
            ProfileViewController *vc = [[ProfileViewController alloc] init];
            vc.user = [User currentUser];
            self.contentViewController = vc;
            break;
        }
        case 1: { // home
            self.contentViewController = [[TweetsViewController alloc] init];
            break;
        }
        case 2: { // mentions
            TweetsViewController *vc = [[TweetsViewController alloc] init];
            vc.isMentionsTimeline = YES;
            self.contentViewController = vc;
            break;
        }
        case 3: { // sign out
            [[TwitterAPIClient sharedInstance] deauthorize];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }
    [self hideSidebarAnimated];
}

#pragma mark - SidebarDelegate

- (void)onSidebarIconClick {
    [self showSidebarAnimated];
}

@end
