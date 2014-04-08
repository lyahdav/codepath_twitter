//
//  TweetsViewController.h
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbeddedViewController.h"

typedef NS_ENUM(NSUInteger, TimelineType) {
    kHomeTimeline,
    kMentionsTimeline,
    kUserTimeline
};

@interface TweetsViewController : EmbeddedViewController <UITableViewDataSource>

@property (nonatomic, assign) TimelineType timelineType;
@property (nonatomic, strong) NSString *screenNameForUserTimeline;

@end
