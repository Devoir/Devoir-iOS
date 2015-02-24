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

- (id) init;
- (id) initWithDatabase:(NSString*)db;

- (Course*) getCourseByID:(int)ID;
- (NSArray*) getAllCoursesOrderedByName;

- (Course*) addCourseWithName:(NSString*)name Color:(NSString*)color UserID:(int)userID
              LastUpdated:(NSDate*)lastUpdated ICalFeed:(NSString*)iCalFeed ICalID:(NSString*)iCalID;

- (void) removeCourseByID:(int)ID;
- (void) removeAllCourses;

@end
