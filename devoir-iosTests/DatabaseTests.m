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

- (void)testCourseAccess
{
    DBAccess* dbAccess = [[DBAccess alloc] init];
    
    //Test add course
    [dbAccess addCourseWithName:@"David Foster Wallace"
                          Color:@"BLUE"
                         UserID:4
                    LastUpdated:[NSDate date]
                       ICalFeed:@"iCALFEEEED"
                          ICalID:@"IDIDID"];
    
    [dbAccess addCourseWithName:@"G"
                          Color:@"GREEN"
                         UserID:3
                    LastUpdated:[NSDate date]
                       ICalFeed:@"iCAL"
                         ICalID:@"FOUR"];
    
    [dbAccess addCourseWithName:@"A"
                          Color:@"APPLE"
                         UserID:1
                    LastUpdated:[NSDate date]
                       ICalFeed:@"iCALAPPPP"
                         ICalID:@"AND"];
    
    
    
    //test get course by id
    Course* course = [dbAccess getCourseByID:1];
    XCTAssertEqualObjects([course name], @"David Foster Wallace");
    XCTAssertEqualObjects([course color], @"BLUE");
    XCTAssertEqual([course userID], 4);
    XCTAssertEqualObjects([course iCalFeed], @"iCALFEEEED");
    XCTAssertEqualObjects([course iCalID], @"IDIDID");
    
    course = [dbAccess getCourseByID:2];
    XCTAssertEqualObjects([course name], @"G");
    XCTAssertEqualObjects([course color], @"GREEN");
    XCTAssertEqual([course userID], 3);
    XCTAssertEqualObjects([course iCalFeed], @"iCAL");
    XCTAssertEqualObjects([course iCalID], @"FOUR");
    
    course = [dbAccess getCourseByID:3];
    XCTAssertEqualObjects([course name], @"A");
    XCTAssertEqualObjects([course color], @"APPLE");
    XCTAssertEqual([course userID], 1);
    XCTAssertEqualObjects([course iCalFeed], @"iCALAPPPP");
    XCTAssertEqualObjects([course iCalID], @"AND");
    
    
    
    //test get all courses ordered by name
    NSArray* courses = [dbAccess getAllCoursesOrderedByName];
    
    course = [courses objectAtIndex:0];
    XCTAssertEqualObjects([course name], @"A");
    XCTAssertEqualObjects([course color], @"APPLE");
    XCTAssertEqual([course userID], 1);
    XCTAssertEqualObjects([course iCalFeed], @"iCALAPPPP");
    XCTAssertEqualObjects([course iCalID], @"AND");
    
    course = [courses objectAtIndex:2];
    XCTAssertEqualObjects([course name], @"G");
    XCTAssertEqualObjects([course color], @"GREEN");
    XCTAssertEqual([course userID], 3);
    XCTAssertEqualObjects([course iCalFeed], @"iCAL");
    XCTAssertEqualObjects([course iCalID], @"FOUR");
    
    course = [courses objectAtIndex:1];
    XCTAssertEqualObjects([course name], @"David Foster Wallace");
    XCTAssertEqualObjects([course color], @"BLUE");
    XCTAssertEqual([course userID], 4);
    XCTAssertEqualObjects([course iCalFeed], @"iCALFEEEED");
    XCTAssertEqualObjects([course iCalID], @"IDIDID");
    
    
    
    //test remove course by id
    [dbAccess removeCourseByID: course.ID];
    
    courses = [dbAccess getAllCoursesOrderedByName];
    
    course = [courses objectAtIndex:0];
    XCTAssertEqualObjects([course name], @"A");
    XCTAssertEqualObjects([course color], @"APPLE");
    XCTAssertEqual([course userID], 1);
    XCTAssertEqualObjects([course iCalFeed], @"iCALAPPPP");
    XCTAssertEqualObjects([course iCalID], @"AND");
    
    course = [courses objectAtIndex:1];
    XCTAssertEqualObjects([course name], @"G");
    XCTAssertEqualObjects([course color], @"GREEN");
    XCTAssertEqual([course userID], 3);
    XCTAssertEqualObjects([course iCalFeed], @"iCAL");
    XCTAssertEqualObjects([course iCalID], @"FOUR");
    
    
    
    //test remove all courses
    [dbAccess removeAllCourses];
    
    courses = [dbAccess getAllCoursesOrderedByName];
    
    XCTAssertEqual(0, [courses count]);
}


@end