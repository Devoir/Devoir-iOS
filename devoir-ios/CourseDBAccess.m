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

- (id) init
{
    if ((self = [super init]))
    {
        dbName = @"devoir-ios.sqlite";
    }
    return self;
}

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
    Course* course = NULL;
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([dbPath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from Course WHERE id = %d", ID];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                //GET DATE STUFF!
                int ID =sqlite3_column_int(stmt, 0);
                NSString* name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* color = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                int userID = sqlite3_column_int(stmt, 3);
                //NSDate* lastUpdated = [NSString stringWithUTF8String:(const char *)sqlite3_column_(stmt, 4)];
                NSString* iCalFeed = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                NSString* iCalID = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                
                course = [[Course alloc] init];
                [course setID:ID];
                [course setName:name];
                [course setColor:color];
                [course setICalFeed:iCalFeed];
                [course setICalID:iCalID];
                [course setUserID:userID];
                //LAST UPDATED STUFF
                
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
    
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([dbPath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from Course ORDER BY Name ASC"];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                //GET DATE STUFF!
                int ID =sqlite3_column_int(stmt, 0);
                NSString* name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* color = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                int userID = sqlite3_column_int(stmt, 3);
                //NSDate* lastUpdated = [NSString stringWithUTF8String:(const char *)sqlite3_column_(stmt, 4)];
                NSString* iCalFeed = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                NSString* iCalID = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                
                Course* course = [[Course alloc] init];
                [course setID:ID];
                [course setName:name];
                [course setColor:color];
                [course setICalFeed:iCalFeed];
                [course setICalID:iCalID];
                [course setUserID:userID];
                //LAST UPDATED STUFF

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

- (Course*) addCourseWithName:(NSString*)name Color:(NSString*)color UserID:(int)userID
              LastUpdated:(NSDate*)lastUpdated ICalFeed:(NSString*)iCalFeed ICalID:(NSString*)iCalID
{
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO Course"
                             "(Name, Color, UserID, LastUpdated, iCalFeed, iCalID) "
                             "VALUES (\"%@\",\"%@\",%d,\"%@\",\"%@\",\"%@\")",
                             name, color, userID, lastUpdated, iCalFeed, iCalID];
        
        NSLog(@"QUERY: %@", query);
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
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
                                       ICalFeed:iCalFeed
                                         ICalID:iCalID];
    
    return course;
}

- (void) removeCourseByID:(int)ID
{
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbName];
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"DELETE FROM Course WHERE id = %d", ID];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
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
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"DELETE FROM Course"];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
}

@end
