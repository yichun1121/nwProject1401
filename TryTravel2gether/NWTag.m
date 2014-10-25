//
//  NWTag.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/10/25.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWTag.h"

@implementation NWTag

-(void)turnGroupErrorSpot{
    [self spotWithColor:[UIColor orangeColor]];
    
}
-(void)turnExpendErrorSpot{
    [self spotWithColor:[UIColor redColor]];
    
}
-(void)turnAccountErrorSpot{
    [self spotWithColor:[UIColor greenColor]];
}
-(void)spotWithColor:(UIColor *)color{
    self.frame=CGRectMake(0, 0, 10, 10);
    self.alpha = 0.5;
    self.layer.cornerRadius = 5;
    self.backgroundColor =color;
}
@end
