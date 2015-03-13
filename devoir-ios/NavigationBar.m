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
        DBAccess *databse = [[DBAccess alloc] init];
        User *user = [databse getUser];
        [VariableStore sharedInstance].themeColor = user.themeColor;
        [self setupNavigationBar];
    }
    return self;
}

- (void)setupNavigationBar {
    [self setBarTintColor:[UIColor devMainColor]];
    self.backgroundColor = [UIColor devMainColor];
    self.translucent = NO;
    self.tintColor = [UIColor devMainTextColor];
    self.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor devMainTextColor]};
    if([VariableStore sharedInstance].themeColor == DARK)
        [self setBarStyle:UIStatusBarStyleLightContent];
    else
        [self setBarStyle:UIBarStyleDefault];
}

@end