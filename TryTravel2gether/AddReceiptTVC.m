//
//  AddReceiptTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/18.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddReceiptTVC.h"
#import "Trip.h"
#import "TripDaysCDTVC.h"

#define kdatePicker 5  //startPicker在第5行
#define ktimePicker 7  //startPicker在第7行
/*! 展開Picker後的Cell高度
 */
static NSInteger sPickerCellHeight=162;

@interface AddReceiptTVC ()
@property NSDateFormatter *dateFormatter;
@property NSDateFormatter *timeFormatter;
@property NSDateFormatter *dateTimeFormatter;

@property NSIndexPath * actingDateCellIndexPath;
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
}
/*! 如果沒有指定的話預設顯示當天的Date和Time
 */
-(void)showDefaultDateValue{
    if (self.selectedDayString) {
        self.dateCell.textLabel.text=self.selectedDayString;
    }else{
        self.dateCell.textLabel.text=[self.dateFormatter stringFromDate:[NSDate date]];
        self.selectedDayString=self.dateCell.textLabel.text;
    }
    self.timeCell.detailTextLabel.text=[self.timeFormatter stringFromDate:[NSDate date]];
}
-(IBAction)save:(id)sender{
    NSLog(@"Telling the AddReceiptTVC Delegate that Save was tapped on the AddReceiptTVC");
    
    Receipt *receipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt"
                                               inManagedObjectContext:self.managedObjectContext];
    
    Day *selectedDay=[self getTripDayByDate:self.selectedDayString];
    receipt.desc = self.desc.text;
    receipt.total=[NSNumber numberWithDouble:[self.totalPrice.text doubleValue]];
    receipt.time=[self.timeFormatter dateFromString:self.timeCell.detailTextLabel.text];
    receipt.day=selectedDay;

    NSLog(@"Save new Receipt in AddReceiptTVC");
    
    [self.managedObjectContext save:nil];  // write to database
    [self.delegate theSaveButtonOnTheAddReceiptWasTapped:self];
    
}
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

#pragma mark - PickerChange事件

- (IBAction)pickerChanged:(UIDatePicker *)sender {
    if (sender==self.timePicker) {
        self.timeCell.detailTextLabel.text=[self.timeFormatter stringFromDate: sender.date];
    }else if(sender==self.datePicker){
        NSString *dateString=[self.dateFormatter stringFromDate:sender.date];
        self.dateCell.textLabel.text=dateString;
        self.selectedDayString=dateString;
    }

}

#pragma mark - 每次點選row的時候會做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO:不知道為什麼要用row判斷，不用row會錯
    BOOL hasBeTapped=(indexPath.row==self.actingDateCellIndexPath.row);
    UITableViewCell *clickedCell=[self.tableView cellForRowAtIndexPath:indexPath];
    if (clickedCell==self.timeCell||clickedCell==self.dateCell) {
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
#pragma mark - Table view data source
#pragma mark 負責長cell的高度，也在這設定actingPicker（每次會因為tableView beginUpdates和endUpdates重畫）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result=self.tableView.rowHeight;
    if (indexPath.row==ktimePicker||indexPath.row==kdatePicker) {
        if (indexPath.row-1==self.actingDateCellIndexPath.row) {
            /*如果正在執行的actingDateCell是正在畫的這行的上一行
             代表點選了dateCell，而現在正要把picker展開回原始高度。*/
            result=sPickerCellHeight;
        }else{
            result=0;
        }
    }
    return result;
}

#pragma mark - Segue Settings

// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Trip Day Segue"]) {
        NSLog(@"Setting AddReceiptTVC as a delegate of TripDaysCDTVC");
        TripDaysCDTVC *tripDaysCDTVC=segue.destinationViewController;
        tripDaysCDTVC.delegate=self;
        
        tripDaysCDTVC.managedObjectContext=self.managedObjectContext;
        
        //可以直接用indexPath找到CoreData裡的實際物件，然後pass給Detail頁
        tripDaysCDTVC.currentTrip=self.currentTrip;
        tripDaysCDTVC.selectedDayString=self.selectedDayString;
    }
}

#pragma mark - delegation
#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)dayWasSelectedInTripDaysCDTVC:(TripDaysCDTVC *)controller{
    self.selectedDayString=controller.selectedDayString;
    self.dateCell.textLabel.text=controller.selectedDayString;
    self.datePicker.date=[self.dateFormatter dateFromString:controller.selectedDayString];
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
