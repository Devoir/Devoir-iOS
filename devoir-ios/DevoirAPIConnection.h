//
//  DevoirAPIConnection.h
//  devoir-ios
//
//  Created by Brent on 4/1/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableStore.h"

@interface DevoirAPIConnection : NSURLConnection

@property DevoirAPIEndpoint endpoint;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate endpoint:(DevoirAPIEndpoint)endpoint;

@end
