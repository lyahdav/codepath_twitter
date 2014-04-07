//
//  User.m
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;

+ (User *)currentUser {
    if (currentUser == nil) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        if (dict) {
            currentUser = [[User alloc] initWithDictionary:dict];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.screenName = dictionary[@"screen_name"];
        self.name = dictionary[@"name"];
        self.profileImageURL = dictionary[@"profile_image_url"];
        self.profileBGImageURL = dictionary[@"profile_background_image_url"];
        self.statusesCount = [dictionary[@"statuses_count"] integerValue];
        self.followersCount = [dictionary[@"followers_count"] integerValue];
        self.friendsCount = [dictionary[@"friends_count"] integerValue];
    }
    return self;
}

@end
