//
//  UserDBAccess.m
//  devoir-ios
//
//  Created by Brent on 2/24/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "UserDBAccess.h"

@interface UserDBAccess()

@property (nonatomic, retain) NSString* dbPath;

@end

@implementation UserDBAccess

- (id) initWithDatabase:(NSString*)db {
    if ((self = [super init]))
    {
        //self.dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:db];
        self.dbPath = [[self GetDocumentDirectory] stringByAppendingPathComponent:db];

    }
    return self;
}

-(NSString *)GetDocumentDirectory{
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return homeDir;
}

#pragma mark - Retrieve from database

- (User*) getUser {
    User* user = nil;
    
    
    sqlite3* db = nil;
    sqlite3_stmt* stmt =nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath UTF8String], &db, SQLITE_OPEN_READONLY , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection: %@", self.dbPath);
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from User"];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil);
        if(rc == SQLITE_OK)
        {
            if (sqlite3_step(stmt) == SQLITE_ROW)
            {
                int ID = sqlite3_column_int(stmt, 0);
                NSString* name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* email = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                NSString* oAuthToken = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                int themeColor = sqlite3_column_int(stmt, 4);
                user = [[User alloc] initWithID:ID
                                           Name:name
                                          Email:email
                                     OAuthToken:oAuthToken
                                     ThemeColor:themeColor];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return user;
}

#pragma mark - Add to database

- (User*) addUserWithID:(int)ID Name:(NSString *)name Email:(NSString *)email OAuthToken:(NSString *)oAuthToken
             ThemeColor:(UIThemeColor)themeColor{
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection: %@", self.dbPath);
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO User (id, Name, Email, OAuthToken, ThemeColor) "
                             "VALUES (%d, \"%@\",\"%@\",\"%@\", %d)",
                             ID, name, email, oAuthToken, themeColor];
        
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    User* user = [[User alloc] initWithID: ID
                                     Name:name
                                    Email:email
                               OAuthToken:oAuthToken
                               ThemeColor:themeColor];
    
    return user;
}

#pragma mark - Update

- (void)updateUser:(User*)user {
    
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
                             stringWithFormat:@"UPDATE User SET "
                             "Name = \"%@\", Email = \"%@\", OAuthToken = \"%@\", ThemeColor = %d "
                             "WHERE id = %d",
                             user.name, user.email, user.oAuthToken, user.themeColor, user.ID];
        
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], nil, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
}


#pragma mark - Delete from database

- (void) removeUser {
    
    sqlite3* db = nil;
    int rc=0;
    rc = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , nil);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection: %@", self.dbPath);
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"DELETE FROM User"];
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