//
//  DayDetailTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/2/11.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "DayDetailTVC.h"
#import "Trip.h"
#import "Day+TripDay.h"

@interface DayDetailTVC ()
@property (nonatomic)  NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSDateFormatter *dateFormatter_GMT;
@end
/*!
   目前Day Detail不開放修改日期，所以不用加picker。
 */
@implementation DayDetailTVC
@synthesize dateFormatter=_dateFormatter;
@synthesize dateFormatter_GMT=_dateFormatter_GMT;

#pragma mark - lazy instantiation
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Setting the value of fields in this static table to that of the passed Day");
    
    //-----顯示day資訊-----------
    [self configureTheCell];
    
    //-----監聽view controller-----------
    self.dayName.delegate=self;
}
- (IBAction)save:(UIBarButtonItem *)sender {
    
    /*
     直接修改傳進來的這個trip物件，然後存起來，就直接同步managedObjectContext的資料了
     不需要再建一個新的managedObjectContext，也不用再建一個Trip，直接改舊的就可以了
     */
    [self.day setName:self.dayName.text];
    self.day.date=[self.dateFormatter_GMT dateFromString:self.dateCell.detailTextLabel.text];
    
    [self.managedObjectContext save:nil];  // write to database
    
    
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheDayDetailTVCWasTapped:self];
    NSLog(@"Telling the DayDetailTVC Delegate that Save was tapped on the DayDetailTVC");
}


#pragma mark - Table view data source
#pragma mark - 顯示所有資訊
-(void)configureTheCell{
    NSString *strDateRange=[NSString stringWithFormat:@"%@ - %@",[self.dateFormatter stringFromDate:self.day.inTrip.startDate],[self.dateFormatter stringFromDate:self.day.inTrip.endDate]];
    self.tripInfoCell.textLabel.text = self.day.inTrip.name;
    self.tripInfoCell.detailTextLabel.text=strDateRange;
    self.dateCell.detailTextLabel.text=[self.dateFormatter_GMT stringFromDate:self.day.date];
    self.dayName.text=self.day.name;
    self.dayResultString.textLabel.text=[self.day DayNumberStringOfTripdayInTrip];
}

#pragma mark - delegation
#pragma mark - 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
