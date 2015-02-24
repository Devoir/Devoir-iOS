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

@interface DBAccess : NSObject

//User Methods
- (User*) getUser;

- (User*) addUserWithName:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken UserID:(int)userID;
- (void) removeUser;

//Course Methods
- (Course*) getCourseByID:(int)ID;
- (NSArray*) getAllCoursesOrderedByName;

- (Course*) addCourseWithName:(NSString*)name Color:(NSString*)color UserID:(int)userID
                  LastUpdated:(NSDate*)lastUpdated ICalFeed:(NSString*)iCalFeed ICalID:(NSString*)iCalID;

- (void) removeCourseByID:(int)ID;
- (void) removeAllCourses;

@end
