//
//  FBUProfileViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FBUCollectionViewLayout.h"
#import "FBUCollectionCellBackgroundView.h"

@interface FBUProfileViewController : UIViewController <UICollectionViewDelegateJSPintLayout, UICollectionViewDataSource>

// Properties for profile data
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

// Properties for the group table view
@property (weak, nonatomic) IBOutlet UICollectionView *myGroupsCollectionView;

@property (strong, nonatomic) NSArray *myGroupsArray;


@end
