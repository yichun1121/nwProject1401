//
//  NWDataSaving.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/18.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "NWDataSaving.h"

@implementation NWDataSaving
+(void)saveDataIntoFile:(NSString *)savingString withName:(NSString *)fileName{
    //Saving file
    //    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //
    //    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSURL* url=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                       inDomains:NSUserDomainMask] lastObject];
    
    NSString *path = [url.path stringByAppendingPathComponent:fileName];
    
    //    NSString *destination = [url stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    
    BOOL succeeded = [savingString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (succeeded) {
        NSLog(@"Success at: %@",path);
    } else {
        NSLog(@"Failed to store. Error: %@",error);
    }
}

@end
