//
//  devoir_iosTests.m
//  devoir-iosTests
//
//  Created by Candice Davis on 2/7/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DBAccess.h"
#import "Course.h"

@interface DatabaseTests : XCTestCase

@end

@implementation DatabaseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    DBAccess* dbAccess = [[DBAccess alloc] init];
    
    //TEST BAD DATABASE
    [dbAccess addCourseWithName:@"David Foster Wallace"
                           Color:@"BLUE"
                         UserID:4
                    LastUpdated:[NSDate date]
                       ICalFeed:@"iCALFEEEED"
                          ICalID:@"IDIDID"];
    
    //test get course by id
    Course* course = [dbAccess getCourseByID:1];
    XCTAssertEqualObjects([course name], @"David Foster Wallace");
    XCTAssertEqualObjects([course color], @"BLUE");
    XCTAssertEqualObjects([course iCalFeed], @"iCALFEEEED");
    XCTAssertEqualObjects([course iCalID], @"IDIDID");
    XCTAssertEqual([course userID], 4);
    
    [dbAccess removeAllCourses];
}


@end