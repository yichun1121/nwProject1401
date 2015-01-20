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
#import "Trip+Currency.h"
#import "Currency+Decimal.h"
#import "PersonalSharedTVC.h"

@interface ShareMainPageCDTVC ()
@property (weak, nonatomic) IBOutlet UILabel *tripName;
@property (weak, nonatomic) IBOutlet UILabel *tripDate;
@property (strong,nonatomic)NSDateFormatter * dateFormatter;
@property BOOL interstitialShow;
@property (nonatomic) Currency *showingCurrency;
@property int currencyIndex;
@property (nonatomic)  UILabel *lblNavTitle;
@end

@implementation ShareMainPageCDTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize currentTrip=_currentTrip;
@synthesize interstitialShow = _interstitialShow;
@synthesize showingCurrency=_showingCurrency;
@synthesize lblNavTitle=_lblNavTitle;
#pragma mark - lazy instantiation
-(Currency *)showingCurrency{
    if(!_showingCurrency){
        _showingCurrency=self.currentTrip.mainCurrency;
        self.currencyIndex=0;
    }
    self.lblNavTitle.text=[NSString stringWithFormat:@"%@ - %@",_showingCurrency.standardSign,self.currentTrip.name];
    return _showingCurrency;
}
-(UILabel *)lblNavTitle{
    if (!_lblNavTitle) {
        _lblNavTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
        _lblNavTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lblNavTitle;
}
-(Trip *)currentTrip{
    if (!_currentTrip) {
        _currentTrip=[self getDefaultTrip];
    }
    return _currentTrip;
}
-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter=[[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat=@"yyyy/MM/dd";
    }
    return _dateFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.editing=YES;
    
    //-----註冊CustomCell----------
    //UINib* myCellNib = [UINib nibWithNibName:@"NWCustCellTitleSubDetail" bundle:nil];
    //[self.tableView registerNib:myCellNib forCellReuseIdentifier:@"Cell"];
    
    //-----設定下一頁時的back button的字（避免本頁的title太長）-----------
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ShareMain",@"PageTitle") style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //-----設定title + 註冊手勢-----------
    //    self.navigationItem.title=self.currentTrip.name;
    UITapGestureRecognizer* tapRecon = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(navigationTitleTapOnce:)];
    tapRecon.numberOfTapsRequired = 1;
    //    [self.navigationItem.titleView setUserInteractionEnabled:YES];
    //    [self.navigationItem.titleView addGestureRecognizer:tapRecon];
    [self.lblNavTitle addGestureRecognizer:tapRecon];
    [self.lblNavTitle setUserInteractionEnabled:YES];
    self.navigationItem.titleView=self.lblNavTitle;
}


// 需要插頁廣告的時候把下面區塊的註解取消
// 還要把GoogleAdMobileLibs資料夾裝回來
//#pragma mark GADInterstitialDelegate implementation
//- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
//    NSLog(@"Received ad successfully");
//    [_interstitial presentFromRootViewController:self];
//}
//
//- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
//}
//
//
//#pragma mark GADRequest generation
//- (GADRequest *)request {
//    GADRequest *request = [GADRequest request];
//    
//    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
//    // you want to receive test ads.
//    request.testDevices = @[
//                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
//                            // the console when the app is launched.
//                            GAD_SIMULATOR_ID
//                            ];
//    return request;
//}
//



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.lblNavTitle.text=self.currentTrip.name;
    self.showingCurrency=self.currentTrip.mainCurrency;
    self.currencyIndex=0;

    // 需要插頁廣告的時候把下面區塊的註解取消
    // 還要把GoogleAdMobileLibs資料夾裝回來
//    if (!self.interstitialShow) {
//        //-----google AdMob插頁廣告----------
//        _interstitial = [[GADInterstitial alloc] init];
//        _interstitial.delegate = self;
//        _interstitial.adUnitID = @"ca-app-pub-1412142430031740/6151567713";
//        [_interstitial loadRequest:[self request]];
//        self.interstitialShow = TRUE;
//    }else{
//       self.interstitialShow = FALSE;
//    }


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
    NSString *totalPriceString=[self.showingCurrency.numberFormatter stringFromNumber: [guy totalExpendUsingCurrency:self.showingCurrency]];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",self.showingCurrency.sign, totalPriceString];
//    cell.detailTextLabel.text=guy;
    
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
    }else if([segue.identifier isEqualToString:@"Show Personal Shared From Share Main"]){
        PersonalSharedTVC *personalTVC=[segue destinationViewController];
        personalTVC.managedObjectContext=self.managedObjectContext;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GuyInTrip *guy=[self.fetchedResultsController objectAtIndexPath:indexPath];
        personalTVC.currentGuy=guy;
    }
    
}


#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (IBAction)selectTripButton:(UIButton *)sender {[self performSegueWithIdentifier:@"Select Trip Segue From Share Main Page" sender:sender];
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
-(void)theTripCellOnSelectTripCDTVCWasTapped:(SelectTripCDTVC *)controller{
    if (controller.selectedTrip!=self.currentTrip) {
        self.currentTrip=controller.selectedTrip;
        [self performFetch];
        [self showTripInfo:controller.selectedTrip];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
