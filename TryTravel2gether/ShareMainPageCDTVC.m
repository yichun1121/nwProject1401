//
//  ShareMainPage.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/23.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "ShareMainPageCDTVC.h"
#import "SelectTripCDTVC.h"
#import "GuyInTrip+Expend.h"
@interface ShareMainPageCDTVC ()
@property (weak, nonatomic) IBOutlet UILabel *tripName;
@property (weak, nonatomic) IBOutlet UILabel *tripDate;
@property (strong,nonatomic)NSDateFormatter * dateFormatter;
@end

@implementation ShareMainPageCDTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize currentTrip=_currentTrip;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.editing=YES;
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    
    
    //-----註冊CustomCell----------
    //UINib* myCellNib = [UINib nibWithNibName:@"NWCustCellTitleSubDetail" bundle:nil];
    //[self.tableView registerNib:myCellNib forCellReuseIdentifier:@"Cell"];
    
    //-----設定下一頁時的back button的字（避免本頁的title太長）-----------
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ShareMain" style:UIBarButtonItemStylePlain target:nil action:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.currentTrip) {
        self.currentTrip=[self getDefaultTrip];
    }
    [self showTripInfo:self.currentTrip];
    
    [self setupFetchedResultController];
}

#pragma mark - FetchedResultsController

-(void)setupFetchedResultController{
    
    NSString *entityName=@"GuyInTrip";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    request.predicate=[NSPredicate predicateWithFormat:@"inTrip=%@",self.currentTrip];
    
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"guy"
                                                                                    ascending:YES
                                                                                     selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                     managedObjectContext:self.managedObjectContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    [self performFetch];
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    GuyInTrip *guy=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=guy.guy.name;
    cell.detailTextLabel.text=guy.totalExpendWithMainCurrencySign;
    
    return cell;
}

-(Trip *)getDefaultTrip{
    
    NSLog(@"Finding the Last Trip... @%@",self.class);
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"(trip = %@) AND (category=%@)", trip,category];
    //[request setPredicate:pred];
    
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"startDate"
                                                                                    ascending:NO
                                                                                     selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"Can't Find.");
        return nil;
    } else {
        NSLog(@"Done.");
        return objects[0];
    }
}
-(void)showTripInfo:(Trip *)trip{
    NSString *strStartDate=[self.dateFormatter stringFromDate:trip.startDate];
    NSString *strEndDate=[self.dateFormatter stringFromDate:trip.endDate];
    self.tripDate.text=[NSString stringWithFormat:@"%@-%@",strStartDate,strEndDate];
    self.navigationItem.title=trip.name;
}
#pragma mark - ➤ Navigation：Segue Settings
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Select Trip Segue From Share Main Page"]) {
        SelectTripCDTVC *selectTripCDTVC=[segue destinationViewController];
        selectTripCDTVC.managedObjectContext=self.managedObjectContext;
        selectTripCDTVC.selectedTrip=self.currentTrip;
        selectTripCDTVC.delegate=self;
    }
    
}


#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (IBAction)selectTripButton:(UIButton *)sender {[self performSegueWithIdentifier:@"Select Trip Segue From Share Main Page" sender:sender];
}

#pragma mark - Delegation
-(void)theTripCellOnSelectTripCDTVCWasTapped:(SelectTripCDTVC *)controller{
    if (controller.selectedTrip!=self.currentTrip) {
        self.currentTrip=controller.selectedTrip;
        [self performFetch];
        [self showTripInfo:controller.selectedTrip];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
