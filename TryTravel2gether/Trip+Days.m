                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 //
//  Trip+Days.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/2/8.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Trip+Days.h"
#import "nwAppDelegate.h"
#import "Day.h"

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
+(NSDateFormatter *)dateFormatter_GMT{
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
        formatter.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        formatter.dateFormat=@"yyyy/MM/dd";
    
    return formatter;
}
-(Day *)getTripDayByDateString:(NSString *)dateString{
    NSLog(@"Find the trip day:%@ in the current trip.",dateString);
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSDate *date= [[Trip dateFormatter_GMT] dateFromString:dateString];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(date = %@) AND (inTrip=%@)", date,self];
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
    
//    nwAppDelegate *appDelegate =  (nwAppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                             inManagedObjectContext:self.managedObjectContext];
    day.name=@"";
    day.date=date;
    day.inTrip=self;
    
    NSLog(@"Create new Day in AddReceiptTVC");
    
    [self.managedObjectContext save:nil];  // write to database
    return day;
}
@end
