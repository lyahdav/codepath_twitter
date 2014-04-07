//
//  EmbeddedViewController.h
//  Twitter
//
//  Created by Liron Yahdav on 4/6/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarDelegate.h"

@interface EmbeddedViewController : UIViewController

@property (nonatomic, assign) id<SidebarDelegate> sidebarDelegate;
@property (nonatomic, assign) BOOL skipEmbed;

@end
