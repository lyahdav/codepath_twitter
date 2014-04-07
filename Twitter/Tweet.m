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
        self.tweetID = [dictionary[@"id"] longValue];
        self.text = dictionary[@"text"];
        self.userProfileImageURL = dictionary[@"user"][@"profile_image_url"];
        self.userName = dictionary[@"user"][@"name"];
        self.userScreenName = dictionary[@"user"][@"screen_name"];
        self.createdAt = [self dateFromTwitterString:dictionary[@"created_at"]];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        _isFavorite = [dictionary[@"favorited"] boolValue];
        _isRetweeted = [dictionary[@"retweeted"] boolValue];
    }
    
    return self;
}

- (NSDate *)dateFromTwitterString:(NSString *)twitterDateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    // example twitterDateStrings:
    // Tue Aug 28 21:16:23 +0000 2012
    // Sun Apr 06 21:45:51 +0000 2014
    // patterns: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
    [df setDateFormat:@"eee MMM dd HH:mm:ss Z yyyy"];
    return [df dateFromString:twitterDateString];
}

- (void)setIsFavorite:(BOOL)isFavorite {
    if (_isFavorite == isFavorite) {
        return;
    }
    
    _isFavorite = isFavorite;
    self.favoriteCount += isFavorite ? 1 : -1;
}

- (void)setIsRetweeted:(BOOL)isRetweeted {
    if (_isRetweeted == isRetweeted) {
        return;
    }
    
    _isRetweeted = isRetweeted;
    self.retweetCount += isRetweeted ? 1 : -1;
}

@end
