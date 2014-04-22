//
//  SelectGroupAndGuyCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/22.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "SelectGroupAndGuyCDTVC.h"
#import "Group.h"
#import "GuyInTrip.h"
#import "Guy.h"
#import "Group+TripGuys.h"

@implementation SelectGroupAndGuyCDTVC


@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

#pragma mark - FetchedResultsController

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Group";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    request.predicate = [NSPredicate predicateWithFormat:@"inTrip = %@",self.currentTrip];
    
    request.sortDescriptors=[NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                           ascending:YES
                                                            selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                     managedObjectContext:self.managedObjectContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    [self performFetch];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    Group *group=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=group.name;
    if ([group.guysInTrip count]==1) {
        cell.imageView.image=[UIImage imageNamed:group.groupImageName];
        cell.detailTextLabel.text=@"";
    }else {
        cell.imageView.image=[UIImage imageNamed:group.groupImageName];
        cell.detailTextLabel.text=[group guysNameSplitBy:@","];
    }
    if (group==self.selectedGroup) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    return cell;
}
#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedGroup=[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate theGroupCellOnTheSelectGroupAndGuyCDTVCWasTapped:self];
}
@end
