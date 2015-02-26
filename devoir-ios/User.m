//
//  UserModel.m
//  ios-devoir
//
//  Created by Brent on 1/20/15.
//  Copyright (c) 2015 Brent. All rights reserved.
//

#import "User.h"

@implementation User

-(id) initWithID:(int)ID Name:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken
{
    if (self = [super init])
    {
        self.ID = ID;
        self.name = name;
        self.email = email;
        self.oAuthToken = oAuthToken;
    }
    return self;
}

@end
