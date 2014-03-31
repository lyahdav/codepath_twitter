//
//  Tweet.m
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSArray *)tweetsFromJSONArray:(NSArray *)jsonArray {
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    
    for(NSDictionary *tweetDictionary in jsonArray) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        [tweets addObject:tweet];
    }
    
    return tweets;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.text = dictionary[@"text"];
        self.userProfileImageURL = dictionary[@"user"][@"profile_image_url"];
        self.userName = dictionary[@"user"][@"name"];
        self.createdAt = dictionary[@"created_at"]; // TODO convert string to date?
    }
    
    return self;
}

@end
