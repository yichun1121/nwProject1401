//
//  NWDataSaving.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/18.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "NWDataSaving.h"

@implementation NWDataSaving

-(NSString *)checkedAndCreatedRelativeFolderPath:(NSString *)relativeFolder{
    NSString *createdFolder=@"";
    //1. 讓relative folder path第一個是斜線
    if (![[relativeFolder substringToIndex:1] isEqual:@"/"]) {
        relativeFolder=[@"/" stringByAppendingString:relativeFolder];
    }
    NSString * fullFolder=[self.basePath stringByAppendingString:relativeFolder];

    if([self folderCreator:fullFolder]){
        createdFolder=relativeFolder;
    }
    
    return createdFolder;
}

-(bool)folderCreator:(NSString *)folderPath{
    BOOL createSuccess=NO;
    //-----檢查預存放的資料夾路徑-------------------------
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        NSLog(@"folder path:%@ exists.",folderPath);
        createSuccess=YES;
    }else{
        NSLog(@"creating folder...%@",folderPath);
        NSError *error=nil;
        //建立資料夾
        [[NSFileManager defaultManager]createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"fail to create folder, error: %@", [error localizedDescription]);
        }else{
            createSuccess=YES;
        }
    }
    return createSuccess;
}

-(void)saveDataIntoFile:(NSString *)savingString withFileName:(NSString *)relativeName{
    
//    NSURL* url=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
//                                                       inDomains:NSUserDomainMask] lastObject];
//    
//    NSString *path = [url.path stringByAppendingPathComponent:fileName];

    NSString *name=[relativeName lastPathComponent];
    NSString *relativeFolder=@"/";
    if (![name isEqualToString:relativeName]) {
        relativeFolder = [relativeName substringToIndex:relativeName.length-name.length-1];
    }
    
//    NSString *path=[NSString stringWithFormat:@"%@%@/%@",self.basePath,[self checkedAndCreatedRelativeFolderPath:relativeFolder],name];
    NSString *path=[NSString stringWithFormat:@"%@/%@",[self getFullPathByRelative:[self  checkedAndCreatedRelativeFolderPath:relativeFolder]],name ];
    
    NSError *error = nil;
    
    BOOL succeeded = [savingString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (succeeded) {
        NSLog(@"Success at: %@",path);
    } else {
        NSLog(@"Failed to store. Error: %@",error);
    }
}

@end
