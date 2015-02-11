//
//  NWData.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/2/11.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "NWData.h"

@interface NWData()
@end

@implementation NWData
@synthesize paths=_paths;
@synthesize basePath=_basePath;

-(NSArray *)paths{
    if (!_paths) {
        _paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    }
    return _paths;
}
-(NSString *)basePath{
    if (!_basePath) {
        _basePath=([self.paths count] > 0) ? [self.paths objectAtIndex:0] : nil;
    }
    return _basePath;
}

-(NSString *)getFullPathByRelative:(NSString *)relativePath{
    NSString *fullPath=@"";
    //1. 讓relative folder path第一個是斜線
    if (![[relativePath substringToIndex:1] isEqual:@"/"]) {
        relativePath=[@"/" stringByAppendingString:relativePath];
    }
    fullPath=[self.basePath stringByAppendingString:relativePath];
    return fullPath;
}
@end
