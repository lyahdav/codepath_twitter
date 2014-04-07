//
//  User.h
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSString *profileBGImageURL;
@property (nonatomic, assign) NSInteger statusesCount;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger friendsCount;

@end
