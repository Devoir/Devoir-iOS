//
//  AsyncPost.h
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableStore.h"

@protocol AsyncHTTPHandlerDelegate <NSObject>

- (void)didRecieveResponse:(NSString*)responseBody FromEndpoint:(NSNumber *)endpoint;
- (void)connectionDidFail:(NSError*)error;

@end

@interface AsyncHTTPHandler : NSObject

@property (assign, nonatomic) id <AsyncHTTPHandlerDelegate> delegate;

- (void)synchronusGetURL:(NSString*)url Endpoint:(DevoirAPIEndpoint)endpoint;

- (void)sendPostURL:(NSString*)url Body:(NSString*)body Endpoint:(DevoirAPIEndpoint)endpoint;
- (void)sendGetURL:(NSString*)url Endpoint:(DevoirAPIEndpoint)endpoint;

@end
