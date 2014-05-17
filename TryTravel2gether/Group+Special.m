//
//  Group+Special.m
//  TryTravel2gether
//
//  Created by apple on 2014/5/17.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Group+Special.h"

@implementation Group (Special)



-(BOOL)isShareAll{
    if ([self.name isEqualToString:@"Share_All"]) {
        return YES;
    }else{
        return NO;
    }
}
@end
