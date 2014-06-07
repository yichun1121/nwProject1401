//
//  NWCustAdMobTabBarController.h
//  TryTravel2gether
//
//  Created by vincent on 2014/5/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import <iAd/iAd.h>

@interface NWCustAdMobTabBarController : UITabBarController<GADBannerViewDelegate,ADBannerViewDelegate>
@property(nonatomic, strong)GADBannerView *admobBannerView;
@property(nonatomic, strong)ADBannerView *bannerView;
//@property(nonatomic, strong)BOOL *isShowIAD;
@end
