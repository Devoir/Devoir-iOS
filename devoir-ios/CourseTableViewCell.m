//
//  CourseTableViewCell.m
//  devoir-ios
//
//  Created by Brent on 3/4/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "CourseTableViewCell.h"
#include "Course.h"

@implementation CourseTableViewCell

- (void)setupCellWithWidth:(int)width Height:(int)height ForRow:(int)row {
    self.courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 70)];
    self.courseLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.courseLabel];
}

@end
