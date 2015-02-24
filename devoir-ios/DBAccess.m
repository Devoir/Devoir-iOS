//
//  DBAccess.m
//  devoir-ios
//
//  Created by Brent on 2/24/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "DBAccess.h"

@implementation DBAccess

#pragma mark - User Methods
- (User*) getUser
{
    UserDBAccess* userAccess = [[UserDBAccess alloc] init];
    return [userAccess getUser];
}

- (User*) addUserWithName:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken UserID:(int)userID
{
    UserDBAccess* userAccess = [[UserDBAccess alloc] init];
    return [userAccess addUserWithName:name Email:email OAuthToken:oAuthToken UserID:userID];
}

- (void) removeUser
{
    UserDBAccess* userAccess = [[UserDBAccess alloc] init];
    return [userAccess removeUser];
}

#pragma mark - Course Methods
- (Course*) getCourseByID:(int)ID
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] init];
    return [courseAccess getCourseByID:ID];
}

- (NSArray*) getAllCoursesOrderedByName
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] init];
    return [courseAccess getAllCoursesOrderedByName];
}

- (Course*) addCourseWithName:(NSString*)name Color:(NSString*)color UserID:(int)userID
                  LastUpdated:(NSDate*)lastUpdated ICalFeed:(NSString*)iCalFeed ICalID:(NSString*)iCalID
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] init];
    return [courseAccess addCourseWithName:name
                                     Color:color
                                    UserID:userID
                               LastUpdated:lastUpdated
                                  ICalFeed:iCalFeed
                                    ICalID:iCalID];
}

- (void) removeCourseByID:(int)ID
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] init];
    return [courseAccess removeCourseByID:ID];
}

- (void) removeAllCourses
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] init];
    return [courseAccess removeAllCourses];
}

@end
