//
//  UserServerAccess.h
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserServerAccessDelegate <NSObject>

- (void)didLogin:(NSNumber*)success;
- (void)connectionDidFail:(NSError *)error;

@end

@interface UserServerAccess : NSObject

@property (assign, nonatomic) id <UserServerAccessDelegate> delegate;

- (void)loginWithEmail:(NSString*)email;

@end
