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

- (id) init {
    if ((self = [super init]))
    {
        self.dbName = @"devoir-ios.sqlite";
    }
    return self;
}

- (id) initWithDatabase:(NSString*)db {
    if ((self = [super init]))
    {
        self.dbName = db;
    }
    return self;
}

#pragma mark - User Methods
- (User*) getUser {
    UserDBAccess* userAccess = [[UserDBAccess alloc] initWithDatabase:self.dbName];
    return [userAccess getUser];
}

- (User*) addUserWithID:(int)ID Name:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken
             ThemeColor:(UIThemeColor)themeColor {
    UserDBAccess* userAccess = [[UserDBAccess alloc] initWithDatabase:self.dbName];
    return [userAccess addUserWithID:ID Name:name Email:email OAuthToken:oAuthToken ThemeColor:themeColor];
}

- (void)updateUser:(User*)user {
    UserDBAccess* userAccess = [[UserDBAccess alloc] initWithDatabase:self.dbName];
    return [userAccess updateUser:user];
}

- (void) removeUser {
    UserDBAccess* userAccess = [[UserDBAccess alloc] initWithDatabase:self.dbName];
    return [userAccess removeUser];
}

#pragma mark - Course Methods
- (Course*) getCourseByID:(int)ID {
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    return [courseAccess getCourseByID:ID];
}

- (NSArray*) getAllCoursesOrderedByName {
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    return [courseAccess getAllCoursesOrderedByName];
}

- (void)updateCourseWithID:(int)ID Name:(NSString*)name Color:(DevColor)color {
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    return [courseAccess updateCourseWithID:ID Name:name Color:color];
}

- (Course*) addCourseWithID:(int)ID Name:(NSString*)name Color:(DevColor)color UserID:(int)userID
                LastUpdated:(NSDate*)lastUpdated Visible:(BOOL)visible
                   ICalFeed:(NSString*)iCalFeed ICalID:(NSString*)iCalID {
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    return [courseAccess addCourseWithID:ID
                                    Name:name
                                   Color:color
                                  UserID:userID
                             LastUpdated:lastUpdated
                                 Visible:visible
                                ICalFeed:iCalFeed
                                  ICalID:iCalID];
}

- (void) removeCourseByID:(int)ID {
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    return [courseAccess removeCourseByID:ID];
}

- (void) removeAllCourses {
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    return [courseAccess removeAllCourses];
}

#pragma mark - Assignment Methods
- (Assignment*) getAssignmentByID:(int)ID {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    return [assignmentAccess getAssignmentByID:ID];
}

- (NSArray*) getAllAssignmentsOrderedByDate {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    return [assignmentAccess getAllAssignmentsOrderedByDate];
}

- (NSArray*) getAllAssignmentsOrderedByDateForCourse:(int)courseID {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    return [assignmentAccess getAllAssignmentsOrderedByDateForCourse:courseID];
}

@end