//
//  CourseDBAccess.m
//  devoir-ios
//
//  Created by Brent on 2/24/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "CourseDBAccess.h"

@interface CourseDBAccess()

@property (nonatomic, retain) NSString* dbName;

@end

@implementation CourseDBAccess

@synthesize dbName;

- (id) initWithDatabase:(NSString*)db
{
    if ((self = [super init]))
    {
        dbName = db;
    }
    return self;
}

- (Course*) getCourseByID:(int)ID
{
    Course* course = nil;
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
        NSString  * query = [NSString stringWithFormat:@"SELECT * from Course WHERE id = %d", ID];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                int ID = sqlite3_column_int(stmt, 0);
                NSString* name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                int color = sqlite3_column_int(stmt, 2);
                int userID = sqlite3_column_int(stmt, 3);
                //NSDate* lastUpdated = [NSString stringWithUTF8String:(const char *)sqlite3_column_(stmt, 4)];
                BOOL visible = sqlite3_column_int(stmt, 5);
                
                NSString *iCalFeed;
                const char *temp = (const char *)sqlite3_column_text(stmt, 6);
                if(temp)
                    iCalFeed = @(temp);
                
                NSString *iCalID;
                temp = (const char *)sqlite3_column_text(stmt, 7);
                if(temp)
                    iCalID = @(temp);
                
                course = [[Course alloc] initWithID:ID
                                               Name:name
                                              Color:color
                                             UserID:userID
                                        LastUpdated:nil
                                            Visible:visible
                                           ICalFeed:iCalFeed
                                             ICalID:iCalID];
                
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return course;
}

- (NSArray*) getAllCoursesOrderedByName
{
    NSMutableArray* courses = [[NSMutableArray alloc] init];
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
        NSString  * query = [NSString stringWithFormat:@"SELECT * from Course ORDER BY Name ASC"];
        
        rc = sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                int ID =sqlite3_column_int(stmt, 0);
                NSString* name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                int color = sqlite3_column_int(stmt, 2);
                int userID = sqlite3_column_int(stmt, 3);
                //NSDate* lastUpdated = [NSString stringWithUTF8String:(const char *)sqlite3_column_(stmt, 4)];
                BOOL visible = sqlite3_column_int(stmt, 5);
                
                NSString *iCalFeed;
                const char *temp = (const char *)sqlite3_column_text(stmt, 6);
                if(temp)
                    iCalFeed = @(temp);
                
                NSString *iCalID;
                temp = (const char *)sqlite3_column_text(stmt, 7);
                if(temp)
                    iCalID = @(temp);
                
                Course* course = [[Course alloc] initWithID:ID
                                               Name:name
                                              Color:color
                                             UserID:userID
                                        LastUpdated:nil
                                            Visible:visible
                                           ICalFeed:iCalFeed
                                             ICalID:iCalID];

                [courses addObject:course];
                
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return [courses copy];
}

- (Course*) addCourseWithID:(int)ID Name:(NSString*)name Color:(DevColor)color UserID:(int)userID
                  LastUpdated:(NSDate*)lastUpdated Visible:(BOOL)visible
                     ICalFeed:(NSString*)iCalFeed ICalID:(NSString*)iCalID
{
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO Course"
                             "(id, Name, Color, UserID, LastUpdated, Visible, iCalFeed, iCalID) "
                             "VALUES (%d, \"%@\",\"%d\",%d,\"%@\",%d,\"%@\",\"%@\")",
                             ID, name, color, userID, lastUpdated, visible, iCalFeed, iCalID];
        
        NSLog(@"QUERY: %@", query);
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    int insertedID = (int)sqlite3_last_insert_rowid(db);
    
    Course* course = [[Course alloc] initWithID:insertedID
                                           Name:name
                                          Color:color
                                         UserID:userID
                                    LastUpdated:lastUpdated
                                        Visible:visible
                                       ICalFeed:iCalFeed
                                         ICalID:iCalID];
    
    return course;
}

- (void) removeCourseByID:(int)ID
{
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"DELETE FROM Course WHERE id = %d", ID];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
}

- (void) removeAllCourses
{
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"DELETE FROM Course"];
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
