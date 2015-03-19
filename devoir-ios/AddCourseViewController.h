//
//  AddCourseViewController.h
//  devoir-ios
//
//  Created by Candice Davis on 3/1/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@protocol AddCourseDelegate <NSObject>

- (void) didAddCourse:(Course *)course;
- (void) didEditCourse:(Course *)course;
- (void) didDeleteCourse:(Course *)course;
- (void) didCancelCourse;

@end

@interface AddCourseViewController : UIViewController

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) NSMutableArray *usedColors;
@property (assign, nonatomic) id <AddCourseDelegate> delegate;

@end