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
        self.dbName = [VariableStore sharedInstance].dbPath;
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

- (void)updateCourse:(Course*)course {
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    return [courseAccess updateCourse:course];
}

- (Course*) addCourse:(Course*)course{
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    return [courseAccess addCourse:course];
}

- (void) removeCourseByID:(int)ID {
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    [self removeAllAssignmentsForCourse:ID];
    return [courseAccess removeCourseByID:ID];
}

- (void) removeAllCourses {
    CourseDBAccess* courseAccess = [[CourseDBAccess alloc] initWithDatabase:self.dbName];
    [self removeAllAssignments];
    return [courseAccess removeAllCourses];
}

#pragma mark - Assignment Methods
- (Assignment*) getAssignmentByID:(int)ID {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    return [assignmentAccess getAssignmentByID:ID];
}

- (NSMutableArray*) getAllAssignmentsOrderedByDate {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    return [assignmentAccess getAllAssignmentsOrderedByDate];
}

- (NSMutableArray*) getAllAssignmentsOrderedByDateForCourse:(int)courseID {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    return [assignmentAccess getAllAssignmentsOrderedByDateForCourse:courseID];
}

- (void)updateAssignment:(Assignment*)assignment {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    return [assignmentAccess updateAssignment:assignment];
}

- (void)markAsComplete:(Assignment*)assignment {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    return [assignmentAccess markAsComplete:assignment];
}

- (Assignment*)addAssignment:(Assignment*)assignment {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    return [assignmentAccess addAssignment:assignment];
}

- (void)removeAssignmentByID:(int)ID {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    [assignmentAccess removeAssignmentByID:ID];
}

- (void)removeAllAssignmentsForCourse:(int)courseID {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    [assignmentAccess removeAllAssignmentsForCourse:courseID];
}

- (void)removeAllAssignments {
    AssignmentDBAccess* assignmentAccess = [[AssignmentDBAccess alloc] initWithDatabase:self.dbName];
    [assignmentAccess removeAllAssignments];
}


@end












