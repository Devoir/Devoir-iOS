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
#import "AddCourseViewController.h"

@interface CourseListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DBAccess *database;
@property (strong, nonatomic)  UIButton *settingsButton;
@property (strong, nonatomic) NSArray *courses;
@end

@implementation CourseListViewController

- (void)viewDidLoad {
    [self setupNavBar];
    [self setupTableView];
    [self setupSettingsButton];
    
    self.database = [[DBAccess alloc] init];
    self.courses = [self.database getAllCoursesOrderedByName];
}

#pragma mark - UI setup

- (void)setupNavBar {
    UIBarButtonItem *addCourseButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:@selector(addCourseButtonPressed:)];
    self.navigationItem.rightBarButtonItem = addCourseButton;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"Filter";
}

- (void)setupTableView {
    int navBarHeight = self.navigationController.navigationBar.frame.size.height
                        + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width,
                                      self.view.frame.size.height - navBarHeight - 70) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor devTintColor];
    
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)setupSettingsButton {
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 70)];
    UILabel *settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    settingsLabel.backgroundColor = [UIColor devSettingsBar];
    settingsLabel.text = @"Settings";
    settingsLabel.textAlignment = NSTextAlignmentCenter;
    settingsLabel.textColor = [UIColor whiteColor];
    [settingsButton addTarget:self
                          action:@selector(settingsButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    [settingsButton addSubview:settingsLabel];
    [self.view addSubview:settingsButton];
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
    
    if (cell == nil) {
        cell = [[CourseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
    
    if(indexPath.row == 0)
    {
        [cell setupCellWithWidth:tableView.frame.size.width Height:tableView.frame.size.height ForRow:(int)indexPath.row];
    }
    else
    {
        Course *course = [self.courses objectAtIndex:(indexPath.row -1)];

        [cell setupCellWithWidth:tableView.frame.size.width Height:tableView.frame.size.height ForRow:(int)indexPath.row];
        
        cell.courseScrollView.backgroundColor = [UIColor dbColor:course.color];
        cell.courseLabel.text = course.name;
        
        [cell.courseFilterButton addTarget:self
                                    action:@selector(courseFilterButtonPressed:)
                          forControlEvents:UIControlEventTouchUpInside];
        
        [cell.editButton addTarget:self
                            action:@selector(editButtonPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [cell.deleteButton addTarget:self
                              action:@selector(deleteButtonPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
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

- (void)addCourseButtonPressed:(id)sender {
    AddCourseViewController *toViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addCourseViewController"];
    toViewController.course = nil;
    [self.navigationController pushViewController:toViewController animated:YES];
}

- (void)settingsButtonPressed:(id)sender {
    NSLog(@"SETTINGS");
}

- (void)courseFilterButtonPressed:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    int row = (int)senderButton.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)editButtonPressed:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    Course *course = [self.courses objectAtIndex:senderButton.tag];
    AddCourseViewController *toViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addCourseViewController"];
    [self.navigationController pushViewController:toViewController animated:YES];
    toViewController.course = course;
}

- (void)deleteButtonPressed:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    Course *course = [self.courses objectAtIndex:senderButton.tag];
    NSLog(@"PLEASE DELETE COURSE: %d", course.ID);
}

@end