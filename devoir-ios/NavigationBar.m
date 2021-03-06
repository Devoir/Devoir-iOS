//
//  NavigationBar.m
//  devoir-ios
//
//  Created by Brent on 3/9/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "NavigationBar.h"
#import "DBAccess.h"
#import "VariableStore.h"
#import "UIColor+DevoirColors.h"

@implementation NavigationBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setupNavigationBar];
    }
    return self;
}

- (void)setupNavigationBar {
    [self setBarTintColor:[UIColor devAccentColor]];
    self.translucent = NO;
    self.tintColor = [UIColor devAccentTextColor];
    self.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor devAccentTextColor]};
    if([VariableStore sharedInstance].themeColor == DARK)
        [self setBarStyle:UIBarStyleDefault];
    else
        [self setBarStyle:UIBarStyleDefault];
    
}

@end