//
//  AddTripTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddTripTVC.h"
#import "Day.h"
#import "CurrencyCDTVC.h"
#import "nwUserSettings.h"

#define kStartPicker 2  //startPicker在第2行
#define kEndPicker 4    //endPicker在第4行
/*! 展開Picker後的Cell高度
 */
static NSInteger sPickerCellHeight=162;

@interface AddTripTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UITableViewCell *currency;
@property (strong,nonatomic) Currency *currentCurrency;
@end

@implementation AddTripTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize dateFormatter=_dateFormatter;

-(void)viewDidLoad{
    [super viewDidLoad];

    //-----Date Formatter----------
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    //-----顯示當天的日期-----------
    self.startDate.detailTextLabel.text= [self.dateFormatter stringFromDate:[NSDate date]];
    self.endDate.detailTextLabel.text=[self.dateFormatter stringFromDate:[NSDate date]];
    
    //-----設定textField的delegate，讓自己監控textFeild的狀況
    self.tripName.delegate=self;
    
    //-----設定幣別，以及顯示幣別
    NWUserSettings *userSetting=[NWUserSettings new];
    userSetting.managedObjectContext=self.managedObjectContext;
    self.currentCurrency=[userSetting getDefaultCurrency];
    self.currency.detailTextLabel.text=self.currentCurrency.standardSign;
}
-(void) save:(id)sender{
    NSLog(@"Telling the AddTripTVC Delegate that Save was tapped on the AddTripTVC");
    
    Trip *trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip"
                                               inManagedObjectContext:self.managedObjectContext];
    
    trip.name = self.tripName.text;
    trip.startDate=[self.dateFormatter dateFromString: self.startDate.detailTextLabel.text];
    trip.endDate=[self.dateFormatter dateFromString:self.endDate.detailTextLabel.text];
    trip.days=[self creatDefaultDaysFromStartDate:trip.startDate ToEndDate:trip.endDate];
    trip.mainCurrency=self.currentCurrency;
    
    
    [self.managedObjectContext save:nil];  // write to database
    
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheAddTripTVCWasTapped:self];
}

#pragma mark 負責長cell的高度，也在這設定actingPicker（每次會因為tableView beginUpdates和endUpdates重畫）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result=self.tableView.rowHeight;
    if (indexPath.row==kStartPicker||indexPath.row==kEndPicker) {
        if (indexPath.row-1==self.actingDateCellIndexPath.row) {
            /*如果正在執行的actingDateCell是正在畫的這行的上一行
             代表點選了dateCell，而現在正要把picker展開回原始高度。*/
            self.actingPickerCellIndexPath=indexPath;
            result=sPickerCellHeight;
        }else{
            /*否則只要是pickerCell高度就會縮成0。
             */
            result=0;
        }
    }
    return result;
}

#pragma mark - 每次點選row的時候會做的事
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO:不知道為什麼要用row判斷，不用row會錯
    bool hasBeTapped=(indexPath.row==self.actingDateCellIndexPath.row);
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    if (clickCell==self.startDate||clickCell==self.endDate) {
        //如果剛剛點了同個DateCell的話就代表想要關掉picker，故把actingDateCellIndexPath設nil
        if (hasBeTapped) {
            self.actingDateCellIndexPath=nil;
        }else{
            self.actingDateCellIndexPath=indexPath;
        }
        // 為了讓picker展開或關閉，需要重新整理tableView，beginUpdates和endUpdates
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}


#pragma mark - Picker的事件
-(IBAction)pickerChanged:(id)sender{
    UIDatePicker *targetPicker=sender;
    if (self.actingDateCellIndexPath) {
    //目標DateCell存在時，把picker的日期寫進cell裡
        UITableViewCell *targetDateCell=[self.tableView cellForRowAtIndexPath:self.actingDateCellIndexPath];
        targetDateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:targetPicker.date];
        //重新設定picker規則
        [self resetPickersRole];
    }else{
        NSLog(@"【Error】missing actingDateCellIndexPath in AddTripTVC.");
    }
}
//因為view didload的時候沒有限制min和max，等到第一個picker change之後才會設定（和tripDetail不一樣）
#pragma mark - 設定Picker規則(end>=start)
-(void)resetPickersRole{
    if (self.actingPickerCellIndexPath.row==kStartPicker) {
    //如果是startPicker，改end的設定
        self.endPicker.minimumDate=self.startPicker.date;
        self.endDate.detailTextLabel.text=[self.dateFormatter stringFromDate:self.endPicker.date];
    }else{
    //否則就是改start的設定
        self.startPicker.maximumDate=self.endPicker.date;
        self.startDate.detailTextLabel.text=[self.dateFormatter stringFromDate:self.startPicker.date];
    }
}


/*!建立某時間區間的Day們，回傳NSSet*/
-(NSSet *)creatDefaultDaysFromStartDate:(NSDate *)startDate ToEndDate:(NSDate *)endDate{
    NSMutableSet *days;
    days=[[NSMutableSet alloc]init];
    
    //建立日期原件（dateComponents）
    NSDateComponents *dateComponents=[[NSDateComponents alloc]init];
    
    //算出起始和結束期間共需幾天
    //double dayCount= ([endDate timeIntervalSinceDate:startDate]/86400)+1;
    int dayCount= (int)[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:startDate toDate:endDate options:0].day+1;
    
    for (int i=0; i<dayCount; i++) {
        Day *day= [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                                inManagedObjectContext:self.managedObjectContext];
        day.dayIndex=[NSNumber numberWithInt:i+1];
        day.name=@"";   //[NSString stringWithFormat:@"Day %@",day.dayIndex];
        dateComponents.day=i;   //一次加i天
        day.date=[[NSCalendar currentCalendar]dateByAddingComponents:dateComponents toDate:startDate options:0];    //利用dateComponents的設定改變日期，一次加一個dateComponents
        [days addObject:day];
    }
    
    return days;
}


// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Currency Segue"]){
        NSLog(@"Setting AddTripTVC as a delegate of CurrencyCDTVC");
        CurrencyCDTVC *currencyCDTVC=segue.destinationViewController;
        
        currencyCDTVC.delegate=self;
        currencyCDTVC.managedObjectContext=self.managedObjectContext;
        currencyCDTVC.selectedCurrency=self.currentCurrency;
    }
}

#pragma mark - delegation
#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)currencyWasSelectedInCurrencyCDTVC:(CurrencyCDTVC *)controller{
    self.currentCurrency=controller.selectedCurrency;
    self.currency.detailTextLabel.text=self.currentCurrency.standardSign;
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
