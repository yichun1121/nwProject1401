//
//  DaysCDTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "DaysCDTVC.h"
#import "ReceiptsCDTVC.m"
#import "Day+TripDay.h"
#import "NWCustCellTitleSubDetail.h"
#import "Day+Expend.h"
#import "ShareMainPageCDTVC.h"
#import "Trip+Currency.h"


@interface DaysCDTVC ()
@property NSDateFormatter *dateFormatter;
@property Currency *showingCurrency;
@property int currencyIndex;
@property (nonatomic)UILabel *lblNavTitle;
@end

@implementation DaysCDTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize currentTrip=_currentTrip;
@synthesize dateFormatter=_dateFormatter;
@synthesize currencyIndex=_currencyIndex;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
    //self.tableView.editing=YES;
}

#pragma mark - lazy instantiation

-(UILabel *)lblNavTitle{
    if (!_lblNavTitle) {
        _lblNavTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        _lblNavTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lblNavTitle;
}

#pragma mark - FetchedResultsController

- (void)setupFetchedResultsController
{
    //self.fetchedResultsController=self.currentTrip.days;
    // 1 - Decide what Entity you want
    NSString *entityName = @"Day"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    request.predicate = [NSPredicate predicateWithFormat:@"inTrip = %@",self.currentTrip];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //-----設定title + 註冊手勢-----------
//    self.navigationItem.title=self.currentTrip.name;
    self.lblNavTitle.text=self.currentTrip.name;
    UITapGestureRecognizer* tapRecon = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(navigationTitleTapOnce:)];
    tapRecon.numberOfTapsRequired = 1;
//    [self.navigationItem.titleView setUserInteractionEnabled:YES];
//    [self.navigationItem.titleView addGestureRecognizer:tapRecon];
    [self.lblNavTitle addGestureRecognizer:tapRecon];
    [self.lblNavTitle setUserInteractionEnabled:YES];
    self.navigationItem.titleView=self.lblNavTitle;
    
    
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    //-----註冊CustomCell----------
    UINib* myCellNib = [UINib nibWithNibName:@"NWCustCellTitleSubDetail" bundle:nil];
    [self.tableView registerNib:myCellNib forCellReuseIdentifier:@"Cell"];
    //-----設定下一頁時的back button的字（避免本頁的title太長）-----------
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NavBackString_Days", @"NavigationBackString") style:UIBarButtonItemStylePlain target:nil action:nil];
    //-----預設顯示幣別----------
    self.showingCurrency=self.currentTrip.mainCurrency;
    self.currencyIndex=0;
    //-----記錄目前檢視中的Trip--------（讓切換share的tab時可以知道顯示哪個trip）
    UINavigationController *navigationCTL=self.tabBarController.childViewControllers[1];
    if ([navigationCTL.topViewController isKindOfClass:ShareMainPageCDTVC.class]) {
        ShareMainPageCDTVC * sharePage=(ShareMainPageCDTVC *)navigationCTL.topViewController;
        sharePage.currentTrip=self.currentTrip;
    }
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return (![[[touch view] class] isSubclassOfClass:[UIControl class]]);
//}
#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NWCustCellTitleSubDetail *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NWCustCellTitleSubDetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}
/*!組合TableViewCell的顯示內容
 */
-(NWCustCellTitleSubDetail *)configureCell:(NWCustCellTitleSubDetail *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    Day *day=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleTextLabel.text =[day DayNumberStringOfTripdayInTrip]; //ex:Day 2 or Prepare;
    NSString *strDate=[self.dateFormatter stringFromDate:day.date];
    NSString *shortDate=[strDate substringFromIndex:5];
    cell.subtitleTextLabel.text=[NSString stringWithFormat:@"(%@) %@",shortDate,day.name];    //ex:2013/11/29：關西國際機場、高台寺
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",self.showingCurrency.sign,[day dayExpendUsing:self.showingCurrency]];
    
    return cell;
}
/*! 判斷某天是該次旅程的第幾天（startDate當天回傳1，前一天回傳-1，不應該有0） */
-(int)DayNumberOfTripdayInTrip:(Day *)tripDay{
    int result=0;
    NSDateComponents * dateComponents=[[NSDateComponents alloc]init];
    dateComponents=[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:tripDay.inTrip.startDate toDate:tripDay.date options:0];
    if (dateComponents.day>=0) {
        result=(int)dateComponents.day+1;
    }else{
        result=(int)dateComponents.day;
    }
    return result;
}
#pragma mark - Deleting（紅➖）+Inserting(綠➕）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Day *dayToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", dayToDelete.name);
        [self.managedObjectContext deleteObject:dayToDelete];
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


#pragma mark - ➤ Navigation：Segue Settings

// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Add Receipt Segue"]) {
        
        NSLog(@"Setting DaysCDTVC as a delegate of AddReceiptTVC");
        
        AddReceiptTVC *addReceiptTVC = segue.destinationViewController;
        addReceiptTVC.delegate = self;
        
        /*
         已經在AddReceiptTVC裡宣告了一個delegate（是AddReceiptTVCDelegate）
         addReceiptCDTVC.delegate=self的意思是：我要監控AddReceiptTVC
         */
        
        addReceiptTVC.managedObjectContext=self.managedObjectContext;
        //把這個managedObjectContext傳過去，使用同一個managedObjectContext。
        addReceiptTVC.currentTrip=self.currentTrip;
    }else if([segue.identifier isEqualToString:@"Receipts List Segue"]){
        NSLog(@"Setting DaysCDTVC as a delegate of ReceiptsCDTVC");
        ReceiptsCDTVC *receiptsCDTVC=segue.destinationViewController;
        receiptsCDTVC.managedObjectContext=self.managedObjectContext;
        
        // Store selected Role in selectedRole property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];  //或是用sender也可以，didSelectRowAtIndexPath傳來的是indexPath
        //可以直接用indexPath找到CoreData裡的實際物件，然後pass給Detail頁
        self.selectedDay = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"Passing selected Day (%@) to ReceiptsCDTVC", self.selectedDay.name);
        receiptsCDTVC.currentDay=self.selectedDay;
    }else if ([segue.identifier isEqualToString:@"Add Day Segue"]){
        NSLog(@"Setting DaysCDTVC as a delegate of AddDayTVC");
        AddDayTVC *addDayTVC=segue.destinationViewController;
        addDayTVC.delegate=self;
        
        addDayTVC.managedObjectContext=self.managedObjectContext;
        addDayTVC.currentTrip=self.currentTrip;
        
    }else if([segue.identifier isEqualToString:@"Day Detail Segue"]){
        NSLog(@"Setting DaysCDTVC as a delegate of DayDetailTVC");
        DayDetailTVC * dayDetailTVC=segue.destinationViewController;
        dayDetailTVC.delegate=self;
        dayDetailTVC.managedObjectContext=self.managedObjectContext;
        
        //NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
        NSIndexPath *indexPath=(NSIndexPath *)sender;   //因為在accessoryButtonTappedForRowWithIndexPath事件裡傳indexPath過來
        self.selectedDay=[self.fetchedResultsController objectAtIndexPath:indexPath];
        dayDetailTVC.day=self.selectedDay;
        
    }
}

#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Receipts List Segue" sender:indexPath];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Day Detail Segue" sender:indexPath];
}
- (void)navigationTitleTapOnce:(UIGestureRecognizer *)gesture{
    NSLog(@"navigationBarTapOnce");
    NSOrderedSet *currencies=[self.currentTrip getAllCurrencies];
    if ([currencies count]<=self.currencyIndex+1) {
        self.currencyIndex=0;
    }else{
        self.currencyIndex++;
    }
    self.showingCurrency=currencies[self.currencyIndex];
    [self.tableView reloadData];
}

#pragma mark - Delegation
-(void)theSaveButtonOnTheAddReceiptWasTapped:(AddReceiptTVC *)controller{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
    
}
-(void)theSaveButtonOnTheAddDayWasTapped:(AddDayTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)theSaveButtonOnTheDayDetailTVCWasTapped:(DayDetailTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
