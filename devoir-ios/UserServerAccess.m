//
//  UserServerAccess.m
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "UserServerAccess.h"
#import "VariableStore.h"
#import "AsyncHTTPHandler.h"
#import "DBAccess.h"

@interface UserServerAccess() <AsyncHTTPHandlerDelegate>

@end

@implementation UserServerAccess

- (void)loginWithEmail:(NSString *)email {
    AsyncHTTPHandler *httpPost = [[AsyncHTTPHandler alloc] init];
    httpPost.delegate = self;
    NSMutableString* requestBody = [[NSMutableString alloc] init];
    [requestBody appendString:@"email="];
    [requestBody appendString:email];
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:[[VariableStore sharedInstance] serverBaseURL]];
    [url appendString:@"/api/login"];
    [httpPost sendPostURL:url Body:requestBody Endpoint:LoginUserWithEmail];
}

#pragma mark - AsyncHTTPHandlerDelegate methods

- (void)didRecieveResponse:(NSString *)responseBody FromEndpoint:(NSNumber *)endpoint {
    if((DevoirAPIEndpoint)[endpoint intValue] == LoginUserWithEmail)
    {
        [self handleLoginWithEmailResponse:responseBody];
    }
}

- (void)connectionDidFail:(NSError *)error {
    [self.delegate performSelector:@selector(connectionDidFail:) withObject:error];
}

#pragma mark - Response handlers

- (void)handleLoginWithEmailResponse:(NSString*)responseBody {
    if(![responseBody isEqual:@"null"])
    {
        NSData* data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = [[NSError alloc] init];
        NSDictionary* jsonData = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
        int userID = (int)[jsonData[@"id"] integerValue];
        NSString *name = jsonData[@"display_name"];
        NSString *email = jsonData[@"email"];
        
        DBAccess *database = [[DBAccess alloc] init];
        [database addUserWithID:userID Name:name Email:email OAuthToken:nil ThemeColor:DARK];
        
        [VariableStore sharedInstance].themeColor = DARK;
        
        
        [self.delegate performSelector:@selector(didLogin:) withObject:[NSNumber numberWithBool:YES]];
    }
    else
    {
        [self.delegate performSelector:@selector(didLogin:) withObject:[NSNumber numberWithBool:NO]];
        
    }
}

@end
