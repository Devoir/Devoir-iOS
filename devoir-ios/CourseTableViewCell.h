//
//  CourseTableViewCell.h
//  devoir-ios
//
//  Created by Brent on 3/4/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIScrollView *courseScrollView;
@property (strong, nonatomic)  UIView *courseDeleteEditView;
@property (strong, nonatomic)  UILabel *courseLabel;
@property (strong, nonatomic) UIButton *courseFilterButton;
@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) UIButton *deleteButton;
@end
