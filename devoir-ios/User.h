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
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* oAuthToken;
@property int userID;

-(id) initWithName:(NSString*)name Email:(NSString*)email OAuthToken:(NSString*)oAuthToken UserID:(int)userID;

@end
