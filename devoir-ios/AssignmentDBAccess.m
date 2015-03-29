//
//  AssignmentDBAccess.m
//  devoir-ios
//
//  Created by Brent on 2/25/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AssignmentDBAccess.h"

@interface AssignmentDBAccess()
@property (nonatomic, retain) NSString *dbPath;
@end

@implementation AssignmentDBAccess

- (id) initWithDatabase:(NSString*)db {
    if ((self = [super init]))
    {
        self.dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:db];
    }
    return self;
}

#pragma mark - Utility Functions

- (NSMutableArray *) sortAssignmentByDate:(NSArray *)unsortedAssignments {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSMutableArray *orderedAssignments = [[NSMutableArray alloc] init];
    NSMutableArray *completedAssignments = [[NSMutableArray alloc] init];
    
    NSDate *today = [self dateAtBeginningOfDayForDate:[NSDate date]];
    NSDate *curDate = [self dateAtBeginningOfDayForDate:((Assignment*)[unsortedAssignments objectAtIndex:0]).dueDate];
    BOOL late = 0;
    if([today compare:curDate] == NSOrderedDescending)
    {
        late = 1;
    }
    for (Assignment *event in unsortedAssignments)
    {
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.dueDate];

        if(event.complete)
        {
            [completedAssignments addObject:event];
            continue;
        }
        
        if(late)
        {
            if([today compare:dateRepresentingThisDay] == NSOrderedDescending)
            {
                [tempArray addObject:event];
            }
            else
            {
                late = 0;
                curDate = dateRepresentingThisDay;
                if([tempArray count] > 0)
                    [orderedAssignments addObject:tempArray];
                tempArray = [[NSMutableArray alloc] init];
                [tempArray addObject:event];
            }
            continue;
        }

        if([curDate compare:dateRepresentingThisDay] == NSOrderedSame)
        {
            
            [tempArray addObject:event];
        }
        else
        {
            curDate = dateRepresentingThisDay;
            if([tempArray count] > 0)
                [orderedAssignments addObject:tempArray];
            tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:event];
        }
    }
    if([tempArray count] > 0)
        [orderedAssignments addObject:tempArray];
    if([completedAssignments count] > 0)
        [orderedAssignments addObject:completedAssignments];
    return orderedAssignments;
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

#pragma mark - Retrieve from database

- (Assignment*) getAssignmentByID:(int)ID {
    Assignment* assignment = nil;
    
    sqlite3* db = nil;
    sqlite3_stmt* stmt =nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath UTF8String], &db, SQLITE_OPEN_READONLY , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from Assignment WHERE id = %d", ID];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                int ID =sqlite3_column_int(stmt, 0);
                NSString* name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString *stringDueDate = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                BOOL complete = sqlite3_column_int(stmt, 3);
                BOOL visible = sqlite3_column_int(stmt, 4);
                int courseID = sqlite3_column_int(stmt, 5);
                //NSDate* lastUpdated = [NSString stringWithUTF8String:(const char *)sqlite3_column_(stmt, 6)];
                
                NSString* assignmentDescription;
                const char *temp = (const char *)sqlite3_column_text(stmt, 7);
                if(temp)
                    assignmentDescription = @(temp);
                
                NSString* iCalEventID;
                temp = (const char *)sqlite3_column_text(stmt, 8);
                if(temp)
                    iCalEventID = @(temp);
                
                NSString* iCalEventName;
                temp = (const char *)sqlite3_column_text(stmt, 9);
                if(temp)
                    iCalEventName = @(temp);
                
                NSString* iCalEventDescription;
                temp = (const char *)sqlite3_column_text(stmt, 10);
                if(temp)
                    iCalEventDescription = @(temp);

                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                
                assignment = [[Assignment alloc] initWithID:ID
                                                       Name:name
                                                    DueDate:[formatter dateFromString:stringDueDate]
                                                   Complete:complete
                                                    Visible:visible
                                                   CourseID:courseID
                                                 LastUpated:nil
                                      AssignmentDescription:assignmentDescription
                                                ICalEventID:iCalEventID
                                              ICalEventName:iCalEventName
                                    ICalDescription:iCalEventDescription];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return assignment;
}

- (NSMutableArray*) getAllAssignmentsOrderedByDate {
    NSMutableArray* assignments = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    sqlite3_stmt* stmt =nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath UTF8String], &db, SQLITE_OPEN_READONLY , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from Assignment ORDER BY DueDate ASC, CourseID"];
        
        rc = sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                int ID =sqlite3_column_int(stmt, 0);
                NSString* name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString *stringDueDate = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                BOOL complete = sqlite3_column_int(stmt, 3);
                BOOL visible = sqlite3_column_int(stmt, 4);
                int courseID = sqlite3_column_int(stmt, 5);
                //NSDate* lastUpdated = [NSString stringWithUTF8String:(const char *)sqlite3_column_(stmt, 6)];
                
                NSString* assignmentDescription;
                const char *temp = (const char *)sqlite3_column_text(stmt, 7);
                if(temp)
                    assignmentDescription = @(temp);
                
                NSString* iCalEventID;
                temp = (const char *)sqlite3_column_text(stmt, 8);
                if(temp)
                    iCalEventID = @(temp);
                
                NSString* iCalEventName;
                temp = (const char *)sqlite3_column_text(stmt, 9);
                if(temp)
                    iCalEventName = @(temp);
                
                NSString* iCalEventDescription;
                temp = (const char *)sqlite3_column_text(stmt, 10);
                if(temp)
                    iCalEventDescription = @(temp);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                
                Assignment *assignment = [[Assignment alloc] initWithID:ID
                                                                   Name:name
                                                                DueDate:[formatter dateFromString:stringDueDate]
                                                               Complete:complete
                                                                Visible:visible
                                                               CourseID:courseID
                                                             LastUpated:nil
                                                  AssignmentDescription:assignmentDescription
                                                            ICalEventID:iCalEventID
                                                          ICalEventName:iCalEventName
                                                        ICalDescription:iCalEventDescription];
                
                [assignments addObject:assignment];
                
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    if(assignments.count == 0)
        return assignments;
    
    return [self sortAssignmentByDate:assignments];
}

- (NSMutableArray*) getAllAssignmentsOrderedByDateForCourse:(int)courseID {
    NSMutableArray* assignments = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    sqlite3_stmt* stmt =nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath UTF8String], &db, SQLITE_OPEN_READONLY , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from Assignment WHERE CourseID = %d ORDER BY DueDate ASC", courseID];
        
        rc = sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                int ID =sqlite3_column_int(stmt, 0);
                NSString* name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString *stringDueDate = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                BOOL complete = sqlite3_column_int(stmt, 3);
                BOOL visible = sqlite3_column_int(stmt, 4);
                int courseID = sqlite3_column_int(stmt, 5);
                //NSDate* lastUpdated = [NSString stringWithUTF8String:(const char *)sqlite3_column_(stmt, 6)];
                
                NSString* assignmentDescription;
                const char *temp = (const char *)sqlite3_column_text(stmt, 7);
                if(temp)
                    assignmentDescription = @(temp);
                
                NSString* iCalEventID;
                temp = (const char *)sqlite3_column_text(stmt, 8);
                if(temp)
                    iCalEventID = @(temp);
                
                NSString* iCalEventName;
                temp = (const char *)sqlite3_column_text(stmt, 9);
                if(temp)
                    iCalEventName = @(temp);
                
                NSString* iCalEventDescription;
                temp = (const char *)sqlite3_column_text(stmt, 10);
                if(temp)
                    iCalEventDescription = @(temp);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
                [formatter setLocale:enUSPOSIXLocale];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                
                Assignment *assignment = [[Assignment alloc] initWithID:ID
                                                                   Name:name
                                                                DueDate:[formatter dateFromString:stringDueDate]
                                                               Complete:complete
                                                                Visible:visible
                                                               CourseID:courseID
                                                             LastUpated:nil
                                                  AssignmentDescription:assignmentDescription
                                                            ICalEventID:iCalEventID
                                                          ICalEventName:iCalEventName
                                                        ICalDescription:iCalEventDescription];
                
                [assignments addObject:assignment];
                
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    if(assignments.count == 0)
        return assignments;
    
    return [self sortAssignmentByDate:assignments];
}

#pragma mark - Update database

- (void)updateAssignment:(Assignment*)assignment {
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"UPDATE Assignment SET "
                             "Name = \"%@\", DueDate = \"%@\", Complete = %d, Visible = %d, CourseID = %d, LastUpdated = \"%@\", AssignmentDescription = \"%@\" "
                             "WHERE id = %d",
                             assignment.name, assignment.dueDate, assignment.complete,
                             assignment.visible, assignment.courseID, assignment.lastUpdated, assignment.assignmentDescription, assignment.ID];
        
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
}

- (void)markAsComplete:(Assignment*)assignment {
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"UPDATE Assignment SET "
                             "Complete = %d "
                             "WHERE id = %d",
                             assignment.complete, assignment.ID];
        
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
}

#pragma mark - Add to database

- (Assignment*)addAssignment:(Assignment *)assignment {
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:enUSPOSIXLocale];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO Assignment"
                             "(id, Name, DueDate, Complete, Visible, CourseID, LastUpdated, AssignmentDescription, "
                             "ICalEventID, ICalEventName, ICalEventDescription) "
                             "VALUES (%d, \"%@\",\"%@\",%d,%d,%d,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                             assignment.ID, assignment.name, [formatter stringFromDate:assignment.dueDate], assignment.complete,
                             assignment.visible, assignment.courseID, [formatter stringFromDate:assignment.lastUpdated], assignment.assignmentDescription,
                             assignment.iCalEventID, assignment.iCalEventName, assignment.iCalEventDescription];
        
        //NSLog(@"QUERY: %@", query);
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    int insertedID = (int)sqlite3_last_insert_rowid(db);
    
    assignment.ID = insertedID;
    
    return assignment;
}

#pragma mark - Remove from database

- (void) removeAssignmentByID:(int)ID {
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"DELETE FROM Assignment WHERE id = %d", ID];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
}

- (void)removeAllAssignmentsForCourse:(int)courseID {
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"DELETE FROM Assignment WHERE CourseID = %d", courseID];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
}

- (void)removeAllAssignments {
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"DELETE FROM Assignment"];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
}

@end
