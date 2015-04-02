//
//  DevoirAPIConnection.m
//  devoir-ios
//
//  Created by Brent on 4/1/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "DevoirAPIConnection.h"

@implementation DevoirAPIConnection

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate endpoint:(DevoirAPIEndpoint)endpoint
{
    if(self = [super initWithRequest:request delegate:delegate])
    {
        self.endpoint = endpoint;
    }
    return self;
}

@end
