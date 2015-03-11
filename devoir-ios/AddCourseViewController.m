//
//  AddCourseViewController.m
//  devoir-ios
//
//  Created by Candice Davis on 3/1/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AddCourseViewController.h"
#import "UIColor+DevoirColors.h"

@interface AddCourseViewController()

@end

@implementation AddCourseViewController

- (void)viewDidLoad {
    if(self.course)
    {
        self.url.text = self.course.iCalFeed;
        self.name.text = self.course.name;
        self.color.backgroundColor = [UIColor dbColor:self.course.color];
        
    }
}
@end