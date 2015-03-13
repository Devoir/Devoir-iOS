//
//  VariableStore.h
//  devoir-ios
//
//  Created by Brent on 3/8/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    LIGHT, DARK
    
} UIThemeColor;

@interface VariableStore : NSObject

// Place any "global" variables here
@property UIThemeColor themeColor;

// message from which our instance is obtained
+ (VariableStore *)sharedInstance;
@end