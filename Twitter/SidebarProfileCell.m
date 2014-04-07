//
//  SidebarProfileCell.m
//  Twitter
//
//  Created by Liron Yahdav on 4/6/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "SidebarProfileCell.h"
#import "UIImageView+AFNetworking.h"

@interface SidebarProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation SidebarProfileCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;

    self.userNameLabel.text = user.name;
    self.screenNameLabel.text = [@"@" stringByAppendingString:user.screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
}

@end
