//
//  UIColor+DevoirColors.m
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "UIColor+DevoirColors.h"
#import "VariableStore.h"

@implementation UIColor (DevoirColors)

+(UIColor*) devTurquoise {
    return [UIColor colorWithRed:0.4564 green:0.7682 blue:0.7236 alpha:1.0];
}

+(UIColor*) devRed {
    return [UIColor colorWithRed:0.8385 green:0.3913 blue:0.3942 alpha:1.0];
}

+(UIColor*) devYellow {
    return [UIColor colorWithRed:0.9837 green:0.8599 blue:0.4653 alpha:1.0];
}

+(UIColor*) devOrange {
    return [UIColor colorWithRed:1.0 green:0.5348 blue:0.3022 alpha:1.0];
}

+(UIColor*) devLightGreen {
    return [UIColor colorWithRed:0.7006 green:0.8635 blue:0.4263 alpha:1.0];
}

+(UIColor*) devDarkGreen {
    return [UIColor colorWithRed:0.0733 green:0.657 blue:0.4796 alpha:1.0];
}

+(UIColor*) devPurple {
    return [UIColor colorWithRed:0.5615 green:0.4904 blue:0.6997 alpha:1.0];
}

+(UIColor*) devBlue {
    return [UIColor colorWithRed:0.3229 green:0.6045 blue:0.8807 alpha:1.0];
}

+(UIColor*) devLightGrey {
    return [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

+(UIColor*) devDarkGrey {
    return [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.0];
}

+(UIColor*) devMainColor {
    //return [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1];
    switch ([VariableStore sharedInstance].themeColor)
    {
        case LIGHT:
            return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        case DARK:
            return [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1];
        default:
            return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    }
}

+(UIColor*) devAccentColor {
    //return [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1];
    switch ([VariableStore sharedInstance].themeColor)
    {
        case LIGHT:
            return [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
        case DARK:
            return [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1];
        default:
            return [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    }
}

+(UIColor*) devMainTextColor {
    // return [UIColor whiteColor];
    switch ([VariableStore sharedInstance].themeColor)
    {
        case LIGHT:
            return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
        case DARK:
            return [UIColor whiteColor];
        default:
            return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    }
}

+(UIColor*) devAccentTextColor {
    // return [UIColor lightTextColor];
    switch ([VariableStore sharedInstance].themeColor)
    {
        case LIGHT:
            return [UIColor darkGrayColor];
        case DARK:
            return [UIColor lightTextColor];
        default:
            return [UIColor darkGrayColor];
    }
}

+(UIColor*) dbColor:(DevColor)color {
    switch (color)
    {
        case TURQOISE:
            return [UIColor devTurquoise];
        case RED:
            return [UIColor devRed];
        case DARKGREEN:
            return [UIColor devDarkGreen];
        case YELLOW:
            return [UIColor devYellow];
        case ORANGE:
            return [UIColor devOrange];
        case LIGHTGREEN:
            return [UIColor devLightGreen];
        case PURPLE:
            return [UIColor devPurple];
        case BLUE:
            return [UIColor devBlue];
        default:
            return [UIColor devTurquoise];
    }
}

@end
