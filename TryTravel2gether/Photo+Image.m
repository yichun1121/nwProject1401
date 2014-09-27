//
//  Photo+Image.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/5/2.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Photo+Image.h"
#import "Receipt.h"
#import "Day.h"
#import "Trip.h"

@implementation Photo (Image)
-(UIImage *)image{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path=self.fullPath;
    UIImage* image = [UIImage imageWithContentsOfFile:path];
//    UIImage * image=[UIImage imageNamed:[NSString stringWithFormat:@"Photos/Trip LA/%@",self.fileName]];
    return image;
}
+(NSString *)newRelativeFolderWithTripIndex:(NSNumber *)tripIndex{
    return [NSString stringWithFormat:@"/Photos/Trip_%@",tripIndex];
}
-(NSString *)fullPath{
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* path = [NSString stringWithFormat:@"%@%@",basePath,self.relativePath];
    return path;
}
@end
