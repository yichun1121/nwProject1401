//
//  TripDetailCDTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripDetailTVC.h"
#define kStartPicker 2  //startPicker在第2行
#define kEndPicker 4    //endPicker在第4行
/*! 展開Picker後的Cell高度
 */
static NSInteger sPickerCellHeight=162;

@interface TripDetailTVC ()
@property NSDateFormatter *dateFormatter;
@end

@implementation TripDetailTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize trip=_trip;
@synthesize dateFormatter=_dateFormatter;

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
    
    //-----設定Picker----------
    [self setPicker:self.startPicker RoleByDate:self.trip.startDate];
    [self setPicker:self.endPicker RoleByDate:self.trip.endDate];

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
    
    [self.managedObjectContext save:nil];  // write to database
    
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheTripDetailTVCWasTapped:self];
}


#pragma mark 負責長cell的高度，也在這設定actingPicker（每次會因為tableView beginUpdates和endUpdates重畫）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result=self.tableView.rowHeight;
    
    if (indexPath.row==kStartPicker||indexPath.row==kEndPicker) {
        //目前這行的上一行是actingDateCell
        if(indexPath.row-1==self.actingDateCellIndexPath.row){
            self.actingPickerCellIndexPath=indexPath;
            result=sPickerCellHeight;
        }else{
            result=0;
        }
    }
    return result;
}

#pragma mark - 每次點選row的時候會做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    if (clickCell==self.startDate||clickCell==self.endDate) {
        //TODO:不知道為什麼要用row判斷，不用row會錯
        BOOL hasBeTapped=indexPath.row==self.actingDateCellIndexPath.row;
        if (hasBeTapped) {
        //如果剛剛才按過，表示要關上Picker（不需要原本的actionDateCell了）
            self.actingDateCellIndexPath=nil;
        }else{
        //如果剛剛沒有actingCell，表示想要改變現在選擇的這個cell
            self.actingDateCellIndexPath=indexPath;
        }
        // 為了讓picker展開或關閉，需要重新整理tableView，beginUpdates和endUpdates
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark - Picker的事件
- (IBAction)pickerChanged:(UIDatePicker *)sender {
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
        self.endPicker.minimumDate=date;
    }else{
        self.startPicker.maximumDate=date;
    }
}
@end
