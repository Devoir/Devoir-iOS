//
//  AssignmentServerAccess.m
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AssignmentServerAccess.h"
#import "VariableStore.h"
#import "AsyncHTTPHandler.h"
#import "DBAccess.h"


@interface AssignmentServerAccess() <AsyncHTTPHandlerDelegate>

@end

@implementation AssignmentServerAccess

- (void)getAssignments {
    DBAccess *database = [[DBAccess alloc] init];

    NSArray *courses = [database getAllCoursesOrderedByName];
    for(Course *course in courses)
    {
        AsyncHTTPHandler *httpPost = [[AsyncHTTPHandler alloc] init];
        httpPost.delegate = self;
    
        NSMutableString *url = [[NSMutableString alloc] initWithString:[[VariableStore sharedInstance] serverBaseURL]];
        [url appendString:@"/api/courses/"];
        [url appendFormat:@"%d", course.ID];
        [url appendString:@"/tasks/"];
        [httpPost synchronusGetURL:url Endpoint:GetAllAssignmentsForCourse];
    }
}

#pragma mark - AsyncHTTPHandlerDelegate methods

- (void)didRecieveResponse:(NSString *)responseBody FromEndpoint:(NSNumber *)endpoint {
    if((DevoirAPIEndpoint)[endpoint intValue] == GetAllAssignmentsForCourse)
    {
        [self handleGetAssignmentsResponse:responseBody];
    }
}

- (void)connectionDidFail:(NSError *)error {
    
}

#pragma mark - Response handlers

- (void)handleGetAssignmentsResponse:(NSString*)responseBody {
    NSData* data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = [[NSError alloc] init];
    NSArray* jsonData = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingMutableContainers
                         error:&error];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.sssZ"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss+ssss"];
    DBAccess *database = [[DBAccess alloc] init];
    for(NSDictionary *iassignment in jsonData)
    {
        int assignmentID = (int)[iassignment[@"id"] integerValue];
        NSString *name = iassignment[@"name"];
        NSString *dueDate = iassignment[@"end_date"];
        BOOL complete = (int)[iassignment[@"complete"] integerValue];
        BOOL visible = (int)[iassignment[@"visible"] integerValue];
        int courseID = (int)[iassignment[@"course_id"] integerValue];
        NSString *lastUpdated = iassignment[@"last_updated"];
        NSString *description = iassignment[@"description"];
        
        Assignment* assignment = [[Assignment alloc] initWithID:assignmentID Name:name
                                                        DueDate:[dateFormatter dateFromString:dueDate] Complete:complete Visible:visible
                                                       CourseID:courseID LastUpated:[dateFormatter dateFromString:lastUpdated]
                                          AssignmentDescription:description ICalEventID:nil ICalEventName:nil ICalDescription:nil];
        [database addAssignment:assignment];
    }
}

@end
