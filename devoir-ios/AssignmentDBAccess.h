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

- (id)initWithDatabase:(NSString*)db;

- (Assignment*)getAssignmentByID:(int)ID;
- (NSMutableArray*)getAllAssignmentsOrderedByDate;
- (NSMutableArray*)getAllAssignmentsOrderedByDateForCourse:(int)courseID;

- (Assignment*)addAssignment:(Assignment*)assignment;
- (void)updateAssignment:(Assignment*)assignment;

- (void)removeAssignmentByID:(int)ID;
- (void)removeAllAssignmentsForCourse:(int)courseID;
- (void)removeAllAssignments;

@end