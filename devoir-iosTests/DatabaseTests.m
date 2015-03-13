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

/*- (void)testUserAccess
{
    DBAccess* dbAccess = [[DBAccess alloc] initWithDatabase:@"devoir-ios-test.sqlite"];
    
    //test add user
    [dbAccess addUserWithID: 16
                       Name: @"Brent Roberts"
                        Email: @"brentroberts@email.com"
                 OAuthToken: @"AXCD-5674-YSGDA"];
    //test get user
    User* user = [dbAccess getUser];
    XCTAssertEqual(user.ID, 16);
    XCTAssertEqualObjects(user.name, @"Brent Roberts");
    XCTAssertEqualObjects(user.email, @"brentroberts@email.com");
    XCTAssertEqualObjects(user.oAuthToken, @"AXCD-5674-YSGDA");
    
    [dbAccess removeUser];
    user = [dbAccess getUser];
    XCTAssertEqualObjects(user, nil);
}*/

/*- (void)testCourseAccess
{
    DBAccess* dbAccess = [[DBAccess alloc] initWithDatabase:@"devoir-ios-test.sqlite"];
    
    //Test add course
    [dbAccess addCourseWithID:56
                         Name:@"David Foster Wallace"
                          Color:@"BLUE"
                         UserID:4
                    LastUpdated:[NSDate date]
                        Visible:YES
                       ICalFeed:@"iCALFEEEED"
                          ICalID:@"IDIDID"];
    
    [dbAccess addCourseWithID:24
                         Name:@"G"
                          Color:@"GREEN"
                         UserID:3
                    LastUpdated:[NSDate date]
                        Visible:NO
                       ICalFeed:@"iCAL"
                         ICalID:@"FOUR"];
    
    [dbAccess addCourseWithID:12
                         Name:@"A"
                          Color:@"APPLE"
                         UserID:1
                    LastUpdated:[NSDate date]
                        Visible:YES
                       ICalFeed:@"iCALAPPPP"
                         ICalID:@"AND"];
    
    
    
    //test get course by id
    Course* course = [dbAccess getCourseByID:56];
    XCTAssertEqual(course.ID, 56);
    XCTAssertEqualObjects(course.name, @"David Foster Wallace");
    XCTAssertEqualObjects(course.color, @"BLUE");
    XCTAssertEqual(course.userID, 4);
    XCTAssertEqual(course.visible, YES);
    XCTAssertEqualObjects(course.iCalFeed, @"iCALFEEEED");
    XCTAssertEqualObjects(course.iCalID, @"IDIDID");
    
    course = [dbAccess getCourseByID:24];
    XCTAssertEqual(course.ID, 24);
    XCTAssertEqualObjects(course.name, @"G");
    XCTAssertEqualObjects(course.color, @"GREEN");
    XCTAssertEqual(course.userID, 3);
    XCTAssertEqual(course.visible, NO);
    XCTAssertEqualObjects(course.iCalFeed, @"iCAL");
    XCTAssertEqualObjects(course.iCalID, @"FOUR");
    
    course = [dbAccess getCourseByID:12];
    XCTAssertEqual(course.ID, 12);
    XCTAssertEqualObjects(course.name, @"A");
    XCTAssertEqualObjects(course.color, @"APPLE");
    XCTAssertEqual(course.userID, 1);
    XCTAssertEqual(course.visible, YES);
    XCTAssertEqualObjects(course.iCalFeed, @"iCALAPPPP");
    XCTAssertEqualObjects(course.iCalID, @"AND");
    
    
    
    //test get all courses ordered by name
    NSArray* courses = [dbAccess getAllCoursesOrderedByName];
    
    course = [courses objectAtIndex:0];
    XCTAssertEqual(course.ID, 12);
    XCTAssertEqualObjects(course.name, @"A");
    XCTAssertEqualObjects(course.color, @"APPLE");
    XCTAssertEqual(course.userID, 1);
    XCTAssertEqual(course.visible, YES);
    XCTAssertEqualObjects(course.iCalFeed, @"iCALAPPPP");
    XCTAssertEqualObjects(course.iCalID, @"AND");
    
    course = [courses objectAtIndex:2];
    XCTAssertEqual(course.ID, 24);
    XCTAssertEqualObjects(course.name, @"G");
    XCTAssertEqualObjects(course.color, @"GREEN");
    XCTAssertEqual(course.userID, 3);
    XCTAssertEqual(course.visible, NO);
    XCTAssertEqualObjects(course.iCalFeed, @"iCAL");
    XCTAssertEqualObjects(course.iCalID, @"FOUR");
    
    course = [courses objectAtIndex:1];
    XCTAssertEqual(course.ID, 56);
    XCTAssertEqualObjects(course.name, @"David Foster Wallace");
    XCTAssertEqualObjects(course.color, @"BLUE");
    XCTAssertEqual(course.userID, 4);
    XCTAssertEqual(course.visible, YES);
    XCTAssertEqualObjects(course.iCalFeed, @"iCALFEEEED");
    XCTAssertEqualObjects(course.iCalID, @"IDIDID");
    
    
    
    //test remove course by id
    [dbAccess removeCourseByID: course.ID];
    
    courses = [dbAccess getAllCoursesOrderedByName];
    
    course = [courses objectAtIndex:0];
    XCTAssertEqual(course.ID, 12);
    XCTAssertEqualObjects(course.name, @"A");
    XCTAssertEqualObjects(course.color, @"APPLE");
    XCTAssertEqual(course.userID, 1);
    XCTAssertEqual(course.visible, YES);
    XCTAssertEqualObjects(course.iCalFeed, @"iCALAPPPP");
    XCTAssertEqualObjects(course.iCalID, @"AND");
    
    course = [courses objectAtIndex:1];
    XCTAssertEqual(course.ID, 24);
    XCTAssertEqualObjects(course.name, @"G");
    XCTAssertEqualObjects(course.color, @"GREEN");
    XCTAssertEqual(course.userID, 3);
    XCTAssertEqual(course.visible, NO);
    XCTAssertEqualObjects(course.iCalFeed, @"iCAL");
    XCTAssertEqualObjects(course.iCalID, @"FOUR");
    
    
    
    //test remove all courses
    [dbAccess removeAllCourses];
    
    courses = [dbAccess getAllCoursesOrderedByName];
    
    XCTAssertEqual(0, courses.count);
}*/


@end