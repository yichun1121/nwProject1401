//
//  Trip+System.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/9/27.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Trip+System.h"
#import "nwAppDelegate.h"

@implementation Trip (System)
+(NSNumber *)getNextTripIndex{
    NSNumber * currentIndex=0;
    
    NSLog(@"Find the next trip index in the current @%@.",self.class);
    nwAppDelegate *appDelegate =  (nwAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(date = %@) AND (inTrip=%@)", date,self];
    //    [request setPredicate:pred];
    
    NSSortDescriptor *sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"tripIndex" ascending:NO];
    [request setSortDescriptors:@[sortDescriptors]];
    
    NSError *error;
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        currentIndex=0;
    } else {
        Trip * lastTrip=(Trip *)objects[0];
        currentIndex=lastTrip.tripIndex;
    }
    
    
    NSNumber * nextIndex=[NSNumber numberWithInt: [currentIndex intValue]+1];
    return nextIndex;
}
@end
