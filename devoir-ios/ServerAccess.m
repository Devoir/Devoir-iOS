//
//  ServerAccess.m
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "ServerAccess.h"
#import "UserServerAccess.h"
#import "CourseServerAccess.h"
#import "AssignmentServerAccess.h"

@interface ServerAccess()
@property (retain, nonatomic) UserServerAccess *userServerAccess;
@property (retain, nonatomic) CourseServerAccess *courseServerAccess;
@property (retain, nonatomic) AssignmentServerAccess *assignmentServerAccess;
@end

@implementation ServerAccess

- (id)init {
    self = [super init];
    
    if(self){
        self.userServerAccess = [[UserServerAccess alloc] init];
        self.courseServerAccess = [[CourseServerAccess alloc] init];
        self.assignmentServerAccess = [[AssignmentServerAccess alloc] init];
    }
    
    return self;
}

- (void)loginUserWithEmail:(NSString *)email Sender:(id)sender {
    self.userServerAccess.delegate = sender;
    return [self.userServerAccess loginWithEmail:email];
}

- (void)addCoursesFromServer {
    return [self.courseServerAccess addCoursesFromServer];
}

- (void)addAssignmentsFromServer {
    return [self.assignmentServerAccess addAssignmentsFromServer];
}

@end
