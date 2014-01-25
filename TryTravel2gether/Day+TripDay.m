//
//  Day+TripDay.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Day+TripDay.h"
#import "Trip.h"

@implementation Day (TripDay)

/*! 判斷某天是該次旅程的第幾天（startDate當天回傳1，前一天回傳-1，不應該有0） 
 */
-(int)DayNumberOfTripdayInTrip{
    int result=0;
    NSDateComponents * dateComponents=[[NSDateComponents alloc]init];
    dateComponents=[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.inTrip.startDate toDate:self.date options:0];
    if (dateComponents.day>=0) {
        result=dateComponents.day+1;
    }else{
        result=dateComponents.day;
    }
    return result;
}

/*! 回傳旅程第幾天的字串，ex:Day 3，如果在旅程前顯示Prepare，旅程結束後顯示Review 
 */
-(NSString *)DayNumberStringOfTripdayInTrip{
    NSString *dayString=@"";
    NSDateComponents * startDateComponents=[[NSDateComponents alloc]init];
    startDateComponents=[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.inTrip.startDate toDate:self.date options:0];
    NSDateComponents * endDateComponents=[[NSDateComponents alloc]init];
    endDateComponents=[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.inTrip.endDate toDate:self.date options:0];
    if (startDateComponents.day<0) {
        dayString=@"Prepare";
    }else if (endDateComponents.day>0){
        dayString=@"Review";
    }else{
        dayString=[NSString stringWithFormat:@"Day %i",[self DayNumberOfTripdayInTrip]];
    }
    return dayString;
}
@end
