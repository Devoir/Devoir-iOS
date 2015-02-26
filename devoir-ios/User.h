//
//  UserModel.h
//  ios-devoir
//
//  Created by Brent on 1/20/15.
//  Copyright (c) 2015 Brent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//required
@property int ID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* oAuthToken;

-(id) initWithID:(int)ID Name:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken;

@end
