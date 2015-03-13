//
//  VariableStore.m
//  devoir-ios
//
//  Created by Brent on 3/8/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "VariableStore.h"

@implementation VariableStore

+ (VariableStore *)sharedInstance
{
    // the instance of this class is stored here
    static VariableStore *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}

@end