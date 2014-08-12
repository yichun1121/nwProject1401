//
//  GroupAndGuyInTripCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/22.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "GroupAndGuyInTripCDTVC.h"
#import "Group.h"
#import "Guy.h"
#import "Trip.h"
#import "Group+TripGuys.h"
#import "Group+Special.h"

@interface GroupAndGuyInTripCDTVC ()

@end

@implementation GroupAndGuyInTripCDTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

#pragma mark - FetchedResultsControllera

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Group";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(inTrip = %@)AND(guysInTrip.@count > 1)",self.currentTrip];
    
//    request.predicate = [NSPredicate predicateWithFormat:@"inTrip = %@",self.currentTrip];
    
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name"
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
    
    //自建一個Done、Back二合一的button取代原先的BackButton
    UIImage *buttonImage = [UIImage imageNamed:@"backButton"];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithImage:buttonImage style:UIBarButtonItemStyleBordered target:self action:@selector(replaceBackBarBtn:)];
    backBtn.title=@"Detail";
    self.navigationItem.leftBarButtonItem=backBtn;
    
    
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
    cell.textLabel.text=[group namedLocalizable];
    cell.detailTextLabel.text=[group guysNameSplitBy:@","];
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
    if ([segue.identifier isEqualToString:@"Add Group Segue"]) {
        NSLog(@"Setting GroupAndGuyInTripCDTVC as a delegate of AddGroupTVC");
        
        AddGroupTVC *addGroupTVC = segue.destinationViewController;
        addGroupTVC.delegate = self;
        /*
         已經在SelectGuysCDTVC裡宣告了一個delegate（是SelectGuysCDTVCDelegate）
         selectGuysCDTVC.delegate=self的意思是：我要監控SelectGuysCDTVC
         */
        
        addGroupTVC.managedObjectContext=self.managedObjectContext;
        //把這個managedObjectContext傳過去，使用同一個managedObjectContext。（這樣新增東西才有反應吧？！）
        addGroupTVC.currentTrip=self.currentTrip;
	}else if ([segue.identifier isEqualToString:@"Group Detail Segue"]){
        NSLog(@"Setting GroupAndGuyInTripCDTVC as a delegate of GroupDetailTVC");
        
        GroupDetailTVC *groupDetailTVC = segue.destinationViewController;
        groupDetailTVC.delegate = self;
        
        groupDetailTVC.managedObjectContext=self.managedObjectContext;
        //把這個managedObjectContext傳過去，使用同一個managedObjectContext。（這樣新增東西才有反應吧？！）
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Group *group=[self.fetchedResultsController objectAtIndexPath:indexPath];
        groupDetailTVC.group=group;
    }
    else {
        NSLog(@"Unidentified Segue Attempted! @%@",self.class);
    }
}
/*回到上一頁時直接delegate
 */
-(void) replaceBackBarBtn:(UIBarButtonItem *)sender {
    
    [self.delegate groupListCheckedInGroupAndGuyInTripCDTVC:self];
    
}
#pragma mark - Deleting（紅➖）+Inserting(綠➕）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Group *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting %@ in %@", group.name,group.inTrip.name);
        [self.managedObjectContext deleteObject:group];
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
-(void)theSaveButtonOnTheAddGroupWasTapped:(AddGroupTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)theSaveButtonOnTheGroupDetailTVCWasTapped:(GroupDetailTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
