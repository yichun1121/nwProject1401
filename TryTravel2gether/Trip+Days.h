//
//  Trip+Days.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/2/8.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Trip.h"

@interface Trip (Days)
//@property NSDateFormatter *dateFormatter_GMT;
-(BOOL)hadThisDateWithUTC:(NSString *)date;
+(NSDateFormatter *)dateFormatter_GMT;
+(NSDateFormatter *)dateTimeFormatter_GMT;
+(NSDateFormatter *)timeFormatter_GMT;
-(Day *)getTripDayByDateString:(NSString *)dateString;
-(Day *)createDayInCurrentTripByDateString:(NSDate *)date;
@end
