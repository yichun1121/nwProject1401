//
//  CategoriesCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CategoriesCDTVC.h"
#import "Itemcategory.h"
#import "SWRevealViewController.h"
#import "Itemcategory+Colorful.h"

@interface CategoriesCDTVC ()
@end

@implementation CategoriesCDTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //------Set Sidebar Menu--------
    [self setSidebarMenuAction];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

#pragma mark - FetchedResultsController

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Itemcategory";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    //request.predicate=nil;
    
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                    ascending:YES
                                                                                     selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                     managedObjectContext:self.managedObjectContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    [self performFetch];
}
-(void)setSidebarMenuAction{
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    #pragma mark 在sidebar menu下讓delete功能正常
    self.revealViewController.panGestureRecognizer.delegate = self;
    // Set the gesture （在下面delegation的地方）
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


#pragma mark - Table view data source
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    return cell;
}
/*!組合TableViewCell的顯示內容
 */
-(UITableViewCell *)configureCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    Itemcategory *itemCategory=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=itemCategory.name;
    cell.imageView.image=itemCategory.image;
//    cell.backgroundColor=itemCategory.color;
    cell.imageView.backgroundColor=itemCategory.color;
    cell.imageView.layer.borderColor=[itemCategory.color CGColor];
    cell.imageView.layer.borderWidth=0;
    [cell.imageView.layer setMasksToBounds:YES];
    [cell.imageView.layer setCornerRadius:4.0];
//    cell.imageView.layer.shadowColor=[[UIColor blackColor] CGColor];
//    [cell.imageView.layer setShadowOffset:CGSizeMake(-5.0, 5.0)];
//    [cell.imageView.layer setShadowRadius:3.0];
//    [cell.imageView.layer setShadowOpacity:1.0];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ➤ Navigation：Segue Settings

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Cat Segue From Cat List"]) {
        AddCategoryTVC * addCategoryTVC=segue.destinationViewController;
        addCategoryTVC.delegate=self;
        addCategoryTVC.managedObjectContext=self.managedObjectContext;
    }
}
#pragma mark - Deleting（紅➖）+Inserting(綠➕）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Itemcategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting %@", category.name);
        [self.managedObjectContext deleteObject:category];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        
        [self.tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
#pragma mark - delegation
-(void)theSaveButtonOnTheAddCategoryWasTapped:(AddCategoryTVC *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end

