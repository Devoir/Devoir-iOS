//
//  CourseServerAccess.m
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "CourseServerAccess.h"
#import "VariableStore.h"
#import "AsyncHTTPHandler.h"
#import "DBAccess.h"

@interface CourseServerAccess() <AsyncHTTPHandlerDelegate>

@end

@implementation CourseServerAccess

- (void)getCourses {
    AsyncHTTPHandler *httpPost = [[AsyncHTTPHandler alloc] init];
    httpPost.delegate = self;
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:[[VariableStore sharedInstance] serverBaseURL]];
    DBAccess *database = [[DBAccess alloc] init];
    User *user = [database getUser];
    [url appendString:@"/api/users/"];
    [url appendFormat:@"%d", user.ID];
    [url appendString:@"/courses/"];
    [httpPost synchronusGetURL:url Endpoint:GetAllCoursesForUser];
}

-(void)addCourse:(Course*)course {
    AsyncHTTPHandler *httpPost = [[AsyncHTTPHandler alloc] init];
    httpPost.delegate = self;
    NSMutableString* requestBody = [[NSMutableString alloc] init];
    [requestBody appendString:@"name="];
    [requestBody appendString:course.name];
    [requestBody appendString:@"&color="];
    [requestBody appendString:[NSString stringWithFormat:@"%d", course.color]];
    [requestBody appendString:@"&visible="];
    [requestBody appendString:[NSString stringWithFormat:@"%d", course.visible]];
    [requestBody appendString:@"&ical_feed_url="];
    if(course.iCalFeed)
    {
        [requestBody appendString:course.iCalFeed];
    }
    [requestBody appendString:@"&user_id="];
    [requestBody appendString:[NSString stringWithFormat:@"%d", course.userID]];
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:[[VariableStore sharedInstance] serverBaseURL]];
    [url appendString:@"/api/courses"];
    [httpPost sendPostURL:url Body:requestBody Endpoint:AddCourse];
}

#pragma mark - AsyncHTTPHandlerDelegate methods

- (void)didRecieveResponse:(NSString *)responseBody FromEndpoint:(NSNumber *)endpoint {
    if((DevoirAPIEndpoint)[endpoint intValue] == GetAllCoursesForUser)
    {
        [self handleGetCoursesResponse:responseBody];
    }
    else if((DevoirAPIEndpoint)[endpoint intValue] == AddCourse)
    {
        [self handleAddCourseResponse:responseBody];
    }
}

- (void)connectionDidFail:(NSError *)error {
    
}

#pragma mark - Response handlers

- (void)handleGetCoursesResponse:(NSString*)responseBody {
    NSData* data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = [[NSError alloc] init];
    NSArray* jsonData = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingMutableContainers
                         error:&error];
    DBAccess *database = [[DBAccess alloc] init];
    for(NSDictionary *course in jsonData)
    {
        int courseID = (int)[course[@"id"] integerValue];
        NSString *name = course[@"name"];
        DevColor theme = (int)[course[@"color"] integerValue];
        int userID = (int)[course[@"user_id"] integerValue];
        int visibe = (int)[course[@"visible"] integerValue];
        NSString *iCalFeedURL = nil;
        if(![course[@"ical_feed_url"] isEqualToString:@""])
        {
            iCalFeedURL = course[@"ical_feed_url"];
        }
        Course *course = [[Course alloc] initWithID:courseID
                                               Name:name
                                              Color:theme
                                             UserID:userID
                                        LastUpdated:nil
                                            Visible:visibe
                                           ICalFeed:iCalFeedURL
                                             ICalID:nil];
        [database addCourse:course];
    }
}

- (void)handleAddCourseResponse:(NSString*)responseBody {
    
}

@end
