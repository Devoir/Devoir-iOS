//
//  UserModel.m
//  ios-devoir
//
//  Created by Brent on 1/20/15.
//  Copyright (c) 2015 Brent. All rights reserved.
//

#import "User.h"

@implementation User

-(id) initWithName:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken UserID:(int)userID
{
    if (self = [super init])
    {
        self.name = name;
        self.email = email;
        self.oAuthToken = oAuthToken;
        self.userID = userID;
    }
    return self;
}

@end
