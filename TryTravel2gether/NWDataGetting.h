//
//  NWDataGetting.h
//  TryTravel2gether
//
//  Created by YICHUN on 2015/2/11.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWData.h"

@interface NWDataGetting : NWData

-(NSData *)getDataByFileName:(NSString *)relativeFile;

@end
