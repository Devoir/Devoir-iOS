//
//  Assignment.h
//  devoir-ios
//
//  Created by Brent on 2/9/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Assignment : NSObject

//required
@property int ID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSDate* dueDate;
@property BOOL complete;
@property BOOL visible;
@property int courseID;
@property (nonatomic, strong) NSDate* lastUpdated;

//optional
@property (nonatomic, strong) NSString* assignmentDescription;
@property (nonatomic, strong) NSString* iCalEventID;
@property (nonatomic, strong) NSString* iCalEventName;
@property (nonatomic, strong) NSString* iCalEventDescription;

//has all properties (database)
-(id) initWithID:(int)ID Name:(NSString*)name DueDate:(NSDate*)dueDate Complete:(BOOL)complete
        Visible:(BOOL)visible CourseID:(int)courseID LastUpated:(NSDate*) lastUpdated
        AssignmentDescription:(NSString*)assignmentDescription ICalEventID:(NSString*)iCalEventID
        ICalEventName:(NSString*)iCalEventName ICalDescription:(NSString*)iCalEventDescription;

@end
