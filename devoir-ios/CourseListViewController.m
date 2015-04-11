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
#import "SettingsViewController.h"
#import "ServerAccess.h"

@interface CourseListViewController () <UITableViewDataSource, UITableViewDelegate, AddCourseDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DBAccess *database;
@property (strong, nonatomic)  UIButton *settingsButton;
@property (strong, nonatomic) NSArray *courses;
@property (strong, nonatomic) NSMutableArray *usedColors;
@property (retain, nonatomic) ServerAccess *server;

@end

@implementation CourseListViewController

- (void)viewDidLoad {
    [self setupNavBar];
    [self setupTableView];
    [self setupSettingsButton];
    
    self.server = [[ServerAccess alloc] init];
    self.database = [[DBAccess alloc] init];
    self.courses = [self.database getAllCoursesOrderedByName];
    
    [self buildUsedColors];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBarTintColor:[UIColor devMainColor]];
}

#pragma mark - UI setup

- (void)setupNavBar {
    [self.navigationController.navigationBar setBarTintColor:[UIColor devMainColor]];

    UIBarButtonItem *addCourseButton = [[UIBarButtonItem alloc]
                                        initWithImage:[UIImage imageNamed:@"plus.png"] style:UIStatusBarStyleDefault
                                        target:self
                                        action:@selector(addCourseButtonPressed:)];
    self.navigationItem.rightBarButtonItem = addCourseButton;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"FILTER";
}

- (void)setupTableView {
    int navBarHeight = self.navigationController.navigationBar.frame.size.height
                        + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width,
                                      self.view.frame.size.height - navBarHeight - 70) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
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
    settingsLabel.backgroundColor = [UIColor devMainColor];
    settingsLabel.text = @"SETTINGS";
    settingsLabel.textAlignment = NSTextAlignmentCenter;
    settingsLabel.textColor = [UIColor whiteColor];
    [settingsButton addTarget:self
                          action:@selector(settingsButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    [settingsButton addSubview:settingsLabel];
    [self.view addSubview:settingsButton];
}

- (void)buildUsedColors {
    self.usedColors = [[NSMutableArray alloc] init];
    for(Course *course in self.courses)
    {
        [self.usedColors addObject:[NSNumber numberWithInt:course.color]];
    }
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
        cell.courseLabel.text = @"Show All Courses";
        cell.courseLabel.backgroundColor = [UIColor devAccentColor];
        cell.courseLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        Course *course = [self.courses objectAtIndex:(indexPath.row -1)];

        [cell setupCellWithWidth:tableView.frame.size.width Height:tableView.frame.size.height ForRow:(int)indexPath.row];
        
        cell.courseLabel.text = course.name;
        cell.courseLabel.backgroundColor = [UIColor dbColor:course.color];
        cell.courseLabel.textColor = [UIColor whiteColor];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return NO;
    else
        return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *editButton =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                       title:@"Edit"
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        Course *course = [self.courses objectAtIndex:indexPath.row - 1];
                                        AddCourseViewController *toViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCourseViewController"];
                                        toViewController.course = course;
                                        toViewController.usedColors = self.usedColors;
                                        toViewController.delegate = self;
                                        [self.navigationController pushViewController:toViewController animated:YES];
                                    }];
    editButton.backgroundColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1];
    
    UITableViewRowAction *deleteButton =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                       title:@"Delete"
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         Course *course = [self.courses objectAtIndex:indexPath.row - 1];
                                         [self didDeleteCourse:course];
                                     }];
    deleteButton.backgroundColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1];
    
    return @[editButton, deleteButton];
}

#pragma mark - Button pressed actions

- (void)addCourseButtonPressed:(id)sender {
    AddCourseViewController *toViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCourseViewController"];
    toViewController.course = nil;
    toViewController.usedColors = self.usedColors;
    toViewController.delegate = self;
    [self.navigationController pushViewController:toViewController animated:YES];
}

- (void)settingsButtonPressed:(id)sender {
    SettingsViewController *toViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:toViewController animated:YES];
}

#pragma mark - AddCourseDelegate methods

- (void) didAddCourse:(Course *)course {
    User *user = [self.database getUser];
    course.userID = user.ID;
    course.visible = YES;
    
    [self.server addCourse:course];

    [self.database addCourse:course];
    self.courses = [self.database getAllCoursesOrderedByName];
    [self buildUsedColors];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didEditCourse:(Course *)course {
    [self buildUsedColors];
    [self.database updateCourse:course];
    self.courses = [self.database getAllCoursesOrderedByName];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didDeleteCourse:(Course*)course {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"Delete Course"
                               message:@"Are you sure you want to permanently delete this course?"
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Delete", nil];
    alert.tag = [self.courses indexOfObject:course];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1)
    {
        Course *course = [self.courses objectAtIndex:alertView.tag];
        [self.database removeCourseByID:course.ID];
        self.courses = [self.database getAllCoursesOrderedByName];
        [self buildUsedColors];
        [self.tableView reloadData];
        
        if(self.navigationController.topViewController.class == NSClassFromString(@"AddCourseViewController"))
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void) didCancelCourse {
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end