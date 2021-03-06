//
//  FBURecipesYummylyViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 8/9/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipesYummylyViewController.h"
#import "FBURecipeViewController.h"
#import "FBURecipe.h"
#import "FBUYummlyRecipeCell.h"

@interface FBURecipesYummylyViewController()

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSString *searchedWords;
@property (strong, nonatomic) NSString *url;

@end

@implementation FBURecipesYummylyViewController

- (void)viewDidLoad
{
    self.recipesTableView.delegate = self;
    self.recipesTableView.dataSource = self;
    //self.recipesTableView.allowsMultipleSelection = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.recipesTableView registerClass:[FBUYummlyRecipeCell class] forCellReuseIdentifier:@"FBUYummlyRecipeCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)callYummlyAPI
{
    self.responseData = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *searchedWords = [self.recipeSearchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *url = @"http://api.yummly.com/v1/api/recipes?_app_id=f07aaa47&_app_key=6d7ecf41b1791b1d9a05b31dd8b62f39&q=";
    
    NSString *urlWithKeywords = [url stringByAppendingString:searchedWords];
    self.url = [urlWithKeywords stringByAppendingString:@"&requirePictures=true"];
    
    self.url = [url stringByAppendingString:searchedWords];
    [self callYummlyAPI];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"didFailWithError");
    //NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"connectionDidFinishLoading");
    //NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    //grab recipe names
    self.yummlyRecipes = [[NSMutableArray alloc] init];
    for (id recipe in res[@"matches"]) {
        NSDictionary *recipeDict = (NSDictionary *)recipe;
        FBURecipe *myRecipe = [FBURecipe object];
        myRecipe.title = recipeDict[@"recipeName"];
        NSMutableString *recipeIngredients = [[NSMutableString alloc] initWithString:[recipeDict[@"ingredients"] description]];
        [recipeIngredients replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[recipeIngredients length]}];
        [recipeIngredients replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[recipeIngredients length]}];
        [recipeIngredients replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[recipeIngredients length]}];
        myRecipe.ingredientsList = recipeIngredients;
        myRecipe.isYummlyRecipe = true;
        
        NSMutableString *myURLString = [[NSMutableString alloc] initWithString:@"http://api.yummly.com/v1/api/recipe/"];
        NSString *recipeId = recipeDict[@"id"];
        NSString *endString = @"?_app_id=f07aaa47&_app_key=6d7ecf41b1791b1d9a05b31dd8b62f39";
        [myURLString appendString:recipeId];
        [myURLString appendString:endString];
        NSData *recipeData = [[NSData alloc] init];
        recipeData = [recipeData initWithContentsOfURL: [NSURL URLWithString:myURLString]];
        NSDictionary *res2 = [NSJSONSerialization JSONObjectWithData:recipeData options:NSJSONReadingMutableLeaves error:&myError];
        
        NSDictionary *subDict = (NSDictionary *)res2[@"source"];
        myRecipe.directions = [subDict[@"sourceRecipeUrl"] description];
        
        NSString *myString = [res2[@"images"] description];
        NSMutableString *urlImage1 = [[NSMutableString alloc] initWithString:myString];
        [urlImage1 replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[urlImage1 length]}];
        [urlImage1 replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[urlImage1 length]}];
        NSDictionary *dict = [NSPropertyListSerialization
                              propertyListWithData:[urlImage1 dataUsingEncoding:NSUTF8StringEncoding]
                              options:kNilOptions
                              format:NULL
                              error:NULL];
        NSString *largeUrlImage = [dict[@"hostedLargeUrl"] description];
        
        NSMutableString *urlImage = [[NSMutableString alloc] initWithString:largeUrlImage];
        [urlImage replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[urlImage length]}];
        [urlImage replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[urlImage length]}];
        [urlImage replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[urlImage length]}];
        [urlImage replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[urlImage length]}];
        [urlImage replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[urlImage length]}];
        if (urlImage != nil) {
            NSData *receivedData = [[NSData alloc] init];
            urlImage = [[NSMutableString alloc] initWithString:[urlImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            receivedData = [receivedData initWithContentsOfURL: [NSURL URLWithString:urlImage]];
            UIImage *img = [[UIImage alloc] initWithData:receivedData];
            NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
            NSString *filename = [NSString stringWithFormat:@"%@.png", myRecipe.title];
            PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
            myRecipe.image = imageFile;
        }
        
        [self.yummlyRecipes addObject:myRecipe];
        [self.recipesTableView reloadData];
        
        [myRecipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"savedToParse" object:self];
            }
        }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"seeInsideView"]){
        
        FBURecipeViewController *controller = (FBURecipeViewController *)segue.destinationViewController;
        NSIndexPath *ip = [self.recipesTableView indexPathForSelectedRow];
        controller.recipe = self.yummlyRecipes[ip.row];
        [controller.editButton setTitle:@""];
        controller.editButton.enabled = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }*/
    
    [self performSegueWithIdentifier:@"seeInsideView" sender:self];
}

- (IBAction)addRecipesToMyRecipes:(id)sender
{
    NSArray *selectedCells = [self.recipesTableView indexPathsForSelectedRows];
    
    for (NSIndexPath *selectedCell in selectedCells){
        NSIndexPath *indexPath = selectedCell;
        
        FBURecipe *selectedRecipe = self.yummlyRecipes[indexPath.row];
        selectedRecipe.publisher = [PFUser currentUser];
        [selectedRecipe saveInBackground];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *cellIdentifier = @"UITableViewCell";
    FBUYummlyRecipeCell *cell = (FBUYummlyRecipeCell *)[self.recipesTableView dequeueReusableCellWithIdentifier:@"FBUYummlyRecipeCell" forIndexPath:indexPath];
    FBURecipe *recipe = [self.yummlyRecipes objectAtIndex:indexPath.row];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:17.0]];
    cell.textLabel.text = recipe[@"title"];
    cell.imageView.image = [UIImage imageWithData:[recipe.image getData]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.yummlyRecipes count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
