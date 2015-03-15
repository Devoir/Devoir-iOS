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

- (id) initWithDatabase:(NSString*)db {
    if ((self = [super init]))
    {
        self.dbName = db;
    }
    return self;
}

#pragma mark - Retrieve from database

- (Course*) getCourseByID:(int)ID {
    Course* course = nil;
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:self.dbName];
    
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

- (NSArray*) getAllCoursesOrderedByName {
    NSMutableArray* courses = [[NSMutableArray alloc] init];
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:self.dbName];
    
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

#pragma mark - Update database

- (void)updateCourse:(Course*)course {
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:self.dbName];
    
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
                             stringWithFormat:@"UPDATE Course SET "
                             "Name = \"%@\", Color = %d "
                             "WHERE id = %d",
                             course.name, course.color, course.ID];
        
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

- (Course*) addCourse:(Course*)course {
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:self.dbName];
    
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
                             course.ID, course.name, course.color, course.userID,
                             course.lastUpdated, course.visible, course.iCalFeed, course.iCalID];
        
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
    
    course.ID = insertedID;
    
    return course;
}

#pragma mark - Remove from database

- (void) removeCourseByID:(int)ID {
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:self.dbName];
    
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

- (void) removeAllCourses {
    NSString* dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:self.dbName];
    
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
