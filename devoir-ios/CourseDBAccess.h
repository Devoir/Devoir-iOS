//
//  CourseDBAccess.h
//  devoir-ios
//
//  Created by Brent on 2/24/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Course.h"

@interface CourseDBAccess : NSObject

- (id)initWithDatabase:(NSString*)db;

- (Course*)getCourseByID:(int)ID;
- (NSArray*)getAllCoursesOrderedByName;

- (Course*)addCourseWithID:(int)ID Name:(NSString*)name Color:(DevColor)color UserID:(int)userID
               LastUpdated:(NSDate*)lastUpdated Visible:(BOOL)visible
                  ICalFeed:(NSString*)iCalFeed ICalID:(NSString*)iCalID;

- (void)updateCourseWithID:(int)ID Name:(NSString*)name Color:(DevColor)color;

- (void)removeCourseByID:(int)ID;
- (void)removeAllCourses;

@end