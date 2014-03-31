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

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userProfileImageURL;
@property (nonatomic, strong) NSDate *createdAt;

@end
