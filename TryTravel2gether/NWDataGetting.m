//
//  NWDataGetting.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/2/11.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "NWDataGetting.h"

@implementation NWDataGetting
-(NSData *)getDataByFileName:(NSString *)relativeFile{
    NSData * file=[NSData dataWithContentsOfFile:[self getFullPathByRelative:relativeFile]];
    return file;
}
@end
