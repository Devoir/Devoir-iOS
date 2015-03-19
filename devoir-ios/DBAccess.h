//
//  DBAccess.h
//  devoir-ios
//
//  Created by Brent on 2/24/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#include "Course.h"
#include "UserDBAccess.h"
#include "CourseDBAccess.h"
#include "AssignmentDBAccess.h"

@interface DBAccess : NSObject

- (id)init;
- (id)initWithDatabase:(NSString*)db;

//User Methods
- (User*)getUser;
- (User*)addUserWithID:(int)ID Name:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken
            ThemeColor:(UIThemeColor)themeColor;
- (void)updateUser:(User*)user;
- (void)removeUser;

//Course Methods
- (Course*)getCourseByID:(int)ID;
- (NSArray*)getAllCoursesOrderedByName;
- (void)updateCourse:(Course*)course;
- (Course*)addCourse:(Course*)course;
- (void)removeCourseByID:(int)ID;
- (void)removeAllCourses;

//Assignment Methods
- (Assignment*)getAssignmentByID:(int)ID;
- (NSMutableArray*)getAllAssignmentsOrderedByDate;
- (NSMutableArray*)getAllAssignmentsOrderedByDateForCourse:(int)courseID;
- (void)updateAssignment:(Assignment*)assignment;
- (Assignment*)addAssignment:(Assignment*)assignment;

@end