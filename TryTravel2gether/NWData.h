//
//  NWData.h
//  TryTravel2gether
//
//  Created by YICHUN on 2015/2/11.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWData : NSObject
@property (nonatomic) NSArray * paths;
@property (nonatomic)  NSString * basePath;
-(NSString *)getFullPathByRelative:(NSString *)relativePath;
@end
