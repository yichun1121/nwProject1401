//
//  Group+TripGuys.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/22.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Group+TripGuys.h"
#import "GuyInTrip.h"
#import "Guy.h"

@implementation Group (TripGuys)
@dynamic groupImageName;
-(NSString *)guysNameSplitBy:(NSString *)sign{
    NSString *strGuys=@"";
    for (GuyInTrip *guyInTrip in self.guysInTrip) {
        strGuys=[NSString stringWithFormat:@"%@%@%@",strGuys,guyInTrip.guy.name,sign];
    }
    if (strGuys.length!=0) {
        strGuys=[strGuys substringToIndex:strGuys.length-(sign.length)];
    }
    return strGuys;
}
-(NSString *)groupImageName{
    if (self.guysInTrip.count>1) {
        return @"group";
    }else{
        return @"user";
    }
}
@end
