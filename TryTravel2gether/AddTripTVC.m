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
#import "SelectGuysCDTVC.h"
#import "Group.h"
#import "Guy.h"
#import "GuyInTrip.h"
#import "NWKeyboardUtils.h"
#import "NWPickerUtils.h"
#import "NWUIScrollViewMovePostition.h"
#import "Trip+System.h"

@interface AddTripTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSDateFormatter *dateFormatter_GMT;
@property (weak, nonatomic) IBOutlet UITableViewCell *currency;
@property (strong,nonatomic) Currency *currentCurrency;
@property (strong, nonatomic) UIDatePicker *endPicker;
@property (strong, nonatomic) UIDatePicker *startPicker;
@end

@implementation AddTripTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize dateFormatter=_dateFormatter;
@synthesize dateFormatter_GMT=_dateFormatter_GMT;
@synthesize selectedGuys=_selectedGuys;
@synthesize fetchedResultsController=_fetchedResultsController;

#pragma mark - lazy instantiation
-(UIDatePicker *) startPicker
{
    if (!_startPicker) {
        _startPicker = [[UIDatePicker alloc] init];
        _startPicker.datePickerMode=UIDatePickerModeDate;
        _startPicker.backgroundColor=[UIColor whiteColor];
    }
    return _startPicker;
}

-(UIDatePicker *) endPicker
{
    if (!_endPicker) {
        _endPicker = [[UIDatePicker alloc] init];
        _endPicker.datePickerMode=UIDatePickerModeDate;
        _endPicker.backgroundColor=[UIColor whiteColor];
    }
    return _endPicker;
}

-(NSDateFormatter *)dateFormatter_GMT{
    if (!_dateFormatter_GMT) {
        _dateFormatter_GMT=[[NSDateFormatter alloc]init];
        _dateFormatter_GMT.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        self.dateFormatter_GMT.dateFormat=@"yyyy/MM/dd";
    }
    return _dateFormatter_GMT;
}
-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }
    return _dateFormatter;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
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
    
    //-----設定參與者，以及顯示人數
//    self.guysCell.textLabel.text=@"Select Guys";
    self.guysCell.textLabel.text=NSLocalizedString(@"SelectGuys", @"ActiveTips");
    int guyscount=(int)[self.selectedGuys count];
    self.guysCell.detailTextLabel.text=[NSString stringWithFormat:@"%i",guyscount];
    self.selectedGuys=[NSSet new];
}
-(void) save:(id)sender{
    
    NSLog(@"Telling the AddTripTVC Delegate that Save was tapped on the AddTripTVC");
    
    Trip *trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip"
                                               inManagedObjectContext:self.managedObjectContext];
    
    trip.name = self.tripName.text;
    trip.startDate=[self.dateFormatter_GMT dateFromString: self.startDate.detailTextLabel.text];
    trip.endDate=[self.dateFormatter_GMT dateFromString:self.endDate.detailTextLabel.text];
    trip.days=[self creatDefaultDaysFromStartDate:trip.startDate ToEndDate:trip.endDate];
    trip.mainCurrency=self.currentCurrency;
    trip.tripIndex=[Trip getNextTripIndex];
    [self.managedObjectContext save:nil];  // write to database
    [self createDefaultGroupWithGuy:self.selectedGuys InCurrentTrip:trip];
    [self createDefaultGroupWithShareTogetherInCurrentTrip:trip];
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheAddTripTVCWasTapped:self];
}

#pragma mark - 每次點選row的時候會做的事
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //每次Segue時清除所有的picker
    [NWPickerUtils dismissPicker:self.tableView];
    //點選Segue時關閉鍵盤
    [NWKeyboardUtils  dismissKeyboard4TextField:self.view];
    
    bool hasBeTapped=(indexPath.row==self.actingDateCellIndexPath.row);
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (clickCell==self.startDate||clickCell==self.endDate) {
        //如果剛剛點了同個DateCell的話就代表想要關掉picker，故把actingDateCellIndexPath設nil
        if (hasBeTapped) {
            self.actingDateCellIndexPath = nil;
        }else{
            UIDatePicker *targetPicker = nil;
            
            if (clickCell==self.startDate) {
                targetPicker = self.startPicker;
             }else{
                 targetPicker = self.endPicker;
            }
            
            self.actingDateCellIndexPath = indexPath;
            [NWPickerUtils setPickerInTableView:targetPicker tableView:tableView didSelectRowAtIndexPath:indexPath];

            [self.view addSubview:targetPicker];
            [NWUIScrollViewMovePostition autoContentOffsetToTableViewCenter:tableView didSelectRowAtIndexPath:indexPath withTagItemSize:[targetPicker sizeThatFits:CGSizeZero]];
            [targetPicker addTarget:self
                                 action:@selector(pickerChanged:)
                       forControlEvents:UIControlEventValueChanged];
        }
    }else{
         self.actingDateCellIndexPath=nil;
    }
}


#pragma mark - Picker的事件
-(void)pickerChanged:(UIDatePicker *) targetPicker{


    //目標DateCell存在時，把picker的日期寫進cell裡
        UITableViewCell *targetDateCell=[self.tableView cellForRowAtIndexPath:self.actingDateCellIndexPath];
        targetDateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:targetPicker.date];
        //重新設定picker規則
        [self resetPickersRole];
   
}
//因為view didload的時候沒有限制min和max，等到第一個picker change之後才會設定（和tripDetail不一樣）
#pragma mark - 設定Picker規則(end>=start)
-(void)resetPickersRole{
    UITableViewCell *actingDateCell=[self.tableView cellForRowAtIndexPath:self.actingDateCellIndexPath];
    if (actingDateCell==self.startDate) {
    //如果是startPicker，改end的設定
        //self.endPicker.minimumDate=self.startPicker.date;
        if ([self.endPicker.date compare:self.startPicker.date] == NSOrderedAscending) {
            self.endPicker.date=self.startPicker.date;
            self.endDate.detailTextLabel.text=[self.dateFormatter stringFromDate:self.endPicker.date];
        }
    }else{
    //否則就是改start的設定
        //self.startPicker.maximumDate=self.endPicker.date;
        if ([self.startPicker.date compare:self.endPicker.date] == NSOrderedDescending) {
            self.startPicker.date=self.endPicker.date;
            self.startDate.detailTextLabel.text=[self.dateFormatter stringFromDate:self.startPicker.date];
        }
    }
}


/*!建立某時間區間的Day們，回傳NSSet*/
-(NSSet *)creatDefaultDaysFromStartDate:(NSDate *)startDate ToEndDate:(NSDate *)endDate{
    NSMutableSet *days;
    days=[[NSMutableSet alloc]init];
    
    //建立日期原件（dateComponents）
    NSDateComponents *dateComponents=[[NSDateComponents alloc]init];
    
    //NSString *strDateStart=[self.dateFormatter stringFromDate:startDate];
    
    startDate=[self.dateFormatter_GMT dateFromString:[self.dateFormatter stringFromDate:startDate]];
    endDate=[self.dateFormatter_GMT dateFromString:[self.dateFormatter stringFromDate:endDate]];
    
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

#pragma mark - ➤ Navigation：Segue Settings
// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //每次Segue時清除所有的picker
    [NWPickerUtils dismissPicker:self.tableView];
    //點選Segue時關閉鍵盤
    [NWKeyboardUtils  dismissKeyboard4TextField:self.view];
    
    if([segue.identifier isEqualToString:@"Currency Segue"]){
        NSLog(@"Setting AddTripTVC as a delegate of CurrencyCDTVC");
        CurrencyCDTVC *currencyCDTVC=segue.destinationViewController;
        currencyCDTVC.delegate=self;
        currencyCDTVC.managedObjectContext=self.managedObjectContext;
        currencyCDTVC.selectedCurrency=self.currentCurrency;
    }else if([segue.identifier isEqualToString:@"Select Guy Segue"]){
        NSLog(@"Setting AddTripTVC as a delegate of SelectGuyTVC");
        SelectGuysCDTVC *selectGuysCDTVC=segue.destinationViewController;
        selectGuysCDTVC.delegate=self;
        selectGuysCDTVC.managedObjectContext=self.managedObjectContext;
        selectGuysCDTVC.selectedGuys=[self.selectedGuys mutableCopy];
        
    }
}


#pragma mark - Group&GuyInTrip
//把每個參與者都視為一個Group
-(void)createDefaultGroupWithGuy:(NSSet *)selectedGuy InCurrentTrip:(Trip *)trip{
    
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
        guyInTrip.groups=[NSSet setWithObject:group];
        guyInTrip.guy=guy;
        
        [self.managedObjectContext save:nil];
        
    }
}

//所有參與者平均分攤預設為一組
-(void)createDefaultGroupWithShareTogetherInCurrentTrip:(Trip *)trip{
    
    int guyscount=(int)[trip.guysInTrip count];
    
    //參與者為兩人以上才有設立share_together群組的必要
    if (guyscount>1) {
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                                 inManagedObjectContext:self.managedObjectContext];
    group.name=[NSString stringWithFormat:@"Share_All"];
    group.inTrip=trip;
    group.guysInTrip=trip.guysInTrip;
    [self.managedObjectContext save:nil];
    }    
}


#pragma mark - delegation
#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//開始編輯textField時做的事
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //清除所有的picker
    [NWPickerUtils dismissPicker:self.tableView];
}

-(void)currencyWasSelectedInCurrencyCDTVC:(CurrencyCDTVC *)controller{
    self.currentCurrency=controller.selectedCurrency;
    self.currency.detailTextLabel.text=self.currentCurrency.standardSign;
    [controller.navigationController popViewControllerAnimated:YES];
}

-(void)guyWasSelectedInSelectGuysCDTVC:(SelectGuysCDTVC *)controller{
    self.selectedGuys=controller.selectedGuys;
    int guyscount=(int)[self.selectedGuys count];
    self.guysCell.detailTextLabel.text=[NSString stringWithFormat:@"%i Guys",guyscount];
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)theSaveButtonOnTheSelectPaymentWasTapped:(SelectPaymentCDTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}

@end