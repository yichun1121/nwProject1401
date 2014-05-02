//
//  Receipt+Photo.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/5/2.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Receipt+Photo.h"

@implementation Receipt (Photo)
-(NSOrderedSet *)photosOrdered{
//    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"fileName" ascending:YES]];
//    NSArray *sortedPhotos = [[_photos allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    NSOrderedSet *orderedSet=[NSOrderedSet orderedSetWithSet:self.photos];
    return orderedSet;
}
@end
