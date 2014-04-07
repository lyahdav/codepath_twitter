//
//  ProfileViewController.h
//  Twitter
//
//  Created by Liron Yahdav on 4/6/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "EmbeddedViewController.h"

@interface ProfileViewController : EmbeddedViewController

@property (nonatomic, strong) User *user;

@end
