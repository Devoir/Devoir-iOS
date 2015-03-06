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
#import "AssignmentListViewController.h"

@interface CourseListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DBAccess *database;
@property (strong, nonatomic) NSArray *courses;
@end

@implementation CourseListViewController

- (void)viewDidLoad {
    self.database = [[DBAccess alloc] init];
    self.courses = [self.database getAllCoursesOrderedByName];
}

#pragma mark - tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
    if(indexPath.row == 0)
    {
        cell.courseLabel.text = @"Show All Courses";
        [cell.contentView addSubview:cell.courseLabel];
    }
    else
    {
        Course *course = [self.courses objectAtIndex:(indexPath.row -1)];
        
        //parent scroll view
        cell.courseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width + 100, 70)];
        cell.courseScrollView.contentSize = CGSizeMake(600, 70);
        cell.courseScrollView.showsHorizontalScrollIndicator = NO;
        cell.courseScrollView.showsVerticalScrollIndicator = NO;
        cell.courseScrollView.bounces = NO;
        cell.courseScrollView.backgroundColor = [UIColor dbColor:course.color];
        cell.courseLabel.text = course.name;
        [cell.courseScrollView addSubview:cell.courseLabel];
        
        //tansparent button to cover the filter by course section
        cell.courseFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
        cell.courseFilterButton.backgroundColor = [UIColor devTransparent];
        [cell.courseFilterButton addTarget:self
                       action:@selector(courseFilterButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        cell.courseFilterButton.tag = indexPath.row;
        [cell.courseScrollView addSubview:cell.courseFilterButton];
        
        //section for edit/delete
        cell.courseDeleteEditView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.size.width, 0, 500, 70)];
        cell.courseDeleteEditView.backgroundColor = [UIColor devGrey];
        
        //button for edit course button
        cell.editButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [cell.editButton addTarget:self
                   action:@selector(editButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        cell.editButton.tag = indexPath.row -1;
        cell.editButton.frame = CGRectMake(0, 0, 65, 70);
        cell.editButton.backgroundColor = [UIColor devPurple];
        [cell.courseDeleteEditView addSubview:cell.editButton];
        
        //button for edit course button
        cell.deleteButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [cell.deleteButton addTarget:self
                       action:@selector(deleteButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        cell.deleteButton.tag = indexPath.row -1;
        cell.deleteButton.frame = CGRectMake(65, 0, 65, 70);
        cell.deleteButton.backgroundColor = [UIColor devBlue];
        [cell.courseDeleteEditView addSubview:cell.deleteButton];
        
        [cell.courseScrollView addSubview:cell.courseDeleteEditView];

        [cell.contentView addSubview:cell.courseScrollView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
    {
        NSNumber *ID = [[NSNumber alloc] initWithInt:-1];
        [self.delegate performSelector:@selector(courseDidChange:) withObject:ID];
    }
    else
    {
        Course *course = [self.courses objectAtIndex:(indexPath.row - 1)];
        NSNumber *ID = [[NSNumber alloc] initWithInt:course.ID];
        [self.delegate performSelector:@selector(courseDidChange:) withObject:ID];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - Button pressed actions

- (void)courseFilterButtonPressed:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    int row = (int)senderButton.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)editButtonPressed:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    Course *course = [self.courses objectAtIndex:senderButton.tag];
    NSLog(@"PLEASE EDIT COURSE: %d", course.ID);
}

- (void)deleteButtonPressed:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    Course *course = [self.courses objectAtIndex:senderButton.tag];
    NSLog(@"PLEASE DELETE COURSE: %d", course.ID);
}

@end