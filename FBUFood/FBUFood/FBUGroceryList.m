//
//  FBUGroceryList.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroceryList.h"
#import <Parse/PFObject+Subclass.h>

@implementation FBUGroceryList

+ (NSString *)parseClassName
{
    return @"FBUGroceryList";
}

@dynamic recipesToFollow;
@dynamic ingredientsToBuy;



- (void)fillInGroceryList
{
    [self fetchIfNeeded];
    for (FBURecipe *recipe in self.recipesToFollow) {
        [recipe fetchIfNeeded];
        if (recipe.fromYummly == YES) {
            NSArray *recipeIngredients = [recipe.ingredientsList componentsSeparatedByString:@",\n"];
            for (NSString *word in recipeIngredients) {
                if (![self.ingredientsToBuy containsObject: word]) {
                    [self addObject:word forKey:@"ingredientsToBuy"];
                    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        NSLog(@"Filling in the grocery list: %@", word);
                    }];
                }
            }
        } else {
            NSArray *recipeIngredients = [recipe.ingredientsList componentsSeparatedByString:@", "];
            for (NSString *word in recipeIngredients) {
                if (![self.ingredientsToBuy containsObject: word]) {
                    [self addObject:word forKey:@"ingredientsToBuy"];
                    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        NSLog(@"Filling in the grocery list: %@", word);
                    }];
                }
            }
            
        }
    }
}

@end
