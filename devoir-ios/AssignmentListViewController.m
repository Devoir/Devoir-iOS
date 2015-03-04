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
#import "UIColor+DevoirColors.h"

@interface AssignmentListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) DBAccess *database;
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedAssignments;
- (IBAction)checkboxHit:(id)sender;

@end

@implementation AssignmentListViewController

- (void) viewDidLoad {
    self.database = [[DBAccess alloc] init];
    [self sortAssignmentsByDateForCourse:-1];
}

#pragma mark - tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *dateRepresentingThisDay = [self.sortedAssignments objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedAssignments objectAtIndex:section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM d, yyyy"];
    return [formatter stringFromDate:dateRepresentingThisDay];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    AssignmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDate *dateRepresentingThisDay = [self.sortedAssignments objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    Assignment *assignment = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    cell.assignmentLabel.text = assignment.name;
    
    Course *course = [self.database getCourseByID:assignment.courseID];
    cell.courseLabel.text = course.name;
    
    cell.overdueDate.text = [assignment dueDateAsString];
    
    [[cell.colorLabel layer] setBackgroundColor: [UIColor devTurquoise].CGColor];
    [[cell.overdueLabel layer] setBackgroundColor: [UIColor devRed].CGColor];
    
    cell.checkbox.layer.cornerRadius = cell.checkbox.bounds.size.width / 2.0;
    [[cell.checkbox layer] setBorderWidth:1.0f];
    [[cell.checkbox layer] setBorderColor: [UIColor lightGrayColor].CGColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (IBAction)checkboxHit:(id)sender {
    // change color
    // change state
}

#pragma mark - sort assignment by date

- (void)sortAssignmentsByDateForCourse:(int)courseID
{
    NSArray *assignments;
    
    if(courseID == -1)
        assignments = [self.database getAllAssignmentsOrderedByName];
    else
        assignments = [self.database getAllAssignmentsOrderedByNameForCourse:courseID];

    self.sections = [NSMutableDictionary dictionary];
    
    for (Assignment *event in assignments)
    {
        // Reduce event start date to date components (year, month, day)
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.dueDate];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
        }
        
        // Add the event to the list for this day
        [eventsOnThisDay addObject:event];
    }
    
    // Create a sorted list of days
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedAssignments = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
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

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate
{
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}

@end
