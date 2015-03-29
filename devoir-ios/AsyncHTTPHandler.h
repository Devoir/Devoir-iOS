//
//  AsyncPost.h
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AsyncHTTPHandlerDelegate <NSObject>

- (void)didRecieveResponse:(NSString*)responseBody FromRequest:(NSURLRequest*)request;
- (void)connectionDidFail:(NSError*)error;

@end

@interface AsyncHTTPHandler : NSObject

@property (assign, nonatomic) id <AsyncHTTPHandlerDelegate> delegate;

- (void)synchronusGetURL:(NSString*)url;

- (void)sendPostURL:(NSString*)url Body:(NSString*)body;
- (void)sendGetURL:(NSString*)url;

@end
