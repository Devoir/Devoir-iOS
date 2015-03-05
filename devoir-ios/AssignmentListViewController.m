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
@property (strong, nonatomic) NSArray *assignments;
- (IBAction)checkboxHit:(id)sender;

@end

@implementation AssignmentListViewController

- (void) viewDidLoad {
    self.database = [[DBAccess alloc] init];
    self.assignments = [self.database getAllAssignmentsOrderedByDate];
    //self.assignments = [self.database getAllAssignmentsOrderedByDateForCourse:1];
}

#pragma mark - tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.assignments count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *eventsOnThisDay = [self.assignments objectAtIndex:section];
    return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Assignment *assignment = [[self.assignments objectAtIndex:section] objectAtIndex:0];
    NSDate *dateRepresentingThisDay = assignment.dueDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM d, yyyy"];
    return [formatter stringFromDate:dateRepresentingThisDay];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    AssignmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Assignment *assignment =[[self.assignments objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
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
    UIButton *btn= (UIButton *)sender;
    int num = arc4random_uniform(8);
    if(num == 0)
        [btn setBackgroundColor:[UIColor devBlue]];
    else if (num == 1)
        [btn setBackgroundColor:[UIColor devDarkGreen]];
    else if (num == 2)
        [btn setBackgroundColor:[UIColor devLightGreen]];
    else if (num == 3)
        [btn setBackgroundColor:[UIColor devOrange]];
    else if (num == 4)
        [btn setBackgroundColor:[UIColor devPurple]];
    else if (num == 5)
        [btn setBackgroundColor:[UIColor devRed]];
    else if (num == 6)
        [btn setBackgroundColor:[UIColor devTurquoise]];
    else if (num == 7)
        [btn setBackgroundColor:[UIColor devYellow]];

}

@end
