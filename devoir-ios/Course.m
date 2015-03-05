//
//  Course.m
//  ios-devoir
//
//  Created by Brent on 1/24/15.
//  Copyright (c) 2015 Brent. All rights reserved.
//

#import "Course.h"

@implementation Course

-(id) initWithID:(int)ID Name:(NSString*)name Color:(DevColor)color UserID:(int)userID
     LastUpdated:(NSDate*)lastUpdated Visible:(BOOL)visible ICalFeed:(NSString*)iCalFeed ICalID:(NSString*)iCalID
{
    if (self = [super init])
    {
        self.ID = ID;
        self.name = name;
        self.color = color;
        self.userID = userID;
        self.lastUpdated = lastUpdated;
        self.visible = visible;
        self.iCalFeed = iCalFeed;
        self.iCalID = iCalID;
    }
    return self;
}

@end
