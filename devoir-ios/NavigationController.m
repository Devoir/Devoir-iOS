//
//  NavigationController.m
//  devoir-ios
//
//  Created by Brent on 3/12/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "NavigationController.h"
#include "DropDownAnimator.h"
#include "SlideAcrossAnimation.h"

@interface NavigationController() <UINavigationControllerDelegate>

@end

@implementation NavigationController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - ANIMATIONS: !!!!!THIS SECTION SHOULD GO IN THE NAVIGATION CONTROLLER ROOT VIEW!!!!!

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if(fromVC.class == NSClassFromString(@"AssignmentListViewController")
       && toVC.class == NSClassFromString(@"CourseListViewController"))
    {
        DropDownAnimator *animator = [DropDownAnimator new];
        animator.presenter = 1;
        return animator;
    }
    else if(toVC.class == NSClassFromString(@"AssignmentListViewController")
            && fromVC.class == NSClassFromString(@"CourseListViewController"))
    {
        DropDownAnimator *animator = [DropDownAnimator new];
        animator.presenter = 0;
        return animator;
    }
    else if (toVC.class == NSClassFromString(@"CourseListViewController"))
    {
        SlideAcrossAnimation *animator = [SlideAcrossAnimation new];
        animator.presenter = 0;
        return animator;
    }
    else
    {
        return nil;
    }
}

@end
