//
//  Itemcategory+Colorful.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/5/1.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Itemcategory+Colorful.h"

@implementation Itemcategory (Colorful)
-(UIColor *)color{
    float red=[[self.colorRGB substringWithRange:NSMakeRange(0, 3)]floatValue] ;
    float green=[[self.colorRGB substringWithRange:NSMakeRange(3, 3)]floatValue] ;
    float blue=[[self.colorRGB substringWithRange:NSMakeRange(6, 3)]floatValue] ;
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}
-(UIImage *)image{
    NSString *imageName;
    if (self.iconName) {
        imageName=self.iconName;
    }else{
        imageName=@"empty";
    }
    return [UIImage imageNamed:imageName];
}
@end
