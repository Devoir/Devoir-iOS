//
//  UserDBAccess.h
//  devoir-ios
//
//  Created by Brent on 2/24/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"

@interface UserDBAccess : NSObject

- (id) initWithDatabase:(NSString*)db;

- (User*) getUser;

- (User*) addUserWithName:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken UserID:(int)userID;
- (void) removeUser;

@end
