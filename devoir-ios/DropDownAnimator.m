//
//  DropDownAnimator.m
//  devoir-ios
//
//  Created by Brent on 3/7/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "DropDownAnimator.h"

@implementation DropDownAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Set our ending frame. We'll modify this later if we have to
    //CGRect endFrame = CGRectMake(0, 0, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];
        
    CGRect startFrame = endFrame;
        
    startFrame.origin.y -= CGRectGetHeight([[transitionContext containerView] bounds]);
        
    toViewController.view.frame = startFrame;
        
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.frame = endFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
