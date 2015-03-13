//
//  SettingsViewController.m
//  devoir-ios
//
//  Created by Brent on 3/8/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "SettingsViewController.h"
#import "VariableStore.h"
#import "DBAccess.h"

@implementation SettingsViewController

- (IBAction)toggleColorTheme:(id)sender {
    DBAccess *database = [[DBAccess alloc] init];
    User *user = [database getUser];
    
    if([VariableStore sharedInstance].themeColor == LIGHT)
    {
        //[VariableStore sharedInstance].themeColor = DARK;
        user.themeColor = DARK;
        
    }
    else
    {
        //[VariableStore sharedInstance].themeColor = LIGHT;
        user.themeColor = LIGHT;
    }
    
    [database updateUser:user];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end