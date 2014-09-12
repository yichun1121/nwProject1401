                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 //
//  Trip+Days.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/2/8.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Trip+Days.h"

@implementation Trip (Days)

/*!判斷該trip是否已有某日
 */
-(BOOL)hadThisDateWithUTC:(NSString *)date{
    BOOL hadDay=YES;
    
    NSDateFormatter * dateFormatter_GMT=[NSDateFormatter new];
    dateFormatter_GMT.dateFormat=@"yyyy/MM/dd";
    dateFormatter_GMT.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSDate *midnightDate=[dateFormatter_GMT dateFromString:date];
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(date = %@) AND (inTrip=%@)", midnightDate,self];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([objects count] == 0) {
        hadDay=NO;
    }
    return hadDay;
}
@end
