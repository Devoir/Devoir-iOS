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

- (void)addAssignmentsFromServer {
    AsyncHTTPHandler *httpPost = [[AsyncHTTPHandler alloc] init];
    httpPost.delegate = self;
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:[[VariableStore sharedInstance] serverBaseURL]];
    DBAccess *database = [[DBAccess alloc] init];
    User *user = [database getUser];
    [url appendString:@"/api/courses/"];
    [url appendFormat:@"%d", user.ID];
    [url appendString:@"/tasks/"];
    [httpPost sendGetURL:url];
}

#pragma mark - AsyncHTTPHandlerDelegate methods

- (void)didRecieveResponse:(NSString *)responseBody FromRequest:(NSURLRequest *)request {
    NSData* data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = [[NSError alloc] init];
    NSArray* jsonData = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingMutableContainers
                         error:&error];
    DBAccess *database = [[DBAccess alloc] init];
    for(NSDictionary *assignment in jsonData)
    {
        NSLog(@"NO TASKS ARE BEING ADDED: WAITING ON SERVER TEAM");
    }
}

- (void)connectionDidFail:(NSError *)error {
    
}

@end
