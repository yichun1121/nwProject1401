//
//  ReceiptPhotoVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/7/23.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"
#import "PhotoContentVC.h"
@interface ReceiptPhotoVC : UIViewController<UIPageViewControllerDataSource,PhotoContentVCDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController; //拿來檢視照片的容器
@property (strong,nonatomic)Receipt *currentReceipt;
@end
