//
//  EmbeddedViewController.m
//  Twitter
//
//  Created by Liron Yahdav on 4/6/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "EmbeddedViewController.h"

@interface EmbeddedViewController ()

@end

@implementation EmbeddedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.skipEmbed) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"≡" style:UIBarButtonItemStylePlain target:self.sidebarDelegate action:@selector(onSidebarIconClick)];
    }
}

@end
