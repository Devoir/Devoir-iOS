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
#import "AddAssignmentViewController.h"
#import "UIColor+DevoirColors.h"
#import "CourseListViewController.h"

@interface AssignmentListViewController () <UITableViewDataSource, UITableViewDelegate,
                                                CourseListDelegate, AddAssignmentDelegate>
@property (strong, nonatomic) DBAccess *database;
@property (strong, nonatomic) NSMutableArray *assignments;
@property (retain) NSNumber *courseToShow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AssignmentListViewController

- (void) viewDidLoad {
    

    [self setupNavBar];
    [self setupTableView];
    
    self.database = [[DBAccess alloc] init];
    self.assignments = [self.database getAllAssignmentsOrderedByDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateStatusBar];
}

#pragma mark - UI setup

- (void)setupNavBar {
    self.navigationItem.title = @"DEVOIR";
    [self.navigationController.navigationBar setBarTintColor:[UIColor devMainColor]];
}

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.courseToShow = [[NSNumber alloc] initWithInt:-1];
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
    
    NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:assignment.dueDate];
    NSDate *today = [self dateAtBeginningOfDayForDate:[NSDate date]];
    
    if(assignment.complete)
    {
        sectionTitle = @"Complete";
    }
    else if([today compare:dateRepresentingThisDay] == NSOrderedDescending)
    {
        sectionTitle = @"Overdue";
    }
    else if([today compare:dateRepresentingThisDay] == NSOrderedSame)
    {
        sectionTitle = @"Due Today";
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
    
    cell.backgroundColor = [UIColor whiteColor];
    
    Assignment *assignment = [[self.assignments objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:assignment.dueDate];
    NSDate *today = [self dateAtBeginningOfDayForDate:[NSDate date]];
    
    if([today compare:dateRepresentingThisDay] == NSOrderedDescending && !assignment.complete)
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
    
    if(assignment.complete)
    {
        cell.checkbox.backgroundColor = [UIColor devAccentColor];
    }
    else
    {
        cell.checkbox.backgroundColor = [UIColor whiteColor];
    }
    
    cell.checkbox.layer.cornerRadius = cell.checkbox.bounds.size.width / 2.0;
    [[cell.checkbox layer] setBorderWidth:1.0f];
    [[cell.checkbox layer] setBorderColor: [UIColor devAccentColor].CGColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteButton = [UITableViewRowAction
                                          rowActionWithStyle:UITableViewRowActionStyleDefault
                                          title:@"Delete"
                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        Assignment *assignment = [[self.assignments objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.database removeAssignmentByID:assignment.ID];
                                              
        [self.tableView beginUpdates];
        [self removeAssignmentAtIndex:indexPath WithAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    }];
    
    deleteButton.backgroundColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1];
    
    return @[deleteButton];
}

- (IBAction)checkboxSelected:(id)sender {
    UIButton* button = (UIButton*) sender;
    UITableViewCell *cell = (UITableViewCell*)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Assignment *assignment = [[self.assignments objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [self.tableView beginUpdates];
    
    UITableViewRowAnimation animation = UITableViewRowAnimationLeft;
    
    //update assignment in database
    if(assignment.complete == NO)
    {
        assignment.complete = YES;
        button.backgroundColor = [UIColor devMainColor];
    }
    else
    {
        assignment.complete = NO;
        button.backgroundColor = [UIColor whiteColor];
    }
    [self.database markAsComplete:assignment];
    
    //Remove assignment from current position
    [self removeAssignmentAtIndex:indexPath WithAnimation:animation];
    
    //add assignment to new position
    [self insertAssignment:assignment WithAnimation:animation];
    
    [self.tableView endUpdates];
}

- (void)removeAssignmentAtIndex:(NSIndexPath*)indexPath WithAnimation:(UITableViewRowAnimation)animation {
    //Remove assignment from current position
    [[self.assignments objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
    
    if([[self.assignments objectAtIndex:indexPath.section] count] == 0)
    {
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [self.tableView deleteSections:set withRowAnimation:animation];
    }
    
    //update list of assignments
    if([self.courseToShow integerValue] != -1)
    {
        self.assignments = [self.database getAllAssignmentsOrderedByDateForCourse:(int)[self.courseToShow integerValue]];
    }
    else
    {
        self.assignments = [self.database getAllAssignmentsOrderedByDate];
    }
}

- (void)insertAssignment:(Assignment*)assignment WithAnimation:(UITableViewRowAnimation)animation {
    int row = 0;
    int section = 0;
    BOOL done = NO;
    for(NSMutableArray *sec in self.assignments)
    {
        for(Assignment *cmp in sec)
        {
            if([cmp.name isEqual:assignment.name])
            {
                if([sec count] == 1)
                {
                    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:section];
                    [self.tableView insertSections:set withRowAnimation:animation];
                    return;
                }
                done = YES;
                break;
            }
            row++;
        }
        if(done)
            break;
        row = 0;
        section++;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CourseListViewController *transferViewController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"courseList"]) {
        [transferViewController setDelegate:self];        
    }
    if ([segue.identifier isEqualToString:@"toAddAssignment"]) {
        [transferViewController setDelegate:self];
    }
    if ([segue.identifier isEqualToString:@"toEditAssignment"]) {
        AddAssignmentViewController *vc = (AddAssignmentViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Assignment *assignment = [[self.assignments objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        vc.assignment = assignment;
        [transferViewController setDelegate:self];  
    }
}

#pragma mark - CourseListDelegate methods

- (void) courseDidChange:(NSNumber*)courseID {
    self.courseToShow = courseID;
    
    if([self.courseToShow integerValue] != -1)
    {
        self.assignments = [self.database getAllAssignmentsOrderedByDateForCourse:(int)[self.courseToShow integerValue]];
        [self.tableView reloadData];
    }
    else
    {
        self.assignments = [self.database getAllAssignmentsOrderedByDate];
        [self.tableView reloadData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AddAssignmentDelegate Methods

- (void) didEditAssignment:(Assignment *)assignment {
    [self.database updateAssignment:assignment];
    self.assignments = [self.database getAllAssignmentsOrderedByDate];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didAddAssignment:(Assignment *)assignment {
    [self.database addAssignment:assignment];
    self.assignments = [self.database getAllAssignmentsOrderedByDate];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didCancelAssignment {
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didDeleteAssignment:(Assignment *)assignment {
    [self.database removeAssignmentByID:assignment.ID];
    self.assignments = [self.database getAllAssignmentsOrderedByDate];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateStatusBar {
    if([self.courseToShow integerValue] == -1)
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor devMainColor]];
        self.navigationItem.title = @"DEVOIR";
    }
    else
    {
        Course *course = [self.database getCourseByID:(int)[self.courseToShow integerValue]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor dbColor:course.color]];
        self.navigationItem.title = @"DEVOIR";
    }
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

@end
