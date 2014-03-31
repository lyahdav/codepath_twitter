//
//  TwitterAPIClient.h
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterAPIClient : BDBOAuth1RequestOperationManager

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey APISecret:(NSString *)apiSecret callbackURL:(NSString *)callbackURL;

- (void)homeTimelineWithSuccess:(void (^)(NSArray *tweets))success
                                            failure:(void (^)(NSError *error))failure;
- (void)tweet:(NSString *)tweet WithSuccess:(void (^)())success
      failure:(void (^)(NSError *error))failure;
- (void)loginWithSuccess:(void (^)())success;
- (void)applicationDidOpenOAuthURL:(NSURL *)url;
- (void)currentUserWithSuccess:(void (^)(User *currentUser))success
                       failure:(void (^)(NSError *error))failure;

@end
