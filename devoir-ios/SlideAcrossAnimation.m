//
//  SlideAcrossAnimation.m
//  devoir-ios
//
//  Created by Brent on 3/7/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "SlideAcrossAnimation.h"

@implementation SlideAcrossAnimation


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.35f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if(self.presenter)
    {
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        
        startFrame.origin.x += CGRectGetWidth([[transitionContext containerView] bounds]);
        
        toViewController.view.frame = startFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
    }
    else
    {
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        
        startFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
        
        toViewController.view.frame = startFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end