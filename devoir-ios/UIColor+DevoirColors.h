//
//  UIColor+DevoirColors.h
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TURQOISE, RED, YELLOW, ORANGE, LIGHTGREEN, DARKGREEN, PURPLE, BLUE
    
} DevColor;

@interface UIColor (DevoirColors)

+(UIColor*) devTurquoise;
+(UIColor*) devRed;
+(UIColor*) devYellow;
+(UIColor*) devOrange;
+(UIColor*) devLightGreen;
+(UIColor*) devDarkGreen;
+(UIColor*) devBlue;
+(UIColor*) devPurple;
+(UIColor*) devTransparent;
+(UIColor*) devGrey;

+(UIColor*) dbColor:(DevColor)color;

@end
