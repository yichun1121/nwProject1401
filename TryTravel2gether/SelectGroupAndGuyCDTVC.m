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

@interface SelectGroupAndGuyCDTVC()
@property (strong,nonatomic)NSArray *fetchedObjects;
@end
@implementation SelectGroupAndGuyCDTVC


@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize fetchedObjects=_fetchedObjects;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

#pragma mark - FetchedResultsController

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Group";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"inTrip = %@",self.currentTrip];
    NSArray *predicatesArray=[NSArray arrayWithObjects:predicate,nil];
    NSPredicate *mutiplePredicate=[NSCompoundPredicate orPredicateWithSubpredicates:predicatesArray];
    request.predicate =mutiplePredicate;
    request.sortDescriptors=[NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                           ascending:YES], nil];
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


-(NSArray *)fetchedObjects{
    if(!_fetchedObjects){
        _fetchedObjects = [self.fetchedResultsController fetchedObjects];
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"guysInTrip.@count" ascending:NO];
        NSArray *sortArray=[[NSArray alloc]initWithObjects:sort, nil];
        _fetchedObjects=[_fetchedObjects sortedArrayUsingDescriptors:sortArray];
    }
    return _fetchedObjects;
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

    
    Group *group=[self.fetchedObjects objectAtIndex:indexPath.row];
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
//    self.selectedGroup=[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedGroup=self.fetchedObjects[indexPath.row];
    [self.delegate theGroupCellOnTheSelectGroupAndGuyCDTVCWasTapped:self];
}

@end
