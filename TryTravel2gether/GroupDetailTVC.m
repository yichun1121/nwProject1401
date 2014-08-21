//
//  GroupDetailTVC.m
//  TryTravel2gether
//
//  Created by apple on 2014/5/7.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "GroupDetailTVC.h"
#import "GuyInTrip.h"
#import "Guy.h"
#import "Group+Special.h"


@interface GroupDetailTVC ()
@property(nonatomic,strong) NSIndexPath *addGuyIndexPath;
@property(nonatomic,strong) NSMutableSet *guysInTripOfGroup;
@property(nonatomic,strong) NSMutableSet *selectedGuys;
@property(nonatomic,strong) UITextField* groupTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@end

@implementation GroupDetailTVC

@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize group=_group;
@synthesize addGuyIndexPath,groupTextField;
@synthesize selectedGuys=_selectedGuys;
@synthesize guysInTripOfGroup=_guysInTripOfGroup;

-(NSMutableSet *)selectedGuys{
    if (_selectedGuys==nil) {
        _selectedGuys=[NSMutableSet new];
    }
    return _selectedGuys;
}

-(NSMutableSet *)guysInTripOfGroup{
    if (_guysInTripOfGroup==nil) {
        _guysInTripOfGroup=[self.group.guysInTrip mutableCopy];
    }
    return _guysInTripOfGroup;
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
        returnNumber=count;
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
    NSString *entityName = @"GuyInTrip"; // Put your entity name here
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setFetchBatchSize:20];
    
    // 3 - Filter it if you want
    request.predicate = [NSPredicate predicateWithFormat:@"inTrip=%@",self.group.inTrip];
    
    // 4 - Sort it if you want
    NSSortDescriptor *sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"guy" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptors]];
    // 5 - Fetch it
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
	return _fetchedResultsController;
    
    
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
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=[self.group namedLocalizable];
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
        //-----如果是Share-All群組，就把右上角確認修改按鈕關掉，不可修改。----------
        if ([self.group isShareAll]) {
            self.groupTextField.enabled=NO;
            self.btnSave.enabled=NO;
        }else{
            self.groupTextField.enabled=YES;
            self.btnSave.enabled=YES;
        }
        
        self.groupTextField= [[UITextField alloc] initWithFrame:CGRectMake(85, 7, 215, 30)];
        self.groupTextField.borderStyle=UITextBorderStyleRoundedRect;
        self.groupTextField.delegate=self;
        //-----Name Label-----
        cell.textLabel.text=@"";
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 11, 56, 21)];
        nameLabel.text=NSLocalizedString(@"Named", @"CellDesc");
        [cell addSubview:nameLabel];
        self.groupTextField.text=[self.group namedLocalizable];
        [cell addSubview:self.groupTextField];
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
            GuyInTrip *guyInTrip=[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            [self.selectedGuys addObject:guyInTrip.guy];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",guyInTrip.guy.name];
            if ([self.group.guysInTrip containsObject:guyInTrip]) {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
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
        sectionName=[NSString stringWithFormat:NSLocalizedString(@"GuysInGroup",@"SessionDesc")];
    }
    return sectionName;
}
//被選起來就打勾勾，有打勾勾的存進NSSet
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.group.isShareAll) {
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        //可以多生一行cell，連Add Guy 的controller
        if (self.addGuyIndexPath&&(indexPath.row==self.addGuyIndexPath.row)) {
            cell.accessoryType=UITableViewCellAccessoryNone;
            [self moveToSelectGuysCDTVC];
        
        }else{
            if (indexPath.section!=0) {
            //如果indexPath.section=0，就是點選到群組名稱那行，不需要打勾
                GuyInTrip *guyInTrip=[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];

                if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
                    cell.accessoryType=UITableViewCellAccessoryNone;
                    [self.guysInTripOfGroup removeObject:guyInTrip];
                }else{
                    cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    [self.guysInTripOfGroup addObject:guyInTrip];
                }
                if ([self.guysInTripOfGroup count]>1) {
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                }else{
                    self.navigationItem.rightBarButtonItem.enabled=NO;
                }
            }
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
- (void)moveToSelectGuysCDTVC{
    UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    SelectGuysCDTVC *selectGuysCDTVC=[storyboard instantiateViewControllerWithIdentifier:@"SelectGuysCDTVC"];
    selectGuysCDTVC.managedObjectContext=self.managedObjectContext;
    selectGuysCDTVC.delegate=self;
    selectGuysCDTVC.SelectedGuys=self.selectedGuys;
    NSMutableArray *viewcontrollers=[self.navigationController.viewControllers mutableCopy];
    [viewcontrollers addObject:selectGuysCDTVC];
    self.navigationController.viewControllers=[viewcontrollers copy];
    [self.navigationController popToViewController:selectGuysCDTVC animated:YES];
}


#pragma mark - Delegation
-(void)guyWasSelectedInSelectGuysCDTVC:(SelectGuysCDTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
    controller.SelectedGuys=self.selectedGuys;
}
#pragma mark - 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL editable;
    if (self.group.isShareAll) {
        editable=NO;
    }else{
        editable=YES;
    }
    return editable;
}

- (IBAction)save:(id)sender{
    self.group.guysInTrip=[self.guysInTripOfGroup copy];
    self.group.name=self.groupTextField.text;
    [self.managedObjectContext save:nil];
    [self.delegate theSaveButtonOnTheGroupDetailTVCWasTapped:self];
}

@end
