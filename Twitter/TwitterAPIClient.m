//
//  TwitterAPIClient.m
//  Twitter
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import "TwitterAPIClient.h"
#import "NSURL+dictionaryFromQueryString.h"

static TwitterAPIClient *sharedInstance = nil;

NSString *const kBaseURL = @"https://api.twitter.com";

typedef void (^loginSuccessBlockType) ();

@interface TwitterAPIClient ()

@property (nonatomic, strong) NSString *callbackURL;
@property (nonatomic, strong) loginSuccessBlockType loginSuccessBlock;

@end

@implementation TwitterAPIClient

+ (instancetype)sharedInstance {
    NSAssert(sharedInstance != nil, @"attempting to call sharedInstance before sharedInstanceWithAPIKey:APISecret:");
    return sharedInstance;
}

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey APISecret:(NSString *)apiSecret callbackURL:(NSString *)callbackURL {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL] consumerKey:apiKey consumerSecret:apiSecret];
        sharedInstance.callbackURL = callbackURL;
    });
    return sharedInstance;
}


- (void)homeTimelineWithSuccess:(void (^)(NSArray *tweets))success {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([Tweet tweetsFromJSONArray:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting home timeline: %@", [error localizedDescription]);
    }];
}

- (void)mentionsTimelineWithSuccess:(void (^)(NSArray *tweets))success {
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([Tweet tweetsFromJSONArray:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting mentions timeline: %@", [error localizedDescription]);
    }];
}

- (void)tweet:(NSString *)tweetText withSuccess:(void (^)())success
      failure:(void (^)(NSError *error))failure {
    [self POST:@"1.1/statuses/update.json" parameters:@{@"status" : tweetText} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)tweet:(NSString *)tweetText inReplyTo:(Tweet *)inReplyToTweet withSuccess:(void (^)())success
      failure:(void (^)(NSError *error))failure {
    [self POST:@"1.1/statuses/update.json" parameters:@{@"status" : tweetText, @"in_reply_to_status_id" : @(inReplyToTweet.tweetID)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)reTweet:(Tweet *)tweet withSuccess:(void (^)())success
      failure:(void (^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%ld.json", tweet.tweetID];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)favorite:(Tweet *)tweet withSuccess:(void (^)())success
         failure:(void (^)(NSError *error))failure {
    [self POST:@"1.1/favorites/create.json" parameters:@{@"id" : @(tweet.tweetID)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)unFavorite:(Tweet *)tweet withSuccess:(void (^)())success
           failure:(void (^)(NSError *error))failure {
    [self POST:@"1.1/favorites/destroy.json" parameters:@{@"id" : @(tweet.tweetID)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void)loginWithSuccess:(loginSuccessBlockType)loginSuccessBlock {
    if ([self isAuthorized]) {
        loginSuccessBlock();
        return;
    }

    self.loginSuccessBlock = loginSuccessBlock;
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:self.callbackURL] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSString *authURL = [kBaseURL stringByAppendingFormat:@"/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Error fetching request token: %@", [error localizedDescription]);
    }];
}

- (void)applicationDidOpenOAuthURL:(NSURL *)url {
    NSDictionary *parameters = [url dictionaryFromQueryString];
    if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
        [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
            [self.requestSerializer saveAccessToken:accessToken];
            self.loginSuccessBlock();
        } failure:^(NSError *error) {
            NSLog(@"Error fetching access token: %@", [error localizedDescription]);
        }];
    }
}

- (void)currentUserWithSuccess:(void (^)(User *currentUser))success
      failure:(void (^)(NSError *error))failure {
    [self GET:@"1.1/account/verify_credentials.json" parameters:@{@"skip_status" : @"true"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *currentUser = [[User alloc] initWithDictionary:responseObject];
        [User setCurrentUser:currentUser];
        success(currentUser);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)userByScreenName:(NSString *)screenName withSuccess:(void (^)(User *user))success {
    [self GET:@"1.1/users/show.json" parameters:@{@"screen_name" : screenName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *user = [[User alloc] initWithDictionary:responseObject];
        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching user: %@", [error localizedDescription]);
    }];
}

@end
