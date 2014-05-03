//
//  NWKeyboardUtils.m
//  TryTravel2gether
//
//  Created by vincent on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWKeyboardUtils.h"

@implementation NWKeyboardUtils


+(void)dismissKeyboard4TextField:(UIView *) tagView{
    NSArray *subviews = [tagView subviews];
    for (UIView *subview in subviews) {
        [self dismissKeyboard4TextField:subview];
        //找是不是TextField
        if ([subview isKindOfClass:[UITextField class]]) {
            //當UITextField不是游標焦點時，就關閉鍵盤
            [subview resignFirstResponder];
        }
    }
}

@end
