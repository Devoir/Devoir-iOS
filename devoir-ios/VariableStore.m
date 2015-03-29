//
//  VariableStore.m
//  devoir-ios
//
//  Created by Brent on 3/8/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "VariableStore.h"

@implementation VariableStore

- (id)init {
    if ((self = [super init]))
    {
        self.themeColor = LIGHT;
        self.dbPath = @"devoir-ios.sqlite";
        self.googleOAtuhClientID = @"668127864316-nsluq6k5g95ln93kmoe7cjg4ot482lth.apps.googleusercontent.com";
        self.serverBaseURL = @"http://localhost:3000";
    }
    return self;
}

+ (VariableStore *)sharedInstance {
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