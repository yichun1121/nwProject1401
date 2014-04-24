//
//  TripsCDTVCWithSidebar.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripsCDTVC.h"

@interface TripsCDTVCWithSidebar : TripsCDTVC<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
