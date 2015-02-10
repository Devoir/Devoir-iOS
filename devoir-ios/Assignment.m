//
//  Assignment.m
//  devoir-ios
//
//  Created by Brent on 2/9/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "Assignment.h"

@implementation Assignment

-(id) initWithID:(int)ID Name:(NSString*)name DueDate:(NSDate*)dueDate Complete:(BOOL)complete
        Visible:(BOOL)visible CourseID:(int)courseID LastUpated:(NSDate*)lastUpdated
        AssignmentDescription:(NSString*)assignmentDescription ICalEventID:(NSString*)iCalEventID
        ICalEventName:(NSString*)iCalEventName ICalDescription:(NSString*)iCalEventDescription
{
    if (self = [super init])
    {
        self.ID = ID;
        self.name = name;
        self.dueDate = dueDate;
        self.complete = complete;
        self.visible = visible;
        self.courseID = courseID;
        self.lastUpdated = lastUpdated;
        self.assignmentDescription = assignmentDescription;
        self.iCalEventID = iCalEventID;
        self.iCalEventName = iCalEventName;
        self.iCalEventDescription = iCalEventDescription;
    }
    return self;
}

-(id) initWithName:(NSString*)name DueDate:(NSDate*)dueDate CourseID:(int)courseID
    AssignmentDescription:(NSString*)assignmentDescription
{
    if (self = [super init])
    {
        self.ID = -1;
        self.name = name;
        self.dueDate = dueDate;
        self.complete = NO;
        self.visible = YES;
        self.courseID = courseID;
        self.lastUpdated = nil;
        self.assignmentDescription = assignmentDescription;
        self.iCalEventID = nil;
        self.iCalEventName = nil;
        self.iCalEventDescription = nil;
    }
    return self;
}

@end
