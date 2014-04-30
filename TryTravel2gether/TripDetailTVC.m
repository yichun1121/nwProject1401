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

@interface TripDetailTVC ()
@property NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UITableViewCell *currency;
@property (weak, nonatomic) IBOutlet UITableViewCell *guysCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *groupsCell;
@property (strong,nonatomic) Currency *currentCurrency;
@property (strong, nonatomic) UIDatePicker *endPicker;
@property (strong, nonatomic) UIDatePicker *startPicker;
@property (strong,nonatomic) NSMutableSet *SelectedGuys;

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
-(NSMutableSet *) SelectedGuys
{
    if (!_SelectedGuys) {
        _SelectedGuys = [[NSMutableSet alloc] init];
    }
    return _SelectedGuys;
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
    self.SelectedGuys=[NSMutableSet new];
    self.guysCell.textLabel.text=@"Guys";
    
    for (GuyInTrip * guyInTrip in self.trip.guysInTrip) {
    [self.SelectedGuys addObject:guyInTrip.guy];
    }
    int guyscount=(int)[self.SelectedGuys count];
    self.guysCell.detailTextLabel.text=[NSString stringWithFormat:@"%i Guys",guyscount];
    self.groupsCell.detailTextLabel.text=[NSString stringWithFormat:@"%@ Groups",self.trip.countRealGroups];
    

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
    for (UIView *subview in [self.view subviews]) {
        if ([subview isKindOfClass:[UIDatePicker class]]) {
            [subview removeFromSuperview];
            self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height-[self.endPicker sizeThatFits:CGSizeZero].height);
        }
    }

    
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
            
            [self setPickerFrame:targetPicker WithIndexPath:indexPath];
            
            [self.view addSubview:targetPicker];
            [self animateToPlaceWithItemSize:[targetPicker sizeThatFits:CGSizeZero]];
            [targetPicker addTarget:self
                             action:@selector(pickerChanged:)
                   forControlEvents:UIControlEventValueChanged];

        }

    }
}


-(void)setPickerFrame:(UIDatePicker *)picker WithIndexPath:(NSIndexPath *)indexPath{
    //find the current table view size
    CGRect screenRect = [self.view bounds];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    //find the date picker size
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    
    //set the picker frame
    NSLog(@"screenRect.y=%f,lastcell.y=%f",screenRect.origin.y,cellRect.origin.y);
    CGRect pickerRect = CGRectMake(0.0,
                                   cellRect.origin.y+cellRect.size.height,
                                   pickerSize.width,
                                   pickerSize.height);
    picker.frame = pickerRect;
}

/*!動畫設定，讓某大小之物件，動作流暢呈現至畫面最底
 */
-(void)animateToPlaceWithItemSize:(CGSize)itemSize{
    //下面這是動畫設定，讓動作流暢到位：[UIView animateWithDuration: animations: completion: ];
    [UIView animateWithDuration: 0.4f
                     animations:^{
                         //animations裡面是終點位置
                         self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+itemSize.height);
                         if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
                             self.tableView.contentOffset=CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished) {} ];
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

-(void)guyWasSelectedInGuysInTripCDTVC:(GuysInTripCDTVC *)controller{
    self.SelectedGuys=controller.SelectedGuys;
    int guyscount=(int)[self.SelectedGuys count];
    self.guysCell.detailTextLabel.text=[NSString stringWithFormat:@"%i Guys",guyscount];
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)groupListCheckedInGroupAndGuyInTripCDTVC:(GroupAndGuyInTripCDTVC *)controller;{
    self.groupsCell.detailTextLabel.text=[NSString stringWithFormat:@"%@ Groups",self.trip.countRealGroups];
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
