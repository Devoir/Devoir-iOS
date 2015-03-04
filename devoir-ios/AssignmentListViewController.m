//
//  AssignmentListViewController.m
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AssignmentListViewController.h"
#import "AssignmentDBAccess.h"
#import "AssignmentTableViewCell.h"
#import "UIColor+DevoirColors.h"

@interface AssignmentListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) AssignmentDBAccess *assignmentsDB;
@property (strong, nonatomic) NSArray *assignments;
- (IBAction)checkboxHit:(id)sender;

@end

@implementation AssignmentListViewController

- (void) viewDidLoad {
    //self.assignmentsDB = [[AssignmentDBAccess alloc] init];
    //self.assignments = [self.assignmentsDB getAllAssignmentsOrderedByNameForCourse:1];
    
    self.assignments = [[NSArray alloc] initWithObjects: @"Homework 16", @"Lab 5", @"Homework 17", @"Whiteborad experience", nil];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.assignments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    AssignmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.assignmentLabel.text = [self.assignments objectAtIndex:indexPath.row];
    cell.courseLabel.text = @"CS 312";
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
@end
