//
//  AddGroupTVC.m
//  TryTravel2gether
//
//  Created by apple on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddGroupTVC.h"
#import "Group.h"
#import "GuyInTrip.h"
#import "Guy.h"


@interface AddGroupTVC ()
@property (strong,nonatomic) NSMutableSet *selectedGuys;
@property (strong, nonatomic) UITextField *groupTextField;
@property (nonatomic,strong) NSIndexPath *addGuyIndexPath;
@end

@implementation AddGroupTVC
@synthesize selectedGuys=_selectedGuys;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize addGuyIndexPath;

-(NSMutableSet *) selectedGuys
{
    if (!_selectedGuys) {
        _selectedGuys = [[NSMutableSet alloc] init];
    }
    return _selectedGuys;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.navigationItem.rightBarButtonItem.enabled=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnNumber = 0;
    if (section==0) {
        returnNumber=1;
    } else if(section==1) {
        id<NSFetchedResultsSectionInfo>sectionInfo=[[self.fetchedResultsController sections] objectAtIndex:0];
        NSInteger count=[sectionInfo numberOfObjects];
        returnNumber=count+1;
        //如果count+1,可以多生一行cell連別的controller
    }
    
    return returnNumber;
}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    //self.fetchedResultsController=self.currentTrip.days;
    // 1 - Decide what Entity you want
    NSString *entityName = @"Guy"; // Put your entity name here
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setFetchBatchSize:20];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"inTrip=%@",self.group.inTrip];
    
    // 4 - Sort it if you want
    NSSortDescriptor *sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptors]];
    // 5 - Fetch it
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
	return _fetchedResultsController;
    
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    if (indexPath.section==0) {
        self.groupTextField= [[UITextField alloc] initWithFrame:CGRectMake(85, 7, 215, 30)];
        self.groupTextField.borderStyle=UITextBorderStyleRoundedRect;
        self.groupTextField.delegate=self;//要加delegate=self，監聽textfield，才能在return時收鍵盤
        cell.textLabel.text=@"";
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 11, 56, 21)];
        nameLabel.text=NSLocalizedString(@"Named", @"CellDesc");

        [cell addSubview:self.groupTextField];
        [cell addSubview:nameLabel];
        //-----新增群組需2人以上說明文字-------------------
        UILabel *message=[[UILabel alloc]initWithFrame:CGRectMake(85, 45, 215, 10)];
        message.font=[UIFont systemFontOfSize:10.0];
        message.text=NSLocalizedString(@"AddGroupMin2Tips", @"ActiveTips");
        message.textColor=[UIColor lightGrayColor];
        [cell addSubview:message];
        
    }else if (indexPath.section==1){
        id<NSFetchedResultsSectionInfo>sectionInfo=[[self.fetchedResultsController sections] objectAtIndex:0];
        NSInteger count=[sectionInfo numberOfObjects];
        if (indexPath.row<count) {
            Guy *guy=[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",guy.name];
            cell.detailTextLabel.text=@"";
            cell.textLabel.textColor=[UIColor blackColor];
        }else{
            //可以多生一行cell，連Add Guy 的controller
            cell.textLabel.text = NSLocalizedString(@"AddGuy_SystemParticipant", @"CellDesc");
            cell.textLabel.textColor=[UIColor grayColor];
            cell.detailTextLabel.text= NSLocalizedString(@"PUSH",@"ActiveTips");
            self.addGuyIndexPath=indexPath;
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    if (section==0) {
        sectionName = NSLocalizedString(@"GroupName",@"SessionDesc");
    }else if (section==1){
        sectionName = [NSString stringWithFormat:NSLocalizedString(@"GuysInSystem",@"SessionDesc")];
    }
    return sectionName;
}
//被選起來就打勾勾，有打勾勾的存進NSSet
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    //可以多生一行cell，連Add Guy 的controller
    if (self.addGuyIndexPath&&(indexPath.row==self.addGuyIndexPath.row)) {
        cell.accessoryType=UITableViewCellAccessoryNone;
        [self moveToAddGuyTVC];
        
    }else{
        Guy *guy=[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        
        if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
            cell.accessoryType=UITableViewCellAccessoryNone;
            [self.selectedGuys removeObject:guy];
        }else{
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
            [self.selectedGuys addObject:guy];
        }
        if ([self.selectedGuys count]>1) {
            self.navigationItem.rightBarButtonItem.enabled=YES;
        }else{
            self.navigationItem.rightBarButtonItem.enabled=NO;
        }
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 64.0f;
    }else {
        return 44.0f;
    }
}

#pragma mark - ➤ Navigation：Segue Settings

/*手動移到下一頁：selectGuysCDTVC
 */
- (void)moveToAddGuyTVC{
    UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                          bundle:nil];
    AddGuyTVC *addGuyTVC=[storyboard instantiateViewControllerWithIdentifier:@"AddGuyTVC"];
    addGuyTVC.managedObjectContext=self.managedObjectContext;
    addGuyTVC.delegate=self;
    NSMutableArray *viewcontrollers=[self.navigationController.viewControllers mutableCopy];
    [viewcontrollers addObject:addGuyTVC];
    self.navigationController.viewControllers=[viewcontrollers copy];
    [self.navigationController popToViewController:addGuyTVC animated:YES];
}


#pragma mark - Delegation
-(void)theSaveButtonOnTheAddGuyWasTapped:(AddGuyTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    };
    [self.tableView reloadData];
    
}

- (IBAction)save:(UIBarButtonItem *)sender {
    
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                             inManagedObjectContext:self.managedObjectContext];
    
    group.name = self.groupTextField.text;
    group.inTrip=self.currentTrip;
    [self.managedObjectContext save:nil];  // write to database
    [self setGroup:group forGuys:self.selectedGuys RealInTrip:self.currentTrip];
    [self setGroup:group forGuys:self.selectedGuys NotRealInTrip:self.currentTrip];
    [self.delegate theSaveButtonOnTheAddGroupWasTapped:self];
}

#pragma mark - GuyInTrip
//原本已經在的人就直接新增Group
-(void)setGroup:(Group *)group forGuys:(NSSet *)selectedGuys RealInTrip:(Trip *)trip {
    
    for (Guy *guy in selectedGuys) {

    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"GuyInTrip" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(inTrip=%@)AND (guy=%@)",trip,guy];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if ([objects count]>0) {
            for (int i=0; i<[objects count]; i++) {
                GuyInTrip *guyInTrip=objects[i];
                [guyInTrip addGroupsObject:group];
                [self.managedObjectContext save:nil];
            }
        }
    }
  
}
//不在trip的人新增GuyInTrip & 以個人為單位的group
-(void)setGroup:(Group *)group forGuys:(NSSet *)selectedGuys NotRealInTrip:(Trip *)trip{
    NSMutableArray *guyInTripArray=[NSMutableArray new];
    for (GuyInTrip * guyInTrip in trip.guysInTrip) {
        [guyInTripArray addObject:guyInTrip.guy];
    }

    for (Guy *guy in selectedGuys) {
        if (![guyInTripArray containsObject:guy]) {
           
            Group *groupForEachGuy = [NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                                                   inManagedObjectContext:self.managedObjectContext];
            groupForEachGuy.name=guy.name;
            groupForEachGuy.inTrip=trip;
            [self.managedObjectContext save:nil];
            
            
            GuyInTrip *guyInTrip = [NSEntityDescription insertNewObjectForEntityForName:@"GuyInTrip"
                                                                 inManagedObjectContext:self.managedObjectContext];
            guyInTrip.realInTrip=[NSNumber numberWithBool:NO];
            guyInTrip.inTrip=trip;
            guyInTrip.groups=[NSSet setWithObjects:group,groupForEachGuy,nil];
            guyInTrip.guy=guy;
            
            [self.managedObjectContext save:nil];
            
            
            
        }
    }

}



#pragma mark - delegation
#pragma mark - 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
