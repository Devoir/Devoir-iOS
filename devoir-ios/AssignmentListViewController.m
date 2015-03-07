//
//  AssignmentListViewController.m
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AssignmentListViewController.h"
#import "DBAccess.h"
#import "AssignmentTableViewCell.h"
#import "AssignmentListSectionHeader.h"
#import "UIColor+DevoirColors.h"
#import "CourseListViewController.h"
#import "DropDownAnimator.h"

@interface AssignmentListViewController () <UITableViewDataSource, UITableViewDelegate,
                                                CourseListDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) DBAccess *database;
@property (strong, nonatomic) NSArray *assignments;
@property (retain) NSNumber *courseToShow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)checkboxHit:(id)sender;
@end

@implementation AssignmentListViewController

- (void) viewDidLoad {

    [self setupNavBar];
    [self setupTableView];
    
    self.database = [[DBAccess alloc] init];
    self.assignments = [self.database getAllAssignmentsOrderedByDate];
}

#pragma mark - UI setup

- (void)setupNavBar {
    self.navigationItem.title = @"All Courses";
    [self.navigationController.navigationBar setBarTintColor:[UIColor devDarkGrey]];
    self.navigationController.navigationBar.backgroundColor = [UIColor devDarkGrey];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.delegate = self;
}

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor devTintColor];
    self.courseToShow = [[NSNumber alloc] initWithInt:-1];
}

#pragma mark - CourseListDelegate methods

- (void) courseDidChange:(NSNumber*)courseID {
    self.courseToShow = courseID;
    if([self.courseToShow integerValue] != -1)
    {
        self.navigationItem.title = [self.database getCourseByID:(int)[self.courseToShow integerValue]].name;
        self.assignments = [self.database getAllAssignmentsOrderedByDateForCourse:(int)[self.courseToShow integerValue]];
        [self.tableView reloadData];
    }
    else
    {
        self.navigationItem.title = @"All Courses";
        self.assignments = [self.database getAllAssignmentsOrderedByDate];
        [self.tableView reloadData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.assignments count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *eventsOnThisDay = [self.assignments objectAtIndex:section];
    return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"I dont know why but this needs to be here";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    Assignment *assignment = [[self.assignments objectAtIndex:section] objectAtIndex:0];
    
    NSDate *dateRepresentingThisDay = assignment.dueDate;
    NSDate *today = [NSDate date];
    
    if([today earlierDate:dateRepresentingThisDay] == dateRepresentingThisDay)
    {
        sectionTitle = @"Overdue";
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE, MMM d, yyyy"];
        sectionTitle = [formatter stringFromDate:dateRepresentingThisDay];
    }
    
    return [[AssignmentListSectionHeader alloc]
            initWithWidth:tableView.frame.size.width
            Height:tableView.frame.size.height
            Section:(int)section
            Title:sectionTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    AssignmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Assignment *assignment = [[self.assignments objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSDate *dateRepresentingThisDay = assignment.dueDate;
    NSDate *today = [NSDate date];
    
    if([today earlierDate:dateRepresentingThisDay] == dateRepresentingThisDay)
    {
        [cell setupCellWithWidth:tableView.frame.size.width Height:64 Overdue:YES];
    }
    else
    {
        [cell setupCellWithWidth:tableView.frame.size.width Height:64 Overdue:NO];
    }
    
    cell.assignmentLabel.text = assignment.name;
    
    Course *course = [self.database getCourseByID:assignment.courseID];
    cell.courseLabel.text = course.name;
    
    cell.overdueDate.text = [assignment dueDateAsString];
    
    [[cell.colorLabel layer] setBackgroundColor: [UIColor dbColor:course.color].CGColor];
        
    cell.checkbox.layer.cornerRadius = cell.checkbox.bounds.size.width / 2.0;
    [[cell.checkbox layer] setBorderWidth:1.0f];
    [[cell.checkbox layer] setBorderColor: [UIColor lightGrayColor].CGColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (IBAction)checkboxHit:(id)sender {


}

#pragma mark - Segue/Animations

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    CourseListViewController *transferViewController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"courseList"])
    {
        [transferViewController setDelegate:self];        
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if(fromVC.class == self.class)
    {
        DropDownAnimator *animator = [DropDownAnimator new];
        return animator;
    }
    else
    {
        return nil;   
    }
}

@end
