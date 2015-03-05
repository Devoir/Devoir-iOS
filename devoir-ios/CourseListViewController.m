//
//  CourseListViewController.m
//  devoir-ios
//
//  Created by Candice Davis on 3/1/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "CourseListViewController.h"
#import "CourseTableViewCell.h"
#import "DBAccess.h"
#import "UIColor+DevoirColors.h"

@interface CourseListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) DBAccess *database;
@property (strong, nonatomic) NSArray *courses;

@end

@implementation CourseListViewController

- (void) viewDidLoad {
    self.database = [[DBAccess alloc] init];
    self.courses = [self.database getAllCoursesOrderedByName];
}

#pragma mark - tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Course *course = [self.courses objectAtIndex:indexPath.row];
    
    cell.textLabel.text = course.name;
    cell.backgroundColor = [UIColor dbColor:course.color];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}



@end