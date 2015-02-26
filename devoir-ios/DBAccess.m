//
//  DBAccess.m
//  devoir-ios
//
//  Created by Brent on 2/24/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "DBAccess.h"

@interface DBAccess()

@property (nonatomic, retain) NSString* dbName;

@end

@implementation DBAccess

@synthesize dbName;

- (id) init
{
    if ((self = [super init]))
    {
        dbName = @"devoir-ios.sqlite";
    }
    return self;
}

- (id) initWithDatabase:(NSString*)db
{
    if ((self = [super init]))
    {
        dbName = db;
    }
    return self;
}

#pragma mark - User Methods
- (User*) getUser
{
    UserDBAccess* userAccess = [[UserDBAccess alloc] initWithDatabase:dbName];
    return [userAccess getUser];
}

- (User*) addUserWithID:(int)ID Name:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken
{
    UserDBAccess* userAccess = [[UserDBAccess alloc] initWithDatabase:dbName];
    return [userAccess addUserWithID:ID Name:name Email:email OAuthToken:oAuthToken];
}

- (void) removeUser
{
    UserDBAccess* userAccess = [[UserDBAccess alloc] initWithDatabase:dbName];
    return [userAccess removeUser];
}

#pragma mark - Course Methods
- (Course*) getCourseByID:(int)ID
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:dbName];
    return [courseAccess getCourseByID:ID];
}

- (NSArray*) getAllCoursesOrderedByName
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:dbName];
    return [courseAccess getAllCoursesOrderedByName];
}

- (Course*) addCourseWithID:(int)ID Name:(NSString*)name Color:(NSString*)color UserID:(int)userID
                  LastUpdated:(NSDate*)lastUpdated Visible:(BOOL)visible
                     ICalFeed:(NSString*)iCalFeed ICalID:(NSString*)iCalID
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:dbName];
    return [courseAccess addCourseWithID:ID
                                    Name:name
                                   Color:color
                                  UserID:userID
                             LastUpdated:lastUpdated
                                 Visible:visible
                                ICalFeed:iCalFeed
                                  ICalID:iCalID];
}

- (void) removeCourseByID:(int)ID
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:dbName];
    return [courseAccess removeCourseByID:ID];
}

- (void) removeAllCourses
{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:dbName];
    return [courseAccess removeAllCourses];
}

@end
