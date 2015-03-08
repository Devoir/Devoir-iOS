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
    return 0.45f;
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
        
        int navBarHeight = fromViewController.navigationController.navigationBar.frame.size.height
                        + [UIApplication sharedApplication].statusBarFrame.size.height;
        startFrame.origin.y -= CGRectGetHeight([[transitionContext containerView] bounds]) - navBarHeight;
        
        toViewController.view.frame = startFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        UIView* inView = [transitionContext containerView];
        
        [inView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        CGPoint centerOffScreen = inView.center;
        centerOffScreen.y = (-1)*inView.frame.size.height;
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.center = centerOffScreen;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
