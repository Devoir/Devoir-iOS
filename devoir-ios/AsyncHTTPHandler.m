//
//  AsyncPost.m
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AsyncHTTPHandler.h"
#import "DevoirAPIConnection.h"

@interface AsyncHTTPHandler() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property NSMutableData *httpResponse;
@end

@implementation AsyncHTTPHandler

- (id)init {
    self = [super init];
    
    if(self){
        self.httpResponse = [[NSMutableData alloc] init];
    }
    
    return self;
}

// Sends an synchronous HTTP GET request
- (void)synchronusGetURL:(NSString*)url Endpoint:(DevoirAPIEndpoint)endpoint {
    
    NSMutableString* requestURL = [[NSMutableString alloc] init];
    [requestURL appendString:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithString:requestURL]]];
    
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [DevoirAPIConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error)
    {
        [self.delegate performSelector:@selector(connectionDidFail:) withObject:error];
    }
    else
    {
        NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] copy];
    
        [self.delegate performSelector:@selector(didRecieveResponse:FromEndpoint:) withObject:responseString
                        withObject:[NSNumber numberWithInt:endpoint]];
    }
}

// Sends an asynchronous HTTP POST request
- (void)sendPostURL:(NSString*)url Body:(NSString*)body Endpoint:(DevoirAPIEndpoint)endpoint {
    
    NSMutableString* requestURL = [[NSMutableString alloc] init];
    [requestURL appendString:url];
    
    NSMutableString* requestBody = [[NSMutableString alloc] init];
    [requestBody appendString:body];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithString:requestURL]]];
    
    NSString* requestBodyString = [NSString stringWithString:requestBody];
    NSData *requestData = [NSData dataWithBytes: [requestBodyString UTF8String] length: [requestBodyString length]];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    
    [[DevoirAPIConnection alloc] initWithRequest:request delegate:self endpoint:endpoint];
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// Sends an asynchronous HTTP GET request
- (void)sendGetURL:(NSString*)url Endpoint:(DevoirAPIEndpoint)endpoint {
    
    NSMutableString* requestURL = [[NSMutableString alloc] init];
    [requestURL appendString:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithString:requestURL]]];
    
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    [[DevoirAPIConnection alloc] initWithRequest:request delegate:self endpoint:endpoint];
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate performSelector:@selector(connectionDidFail:) withObject:error];
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.httpResponse setLength:0];
}

// Called when data has been received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.httpResponse appendData:data];
}

- (void)connectionDidFinishLoading:(DevoirAPIConnection *)connection {
    NSString* responseString = [[[NSString alloc] initWithData:self.httpResponse encoding:NSUTF8StringEncoding] copy];
    
    [self.delegate performSelector:@selector(didRecieveResponse:FromEndpoint:) withObject:responseString
                        withObject:[NSNumber numberWithInt:connection.endpoint]];
    
}

@end
