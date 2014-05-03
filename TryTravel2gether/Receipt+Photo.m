//
//  Receipt+Photo.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/5/2.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Receipt+Photo.h"

@implementation Receipt (Photo)
-(NSArray *)photosOrdered{
//    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"fileName" ascending:YES]];
//    NSArray *sortedPhotos = [[_photos allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@"fileName" ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray=[self.photos sortedArrayUsingDescriptors:sortDescriptors];

    return sortedArray;
}
@end
