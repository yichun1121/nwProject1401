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
@property NSDateFormatter *dateFormatter;
@end
/*!
   目前Day Detail不開放修改日期，所以不用加picker。
 */
@implementation DayDetailTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Setting the value of fields in this static table to that of the passed Day");

    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    
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
    self.day.date=[self.dateFormatter dateFromString:self.dateCell.detailTextLabel.text];
    
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
    self.dateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:self.day.date];
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

#pragma mark - Table view set AdMob banner
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //-----self.tableView.frame 的高度剪掉AdMob Banner高度-------(讓Banner不會擋到TableView的資訊)
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x
                                        , self.tableView.frame.origin.y
                                        , self.tableView.frame.size.width
                                        , self.tableView.frame.size.height-50)];
}
@end
