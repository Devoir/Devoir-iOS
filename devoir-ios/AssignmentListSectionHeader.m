//
//  AssignmentListSectionHeader.m
//  devoir-ios
//
//  Created by Brent on 3/6/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AssignmentListSectionHeader.h"
#import "UIColor+DevoirColors.h"

@implementation AssignmentListSectionHeader

- (id)initWithWidth:(int)width Height:(int)height Section:(int)section Title:(NSString*)title {
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, 45, 18);
        self.backgroundColor = [UIColor devAccentColor];
        
        UILabel *tempLabel;
        if(section == 0) {
            tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 33, width, 18)];
        }
        else {
            tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, width, 18)];
        }
        tempLabel.backgroundColor = [UIColor devAccentColor];
        tempLabel.textColor = [UIColor whiteColor];
        
        tempLabel.text = title;
        tempLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        tempLabel.textColor = [UIColor devMainTextColor];
        
        [self addSubview:tempLabel];
    }
    return self;
}

@end
