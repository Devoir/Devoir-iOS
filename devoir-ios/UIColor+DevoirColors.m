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
    return [UIColor colorWithRed:0.184 green:0.773 blue:0.659 alpha:1]; /*#2fc5a8*/
}

+(UIColor*) devRed {
    return [UIColor colorWithRed:0.796 green:0.176 blue:0.176 alpha:1]; /*#cb2d2d*/
}

+(UIColor*) devYellow {
    return [UIColor colorWithRed:0.953 green:0.733 blue:0.094 alpha:1]; /*#f3bb18*/
}

+(UIColor*) devOrange {
    return [UIColor colorWithRed:0.969 green:0.486 blue:0.212 alpha:1]; /*#f77c36*/
}

+(UIColor*) devLightGreen {
    return [UIColor colorWithRed:0.565 green:0.753 blue:0.224 alpha:1]; /*#90c039*/
}

+(UIColor*) devDarkGreen {
    return [UIColor colorWithRed:0.176 green:0.608 blue:0.349 alpha:1]; /*#2d9b59*/
}

+(UIColor*) devPurple {
    return [UIColor colorWithRed:0.557 green:0.102 blue:0.427 alpha:1]; /*#8e1a6d*/
}

+(UIColor*) devBlue {
    return [UIColor colorWithRed:0.298 green:0.529 blue:0.882 alpha:1]; /*#4c87e1*/
}

+(UIColor*) devLightGrey {
    return [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1]; /*#e5e5e5*/
}

+(UIColor*) devDarkGrey {
    return [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.0];
}

+(UIColor*) devMainColor {
    switch ([VariableStore sharedInstance].themeColor)
    {
        case LIGHT:
            return [UIColor colorWithRed:0.255 green:0.275 blue:0.337 alpha:1]; /*#414656*/
        case DARK:
            return [UIColor colorWithRed:0.255 green:0.275 blue:0.337 alpha:1]; /*#414656*/
        default:
            return [UIColor colorWithRed:0.255 green:0.275 blue:0.337 alpha:1]; /*#414656*/
            
//        case LIGHT:
//            return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
//        case DARK:
//            return [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1];
//        default:
//            return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    }
}

+(UIColor*) devAccentColor {
    //return [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1];
    switch ([VariableStore sharedInstance].themeColor)
    {
        case LIGHT:
            return [UIColor colorWithRed:0.392 green:0.443 blue:0.553 alpha:1]; /*#64718d*/
        case DARK:
            return [UIColor colorWithRed:0.392 green:0.443 blue:0.553 alpha:1]; /*#64718d*/
        default:
            return [UIColor colorWithRed:0.392 green:0.443 blue:0.553 alpha:1]; /*#64718d*/
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
            return [UIColor whiteColor];
        case DARK:
            return [UIColor whiteColor];
        default:
            return [UIColor whiteColor];
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
