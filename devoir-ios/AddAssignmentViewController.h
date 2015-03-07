//
//  AddAssignmentViewController.h
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"

@protocol AddAssignmentDelegate <NSObject>

- (void) didEditAssignment:(Assignment *)assignment;
- (void) didAddAssignment:(Assignment *)assignment;
- (void) didCancelAssignment;

@end

@interface AddAssignmentViewController : UIViewController

@property (strong, nonatomic) Assignment *assignment;
@property (assign, nonatomic) id <AddAssignmentDelegate> delegate;

@end
