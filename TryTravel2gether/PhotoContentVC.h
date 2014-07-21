//
//  PhotoContentVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/7/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoContentVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property NSUInteger pageIndex;
@property UIImage *image;
@end
