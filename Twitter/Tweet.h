//
//  Tweet.h
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

+ (NSArray *)tweetsFromJSONArray:(NSArray *)jsonArray;

@property (nonatomic, assign) long tweetID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userScreenName;
@property (nonatomic, strong) NSString *userProfileImageURL;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) BOOL isRetweeted;

@end
