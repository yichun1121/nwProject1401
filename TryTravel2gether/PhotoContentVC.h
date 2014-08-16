//
//  PhotoContentVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/7/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoContentVC;
@protocol PhotoContentVCDelegate <NSObject>
-(void)changeTopBarStatus:(BOOL)toShow;
@end
@interface PhotoContentVC : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property NSUInteger pageIndex;
@property UIImage *image;
@property (weak,nonatomic) id<PhotoContentVCDelegate> delegate;
@end
