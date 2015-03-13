//
//  UserModel.h
//  ios-devoir
//
//  Created by Brent on 1/20/15.
//  Copyright (c) 2015 Brent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableStore.h"
@interface User : NSObject

//required
@property int ID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* oAuthToken;
@property UIThemeColor themeColor;

-(id) initWithID:(int)ID Name:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken
      ThemeColor:(UIThemeColor)themeColor;

@end