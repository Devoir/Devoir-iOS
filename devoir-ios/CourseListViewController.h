//
//  CourseListViewController.h
//  devoir-ios
//
//  Created by Candice Davis on 3/1/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseListDelegate <NSObject>

- (void)courseDidChange:(NSNumber*)courseID;

@end

@interface CourseListViewController : UIViewController

@property (assign, nonatomic) id <CourseListDelegate> delegate;

@end
