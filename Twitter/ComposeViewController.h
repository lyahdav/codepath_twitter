//
//  ComposeViewController.h
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) Tweet *inReplyToTweet;
@property (nonatomic, copy) void (^tweetWasComposed)();

@end
