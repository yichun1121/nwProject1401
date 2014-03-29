//
//  AddReceiptTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/18.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddReceiptTVC.h"
#import "Trip.h"
#import "TripDaysTVC.h"
#import "DayCurrency.h"
#import "Currency.h"

#define ktimePicker 6  //timePicker在第8行
/*! 展開Picker後的Cell高度
 */
static NSInteger sPickerCellHeight=162;

@interface AddReceiptTVC ()
@property NSDateFormatter *dateFormatter;
@property NSDateFormatter *timeFormatter;
@property NSDateFormatter *dateTimeFormatter;
@property Currency *currentCurrency;
@property (weak, nonatomic) IBOutlet UITableViewCell *currency;
@property (weak, nonatomic) IBOutlet UILabel *currencySign;

@property NSIndexPath * actingCellIndexPath;
@end

@implementation AddReceiptTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize dateFormatter=_dateFormatter;
@synthesize timeFormatter=_timeFormatter;
@synthesize dateTimeFormatter=_dateTimeFormatter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.timeFormatter=[[NSDateFormatter alloc]init];
    self.dateTimeFormatter=[[NSDateFormatter alloc]init];
    
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    self.timeFormatter.dateFormat=@"HH:mm";
    self.dateTimeFormatter.dateFormat=[NSString stringWithFormat:@"%@ %@",self.dateFormatter.dateFormat,self.timeFormatter.dateFormat];
    
    //設定UITextFeild的delegate
    self.desc.delegate=self;
    self.totalPrice.delegate=self;
    
    //設定頁面初始的顯示狀態
    [self showDefaultDateValue];
    [self setAllCurrencyWithCurrency:self.currentTrip.mainCurrency];
}
/*! 顯示預設日期，如果沒有指定的話預設顯示當天的Date和Time
 */
-(void)showDefaultDateValue{
    if (self.selectedDayString) {
        self.dateCell.detailTextLabel.text=self.selectedDayString;
    }else{
        self.dateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:[NSDate date]];
        self.selectedDayString=self.dateCell.detailTextLabel.text;
    }
    self.timeCell.detailTextLabel.text=[self.timeFormatter stringFromDate:[NSDate date]];
}
/*!設定currentCurrency還有頁面相關顯示
 */
-(void)setAllCurrencyWithCurrency:(Currency *)currency{
    self.currentCurrency=currency;
    self.currency.detailTextLabel.text=currency.standardSign;
    self.currencySign.text=currency.sign;
}

#pragma mark - 事件
-(IBAction)save:(id)sender{
    Receipt *receipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt"
                                                     inManagedObjectContext:self.managedObjectContext];
    
    Day *selectedDay=[self getTripDayByDate:self.selectedDayString];
    receipt.desc = self.desc.text;
    receipt.total=[NSNumber numberWithDouble:[self.totalPrice.text doubleValue]];
    receipt.time=[self.timeFormatter dateFromString:self.timeCell.detailTextLabel.text];
    receipt.day=selectedDay;
    
    receipt.dayCurrency=[self getDayCurrencyWithTripDay:selectedDay Currency:self.currentCurrency];
    
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Save new Receipt in AddReceiptTVC");
    [self.delegate theSaveButtonOnTheAddReceiptWasTapped:self];
    
}
- (IBAction)pickerChanged:(UIDatePicker *)sender {
    if (sender==self.timePicker) {
        self.timeCell.detailTextLabel.text=[self.timeFormatter stringFromDate: sender.date];
    }
//    else if(sender==self.datePicker){
//        NSString *dateString=[self.dateFormatter stringFromDate:sender.date];
//        self.dateCell.detailTextLabel.text=dateString;
//        self.selectedDayString=dateString;
//    }

}

#pragma mark - Table view data source
#pragma mark 負責長cell的高度，也在這設定actingPicker（每次會因為tableView beginUpdates和endUpdates重畫）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result=self.tableView.rowHeight;
    if (indexPath.row==ktimePicker) {
        if (indexPath.row-1==self.actingCellIndexPath.row) {
            /*如果正在執行的actingDateCell是正在畫的這行的上一行
             代表點選了dateCell，而現在正要把picker展開回原始高度。*/
            result=sPickerCellHeight;
        }else{
            result=0;
        }
    }
    return result;
}

#pragma mark - ▣ CRUD_TripDay+DayCurrency
/*!以yyyy/MM/dd的日期字串取得本旅程中對應的Day，如果沒有這天，回傳nil
 */
-(Day *)getTripDayByDate:(NSString *)dateString{
    NSLog(@"Find the trip day:%@ in the current trip.",dateString);
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSDate *date= [self.dateFormatter dateFromString:dateString];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(date = %@) AND (inTrip=%@)", date,self.currentTrip];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        return [self createDayInCurrentTripByDateString:date];
    } else {
        return objects[0];
    }
}
-(Day *)createDayInCurrentTripByDateString:(NSDate *)date{
    NSLog(@"Create the new day in the current trip.");
    
    Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                             inManagedObjectContext:self.managedObjectContext];
    day.name=@"";
    day.date=date;
    day.inTrip=self.currentTrip;
    
    NSLog(@"Create new Day in AddReceiptTVC");
    
    [self.managedObjectContext save:nil];  // write to database
    return day;
}
-(DayCurrency *)getDayCurrencyWithTripDay:(Day *)tripDay Currency:(Currency *)currency{
    //    //-----Date Formatter----------
    //    NSDateFormatter *dateFormatter;
    //    dateFormatter=[[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat=@"yyyy/MM/dd";
    
    NSString *dateString=[ self.dateFormatter stringFromDate:tripDay.date];
    NSLog(@"Find the DayCurrency in trip:%@, date:%@, currency:%@ ...",tripDay.inTrip.name,dateString,currency.standardSign);
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"DayCurrency" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(tripDay = %@) AND (currency=%@)", tripDay,currency];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"Can't Find.");
        return [self createDayCurrencyWithTripDay:tripDay Currency:currency];
    } else {
        NSLog(@"Done.");
        return objects[0];
    }
}
-(DayCurrency *)createDayCurrencyWithTripDay:(Day *)tripDay Currency:(Currency *)currency{
    NSLog(@"Create the new DayCurrency");
    
    DayCurrency *dayCurrency = [NSEntityDescription insertNewObjectForEntityForName:@"DayCurrency"
                                                             inManagedObjectContext:self.managedObjectContext];
    dayCurrency.tripDay=tripDay;
    dayCurrency.currency=currency;
    
    NSLog(@"Create new DayCurrency in DayCurrency+FindOneOrCreateNew");
    
    [self.managedObjectContext save:nil];  // write to database
    return dayCurrency;
}


#pragma mark - ➤ Navigation：Segue Settings
// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Trip Day Segue"]) {
        NSLog(@"Setting AddReceiptTVC as a delegate of TripDaysTVC...");
        TripDaysTVC *TripDaysTVC=segue.destinationViewController;
        TripDaysTVC.delegate=self;
        
        TripDaysTVC.managedObjectContext=self.managedObjectContext;
        
        //可以直接用indexPath找到CoreData裡的實際物件，然後pass給Detail頁
        TripDaysTVC.currentTrip=self.currentTrip;
        TripDaysTVC.selectedDayString=self.selectedDayString;
    }else if([segue.identifier isEqualToString:@"Currency Segue"]){
        NSLog(@"Setting CurrencyCDTVC as a delegate of TripDaysTVC...");
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
-(void)dayWasSelectedInTripDaysTVC:(TripDaysTVC *)controller{
    self.selectedDayString=controller.selectedDayString;
    self.dateCell.detailTextLabel.text=controller.selectedDayString;
    //self.datePicker.date=[self.dateFormatter dateFromString:controller.selectedDayString];
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)currencyWasSelectedInCurrencyCDTVC:(CurrencyCDTVC *)controller{
    [self setAllCurrencyWithCurrency:controller.selectedCurrency];
    [controller.navigationController popViewControllerAnimated:YES];
}
#pragma mark 監測點選row時候的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO:不知道為什麼要用row判斷，不用row會錯
    BOOL hasBeTapped=(indexPath.row==self.actingCellIndexPath.row);
    UITableViewCell *clickedCell=[self.tableView cellForRowAtIndexPath:indexPath];
    //if (clickedCell==self.timeCell||clickedCell==self.dateCell) {
    if (clickedCell==self.timeCell) {
        //如果剛剛點了同個DateCell的話就代表想要關掉picker，故把actingDateCellIndexPath設nil
        if (hasBeTapped) {
            self.actingCellIndexPath=nil;
        }else{
            self.actingCellIndexPath=indexPath;
        }
        // 為了讓picker展開或關閉，需要重新整理tableView，beginUpdates和endUpdates
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}
@end
