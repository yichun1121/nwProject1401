//
//  GuyInTrip+Group.m
//  TryTravel2gether
//
//  Created by apple on 2014/5/17.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "GuyInTrip+Group.h"
#import "Group.h"
#import "Group+Special.h"
#import "Group+TripGuys.h"
#import "Trip.h"

@implementation GuyInTrip (Group)

-(void)setRealInTrip:(NSNumber *)realInTrip{
    
    for(Group * group in self.inTrip.groups){
        if (group.isShareAll==YES) {
            if ([realInTrip boolValue]==YES) {
                [group addGuysInTripObject:self];
            }else{
                [group removeGuysInTripObject:self];
            }
            break;
        }
    }
    [self willChangeValueForKey:@"realInTrip"];
    [self setPrimitiveValue:realInTrip forKey:@"realInTrip"];
    [self didChangeValueForKey:@"realInTrip"];
}
@end
