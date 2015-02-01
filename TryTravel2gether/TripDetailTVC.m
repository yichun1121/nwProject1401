//
//  TripDetailCDTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripDetailTVC.h"
#import "GuyInTrip.h"
#import "Group.h"
#import "Guy.h"
#import "GroupAndGuyInTripCDTVC.h"
#import "Trip+Group.h"
#import "NWKeyboardUtils.h"
#import "NWPickerUtils.h"
#import "NWUIScrollViewMovePostition.h"


@interface TripDetailTVC ()
@property NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UITableViewCell *currency;
@property (weak, nonatomic) IBOutlet UITableViewCell *guysCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *groupsCell;
@property (strong,nonatomic) Currency *currentCurrency;
@property (strong, nonatomic) UIDatePicker *endPicker;
@property (strong, nonatomic) UIDatePicker *startPicker;
@property (strong,nonatomic) NSMutableSet *selectedGuys;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountCell;

@end

@implementation TripDetailTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize trip=_trip;
@synthesize dateFormatter=_dateFormatter;

-(UIDatePicker *) startPicker
{
    if (!_startPicker) {
        _startPicker = [[UIDatePicker alloc] init];
        _startPicker.datePickerMode=UIDatePickerModeDate;
        _startPicker.backgroundColor=[UIColor whiteColor];
        _startPicker.date = self.trip.startDate;
    }
    return _startPicker;
}

-(UIDatePicker *) endPicker
{
    if (!_endPicker) {
        _endPicker = [[UIDatePicker alloc] init];
        _endPicker.datePickerMode=UIDatePickerModeDate;
        _endPicker.backgroundColor=[UIColor whiteColor];
        _endPicker.date=self.trip.endDate;
    }
    return _endPicker;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Setting the value of fields in this static table to that of the passed Trip");
    
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    
    //-----顯示trip資訊-----------
    self.tripName.text = self.trip.name;
    self.startDate.detailTextLabel.text=[self.dateFormatter stringFromDate:self.trip.startDate];
    self.endDate.detailTextLabel.text=[self.dateFormatter stringFromDate:self.trip.endDate];
    self.currentCurrency=self.trip.mainCurrency;
    self.currency.detailTextLabel.text=self.currentCurrency.standardSign;
    
    
    //-----顯示Guy&Group資訊-----------
    self.selectedGuys=[NSMutableSet new];
//    self.guysCell.textLabel.text=@"Guys";
    self.guysCell.textLabel.text=NSLocalizedString(@"Guys", @"CellDesc");
    //---顯示Account--------
    self.accountCell.textLabel.text=NSLocalizedString(@"Accounts", @"CellDesc");

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //-----計算Guy&Group
    for (GuyInTrip * guyInTrip in self.trip.guysInTrip) {
        [self.selectedGuys addObject:guyInTrip.guy];
    }
    int guyscount=(int)[self.selectedGuys count];
    self.guysCell.detailTextLabel.text=[NSString stringWithFormat:@"%i %@",guyscount,NSLocalizedString(@"GuysUnit", @"CellContent")];
    self.groupsCell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",self.trip.countRealGroups,NSLocalizedString(@"GroupsUnit", @"CellContent")];
    
    //---顯示Account個數--------
    
    double numberOfAccount=0;
    for (GuyInTrip *guyInTrip in self.trip.guysInTrip) {
        numberOfAccount=numberOfAccount+(double)[guyInTrip.accounts count] ;
    }
    NSString *accountString=NSLocalizedString(@"Accounts", @"CellDesc");
    self.accountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d %@",(int)numberOfAccount,accountString];

}

-(void) save:(id)sender{
    NSLog(@"Telling the TripDetailTVC Delegate that Save was tapped on the TripDetailTVC");
    
    /* 
        直接修改傳進來的這個trip物件，然後存起來，就直接同步managedObjectContext的資料了
        不需要再建一個新的managedObjectContext，也不用再建一個Trip，直接改舊的就可以了
    */
    [self.trip setName:self.tripName.text];
    self.trip.startDate=[self.dateFormatter dateFromString:self.startDate.detailTextLabel.text];
    self.trip.endDate=[self.dateFormatter dateFromString:self.endDate.detailTextLabel.text];
    self.trip.mainCurrency=self.currentCurrency;
    [self.managedObjectContext save:nil];  // write to database
    
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheTripDetailTVCWasTapped:self];
}


#pragma mark - 每次點選row的時候會做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //每次點選row時清除所有的picker
    [NWPickerUtils dismissPicker:tableView];
    //點選row時關閉鍵盤
    [NWKeyboardUtils  dismissKeyboard4TextField:self.view];
    
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (clickCell==self.startDate||clickCell==self.endDate) {
        //TODO:不知道為什麼要用row判斷，不用row會錯
        BOOL hasBeTapped=indexPath.row==self.actingDateCellIndexPath.row;
     
        if (hasBeTapped) {
        //如果剛剛才按過，表示要關上Picker（不需要原本的actionDateCell了）
            self.actingDateCellIndexPath=nil;
        }else{
        //如果剛剛沒有actingCell，表示想要改變現在選擇的這個cell
            UIDatePicker *targetPicker = nil;
            
            if (clickCell==self.startDate) {
                targetPicker = self.startPicker;
            }else{
                targetPicker = self.endPicker;
            }
            self.actingDateCellIndexPath=indexPath;
            
            [NWPickerUtils setPickerInTableView:targetPicker tableView:tableView didSelectRowAtIndexPath:indexPath];
            
            [self.view addSubview:targetPicker];
            
            [NWUIScrollViewMovePostition autoContentOffsetToTableViewCenter:tableView didSelectRowAtIndexPath:indexPath withTagItemSize:[targetPicker sizeThatFits:CGSizeZero]];
            

            [targetPicker addTarget:self
                             action:@selector(pickerChanged:)
                   forControlEvents:UIControlEventValueChanged];

        }

    }
}


#pragma mark - Picker的事件
- (void)pickerChanged:(UIDatePicker *)sender {
    if (sender==self.startPicker) {
        self.startDate.detailTextLabel.text=[self.dateFormatter stringFromDate:sender.date];
    }else{
        self.endDate.detailTextLabel.text=[self.dateFormatter stringFromDate:sender.date];
    }
    [self setPicker:sender RoleByDate:sender.date];
}

//因為detail裡已經有開始結束日期，所以直接限定min和max date（和addTrip不同）
#pragma mark - 設定Picker規則
-(void)setPicker:(UIDatePicker *)picker RoleByDate:(NSDate *)date{
    //把picker滾到指定的日期
    picker.date=date;
    if (picker==self.startPicker) {
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

#pragma mark - ➤ Navigation：Segue Settings
// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    //每次點選row時清除所有的picker
    [NWPickerUtils dismissPicker:self.tableView];
    //點選row時關閉鍵盤
    [NWKeyboardUtils  dismissKeyboard4TextField:self.view];
    
    if([segue.identifier isEqualToString:@"Currency Segue"]){
        NSLog(@"Setting TripDetailTVC as a delegate of currencyCDTVC");
        CurrencyCDTVC *currencyCDTVC=segue.destinationViewController;
        
        currencyCDTVC.delegate=self;
        currencyCDTVC.managedObjectContext=self.managedObjectContext;
        currencyCDTVC.selectedCurrency=self.currentCurrency;
    }else if([segue.identifier isEqualToString:@"Guys In Trip Segue"]){
        NSLog(@"Setting TripDetailTVC as a delegate of GuysInTripCDTVC");
        GuysInTripCDTVC *guysInTripCDTVC=segue.destinationViewController;
        guysInTripCDTVC.delegate=self;
        guysInTripCDTVC.managedObjectContext=self.managedObjectContext;
        guysInTripCDTVC.currentTrip=self.trip;
    }else if([segue.identifier isEqualToString:@"Group List Segue From Trip Detail"]){
        GroupAndGuyInTripCDTVC *groupCDTVC=segue.destinationViewController;
        groupCDTVC.managedObjectContext=self.managedObjectContext;
        groupCDTVC.currentTrip=self.trip;
        groupCDTVC.delegate=self;
        //TODO:group的delegate，然後要顯示group數量
    }else if ([segue.identifier isEqualToString:@"Account List Segue From Trip Detail"]) {
        TripAccountCDTVC *tripAccountCDTVC=segue.destinationViewController;
        tripAccountCDTVC.currentTrip=self.trip;
        //tripAccountCDTVC.delegate=self;
        tripAccountCDTVC.managedObjectContext=self.managedObjectContext;
    }
    else {
        NSLog(@"Unidentified Segue Attempted! @%@",self.class);
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

-(void)guyWasSelectedInGuysInTripCDTVC:(GuysInTripCDTVC *)controller{
    self.selectedGuys=controller.selectedGuys;
    int guyscount=(int)[self.selectedGuys count];
    self.guysCell.detailTextLabel.text=[NSString stringWithFormat:@"%i Guys",guyscount];
    self.groupsCell.detailTextLabel.text=[NSString stringWithFormat:@"%@ Groups",self.trip.countRealGroups];
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)groupListCheckedInGroupAndGuyInTripCDTVC:(GroupAndGuyInTripCDTVC *)controller;{
    self.groupsCell.detailTextLabel.text=[NSString stringWithFormat:@"%@ Groups",self.trip.countRealGroups];
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
