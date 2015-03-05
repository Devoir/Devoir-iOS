//
//  AssignmentDBAccess.m
//  devoir-ios
//
//  Created by Brent on 2/25/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AssignmentDBAccess.h"

@interface AssignmentDBAccess()

@property (nonatomic, retain) NSString* dbName;

@end

@implementation AssignmentDBAccess

@synthesize dbName;

- (id) initWithDatabase:(NSString*)db
{
    if ((self = [super init]))
    {
        dbName = db;
    }
    return self;
}

- (Assignment*) getAssignmentByID:(int)ID
{
    Assignment* assignment = nil;
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = nil;
    sqlite3_stmt* stmt =nil;
    int rc=0;
    rc = sqlite3_open_v2([dbPath UTF8String], &db, SQLITE_OPEN_READONLY , nil);
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

- (NSArray*) getAllAssignmentsOrderedByName
{
    NSMutableArray* assignments = [[NSMutableArray alloc] init];
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = nil;
    sqlite3_stmt* stmt =nil;
    int rc=0;
    rc = sqlite3_open_v2([dbPath UTF8String], &db, SQLITE_OPEN_READONLY , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from Assignment ORDER BY Name ASC"];
        
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
    
    return [assignments copy];
}

- (NSArray*) getAllAssignmentsOrderedByNameForCourse:(int)courseID
{
    NSMutableArray* assignments = [[NSMutableArray alloc] init];
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = nil;
    sqlite3_stmt* stmt =nil;
    int rc=0;
    rc = sqlite3_open_v2([dbPath UTF8String], &db, SQLITE_OPEN_READONLY , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from Assignment WHERE CourseID = %d ORDER BY Name ASC", courseID];
        
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
    
    return [assignments copy];
}

- (NSArray*) getAllAssignmentsOrderedByDate
{
    NSMutableArray* assignments = [[NSMutableArray alloc] init];
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = nil;
    sqlite3_stmt* stmt =nil;
    int rc=0;
    rc = sqlite3_open_v2([dbPath UTF8String], &db, SQLITE_OPEN_READONLY , nil);
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
    
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    NSMutableArray* orderedAssignments = [[NSMutableArray alloc] init];
    NSDate *curDate = [self dateAtBeginningOfDayForDate:((Assignment*)[assignments objectAtIndex:0]).dueDate];
    for (Assignment *event in assignments)
    {
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.dueDate];
        if([curDate isEqual:dateRepresentingThisDay])
        {

            [tempArray addObject:event];
        }
        else
        {
            curDate = dateRepresentingThisDay;
            [orderedAssignments addObject:[tempArray copy]];
            tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:event];
        }
    }
    [orderedAssignments addObject:tempArray];
    
    return [orderedAssignments copy];
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
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

@end
