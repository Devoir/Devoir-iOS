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
    if(row == 0)
    {
        self.courseLabel.text = @"Show All Courses";
        self.courseLabel.backgroundColor = [UIColor devTintColor];
        [self.contentView addSubview:self.courseLabel];
    }
    else
    {        
        //parent scroll view
        self.courseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width + 100, 70)];
        self.courseScrollView.contentSize = CGSizeMake(600, 70);
        self.courseScrollView.showsHorizontalScrollIndicator = NO;
        self.courseScrollView.showsVerticalScrollIndicator = NO;
        self.courseScrollView.bounces = YES;
        [self.courseScrollView addSubview:self.courseLabel];
        
        //tansparent button to cover the filter by course section
        self.courseFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 70)];
        self.courseFilterButton.backgroundColor = [UIColor devTransparent];
        self.courseFilterButton.tag = row;
        [self.courseScrollView addSubview:self.courseFilterButton];
        
        //section for edit/delete
        self.courseDeleteEditView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 500, 70)];
        self.courseDeleteEditView.backgroundColor = [UIColor devTintColor];
        
        //button for edit course button
        self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 70)];
        [self.editButton  setImage:[UIImage imageNamed:@"Edit-50.png"] forState: UIControlStateNormal];
        self.editButton.tag = row - 1;
        //self.editButton.backgroundColor = [UIColor devPurple];
        [self.courseDeleteEditView addSubview:self.editButton];
        
        //button for edit course button
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(65, 0, 65, 70)];
        [self.deleteButton  setImage:[UIImage imageNamed:@"Trash-50.png"] forState: UIControlStateNormal];
        self.deleteButton.tag = row -1;
        //self.deleteButton.backgroundColor = [UIColor devBlue];
        [self.courseDeleteEditView addSubview:self.deleteButton];
        
        [self.courseScrollView addSubview:self.courseDeleteEditView];
        
        [self.contentView addSubview:self.courseScrollView];
    }
}

@end
