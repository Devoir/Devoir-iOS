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
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"Filter";
}

- (void)setupTableView {
    int navBarHeight = self.navigationController.navigationBar.frame.size.height
                        + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.tableView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width,
                                      self.view.frame.size.height - navBarHeight - 70);
    
    self.tableView.backgroundColor = [UIColor devTintColor];
}

- (void)setupSettingsButton {
    self.settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 70)];
    UILabel *settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    settingsLabel.backgroundColor = [UIColor devSettingsBar];
    settingsLabel.text = @"Settings";
    settingsLabel.textAlignment = NSTextAlignmentCenter;
    settingsLabel.textColor = [UIColor whiteColor];
    [self.settingsButton addTarget:self
                          action:@selector(settingsButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton addSubview:settingsLabel];
    [self.view addSubview:self.settingsButton];
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
    NSLog(@"PLEASE EDIT COURSE: %d", course.ID);
}

- (void)deleteButtonPressed:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    Course *course = [self.courses objectAtIndex:senderButton.tag];
    NSLog(@"PLEASE DELETE COURSE: %d", course.ID);
}

@end