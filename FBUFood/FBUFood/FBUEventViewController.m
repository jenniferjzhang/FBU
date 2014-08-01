//
//  FBUEventViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEventViewController.h"
#import "FBUEvent.h"
#import "FBUEventDetailViewController.h"

@interface FBUEventViewController ()
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation FBUEventViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneMemberCell"
                                                            forIndexPath:indexPath];
    PFUser *personGoing = self.event.membersOfEvent[indexPath.row];
    [personGoing fetchIfNeeded];
    cell.textLabel.text = [personGoing username];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.event.membersOfEvent count];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.title = self.event.eventName;
    self.eventLocationLabel.text = self.event.eventAddress;
    self.eventTimeDateLabel.text = self.event.eventTimeDate;
    self.eventMealsLabel.text = [@"Meals: " stringByAppendingString:self.event.eventMeals];
    if (self.event.creator != [PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.event.membersOfEvent == NULL) {
        NSLog(@"%@", self.event.membersOfEvent);
        self.eventJoinButton.hidden = NO;
        self.eventJoinButton.enabled = YES;
    } else if ([self.event checkIfUserIsInEventArray:self.event.membersOfEvent]) {
        NSLog(@"%@", self.event.membersOfEvent);
        self.eventJoinButton.hidden = YES;
        self.eventJoinButton.enabled = NO;
    }
    
    [self.eventUsersTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.eventUsersTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"oneMemberCell"];
    
    self.eventUsersTableView.delegate = self;
    self.eventUsersTableView.dataSource = self;
}


- (IBAction)userDidJoinEvent:(id)sender
{
    [self showAlertWithTitle:self.title
                     message:[NSString stringWithFormat:@"You are going to %@ !", self.title]];
    
    [self.event addObject:[PFUser currentUser] forKey:@"membersOfEvent"];
    [self.event saveInBackground];
    [self.eventUsersTableView reloadData];
    
    //Disable join button once user has joined.
    self.eventJoinButton.hidden = YES;
    self.eventJoinButton.enabled = NO;
}


-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

@end
