//
//  ServerAccess.h
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerAccess : NSObject

- (void)loginUserWithEmail:(NSString *)email Sender:(NSObject*)sender;

- (void)addCoursesFromServer;
- (void)addAssignmentsFromServer;

@end
