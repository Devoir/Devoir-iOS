//
//  AssignmentTableViewCell.h
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckboxButton.h"

@interface AssignmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *assignmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UIView *overdueLabel;
@property (weak, nonatomic) IBOutlet CheckboxButton *checkbox;

@end
