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

- (NSString*) dueDateAsString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    return [formatter stringFromDate:self.dueDate];
}

@end
