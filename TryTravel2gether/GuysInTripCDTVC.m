//
//  GuysInTripCDTVC.m
//  TryTravel2gether
//
//  Created by apple on 2014/4/19.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "GuysInTripCDTVC.h"
#import "NWCustCellSwitch.h"

@interface GuysInTripCDTVC ()
@property(strong, nonatomic)NSMutableArray *indexPathArray;
@end

@implementation GuysInTripCDTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize delegate;
@synthesize selectedGuys=_selectedGuys;



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
    
}


#pragma mark - FetchedResultsController

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"GuyInTrip"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    request.predicate = [NSPredicate predicateWithFormat:@"inTrip = %@",self.currentTrip];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"realInTrip"
                                                                                     ascending:NO
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}



-(void)viewDidLoad{
    [super viewDidLoad];
    
    //自建一個Done、Back二合一的button取代原先的BackButton
    UIImage *buttonImage = [UIImage imageNamed:@"backButton"];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithImage:buttonImage style:UIBarButtonItemStyleBordered target:self action:@selector(replaceBackBarBtn:)];
    backBtn.title=@"Detail";
    self.navigationItem.leftBarButtonItem=backBtn;
    
    //-----註冊CustomCell----------
    UINib* myCellNib = [UINib nibWithNibName:@"NWCustCellSwitch" bundle:nil];
    [self.tableView registerNib:myCellNib forCellReuseIdentifier:@"Cell"];
    
}
-(NSMutableSet *)selectedGuys{
    if (_selectedGuys==nil) {
        _selectedGuys=[NSMutableSet new];
    }
    return _selectedGuys;
}
-(NSMutableArray *)indexPathArray{
    if (_indexPathArray==nil) {
        _indexPathArray=[NSMutableArray new];
    }
    return _indexPathArray;
}

#pragma mark - Table view data source

- (NWCustCellSwitch *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NWCustCellSwitch *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NWCustCellSwitch alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}
-(NWCustCellSwitch *)configureCell:(NWCustCellSwitch *)cell AtIndexPath:(NSIndexPath *)indexPath{
    GuyInTrip *guyInTrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",guyInTrip.guy.name];
    [self.selectedGuys addObject:guyInTrip.guy];
    
    if ([guyInTrip.realInTrip boolValue]==NO) {
        cell.switchControl.on=NO;
    }else{
        cell.switchControl.on=YES;
    }
    [cell.switchControl addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

-(void)switchChanged:(id)sender{
    UISwitch *switchcontrol=(UISwitch *)sender;
    id parentCell=[switchcontrol superview];
    while (![parentCell isKindOfClass:[NWCustCellSwitch class]]) {
        parentCell=[parentCell superview];
        if (parentCell==nil) {
            break;
        }
    }
    NSIndexPath *indexPath=[self.tableView indexPathForCell:parentCell];
    GuyInTrip *guyInTrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (switchcontrol.on==YES) {
        guyInTrip.realInTrip=[NSNumber numberWithBool:YES];
    }else{
        guyInTrip.realInTrip=[NSNumber numberWithBool:NO];
    }
    [self.managedObjectContext save:nil];
}
//TODO:改share_All的參與人員

#pragma mark - ➤ Navigation：Segue Settings

// 內建，準備Segue的method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //判斷是哪條連線（會對應Segue的名稱）
	if ([segue.identifier isEqualToString:@"Select Guy Segue From GuysInTripCDTVC"])
	{
        NSLog(@"Setting GuysInTripTVC as a delegate of SelectGuysCDTVC");
        
        SelectGuysCDTVC *selectGuysCDTVC = segue.destinationViewController;
        selectGuysCDTVC.delegate = self;
        /*
         已經在SelectGuysCDTVC裡宣告了一個delegate（是SelectGuysCDTVCDelegate）
         selectGuysCDTVC.delegate=self的意思是：我要監控AddGuyCDTVC
         */
        
        selectGuysCDTVC.managedObjectContext=self.managedObjectContext;
        //把這個managedObjectContext傳過去，使用同一個managedObjectContext。（這樣新增東西才有反應吧？！）
        selectGuysCDTVC.selectedGuys=[self.selectedGuys mutableCopy];
        
	}
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}
#pragma mark - Group&GuyInTrip
/*!把每個參與者都視為一個Group
 */
-(void)createDefaultGroupWithGuy:(NSSet *)selectedGuy InCurrentTrip:(Trip *)trip{
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name=%@) AND (inTrip=%@)",@"Share_All",trip];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    Group *groupAll;
    if ([objects count]>0) {
        groupAll=objects[0];
    }
    
    for (Guy* guy in selectedGuy) {
        Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                                     inManagedObjectContext:self.managedObjectContext];
        group.name=guy.name;
        group.inTrip=trip;
        [self.managedObjectContext save:nil];
        
        GuyInTrip *guyInTrip = [NSEntityDescription insertNewObjectForEntityForName:@"GuyInTrip"
                                                             inManagedObjectContext:self.managedObjectContext];
        guyInTrip.realInTrip=[NSNumber numberWithBool:YES];
        guyInTrip.inTrip=trip;
        [guyInTrip addGroupsObject:group];
        if (groupAll) {
            [guyInTrip addGroupsObject:groupAll];
        }
        guyInTrip.guy=guy;
        
        [self.managedObjectContext save:nil];
        
    }
}



/*!刪除不要的參與者
 */
-(void)deleteGuysAndGroups:(NSSet *)guysToDelete inCurrentTrip:(Trip *)trip{
    for (Guy *guy in guysToDelete) {
        NSEntityDescription *entityDesc =
        [NSEntityDescription entityForName:@"GuyInTrip" inManagedObjectContext:self.managedObjectContext];
        
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(inTrip=%@)AND (guy=%@)",trip,guy];
        [request setPredicate:pred];
        
        NSError *error;
        NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if ([objects count]>0) {
            
            for (int i=0; i<[objects count]; i++) {
                GuyInTrip *guyInTrip=objects[i];
                NSSet *groupsForGuy=guyInTrip.groups;
                for (Group *group in groupsForGuy) {
                    if([group.guysInTrip count]==1){
                        [self.managedObjectContext deleteObject:group];
                        [self.managedObjectContext save:nil];
                    }
                }
                [self.managedObjectContext deleteObject:guyInTrip];
                [self.managedObjectContext save:nil];
            }
            
        }
        
        
        
    }
}
#pragma mark - Delegation
/*
 .h檔案宣告時有@interface GuysInTripTVC : UITableViewController <AddGuyTVCDelegate>
 就要實作AddGuyTVCDelegate宣告的method
 */
-(void)guyWasSelectedInSelectGuysCDTVC:(SelectGuysCDTVC *)controller
{
    NSMutableSet *minusGuys=[self.selectedGuys mutableCopy];
    [minusGuys minusSet:controller.selectedGuys];
    NSMutableSet *plusGuys=[controller.selectedGuys mutableCopy];
    [plusGuys minusSet:self.selectedGuys];
    
    //self.selectedGuys=controller.selectedGuys;
    [self deleteGuysAndGroups:minusGuys inCurrentTrip:self.currentTrip];
    [self createDefaultGroupWithGuy:plusGuys InCurrentTrip:self.currentTrip];
    self.selectedGuys=controller.selectedGuys;
    [controller.navigationController popViewControllerAnimated:YES];
    
    
}

/*回到上一頁時直接delegate
 */
-(void) replaceBackBarBtn:(UIBarButtonItem *)sender {
    [self.delegate guyWasSelectedInGuysInTripCDTVC:self];
}
@end