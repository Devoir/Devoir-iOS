//
//  CourseServerAccess.h
//  devoir-ios
//
//  Created by Brent on 3/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"

@interface CourseServerAccess : NSObject

- (void)getCourses;
-(void)addCourse:(Course*)course;

@end
