//
//  FBURecipeDishViewController.h
//  FBUFood
//
//  Created by Amber Meighan on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBURecipe;


@interface FBURecipeDishViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *dishTitleLabel;
@property (nonatomic) FBURecipe *recipe;

@end