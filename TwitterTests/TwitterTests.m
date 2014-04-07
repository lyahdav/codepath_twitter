//
//  TwitterTests.m
//  TwitterTests
//
//  Created by Liron Yahdav on 3/30/14.
//  Copyright (c) 2014 Liron Yahdav. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Tweet.h"

@interface Tweet (PrivateMethodsExposedForTest)

- (NSDate *)dateFromTwitterString:(NSString *)twitterDateString;

@end

@interface TwitterTests : XCTestCase

@end

@implementation TwitterTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDateFromTwitterString
{
    Tweet *tweet = [[Tweet alloc] init];
    XCTAssertNotNil([tweet dateFromTwitterString:@"Tue Aug 28 21:16:23 +0000 2012"]);
    XCTAssertNotNil([tweet dateFromTwitterString:@"Sun Apr 06 21:45:51 +0000 2014"]);
}

@end
