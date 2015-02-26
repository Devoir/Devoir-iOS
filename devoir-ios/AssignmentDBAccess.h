//
//  AssignmentDBAccess.h
//  devoir-ios
//
//  Created by Brent on 2/25/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Assignment.h"

@interface AssignmentDBAccess : NSObject

- (id) initWithDatabase:(NSString*)db;

- (Assignment*) getAssignmentByID:(int)ID;
- (NSArray*) getAllAssignmentsOrderedByNameForCourse:(int)courseID;

- (Assignment*) addAssignmentWithID:(int)ID Name:(NSString*)name DueDate:(NSDate*)dueDate
                             Complete:(BOOL)complete Visible:(BOOL)visible
                             CourseID:(int)courseID LastUpdated:(NSDate*)lastUpdated
                AssignmentDescription:(NSString*)assignmentDescription ICalEventID:(NSString*)iCalEventID
                        ICalEventName:(NSString*)iCalEventName iCalEventDescription:(NSString*)iCalEventDescription;

- (void) removeAssignmentByID:(int)ID;
- (void) removeAllAssignmentsForCourse:(int)courseID;
- (void) removeAllAssignments;

@end
