//
//  FBUGroupsViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUGroupsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *generalMeetingTimesLabel;
@property (weak, nonatomic) IBOutlet UIButton *recipesInGroupButton;
@property (weak, nonatomic) IBOutlet UITableView *eventsInGroupTableView;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *subscribeGroupButton;

//Buttons shown if you have joined the group
@property (weak, nonatomic) IBOutlet UIButton *createEventInGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *addRecipeInGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *viewSubscribersInGroupButton;




@end

