//
//  SelectTripCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/23.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripsCDTVC.h"
@class SelectTripCDTVC;
@protocol SelectTripCDTVCDelegate <NSObject>
-(void)theTripCellOnSelectTripCDTVCWasTapped:(SelectTripCDTVC *)controller;
@end

@interface SelectTripCDTVC : TripsCDTVC
@property (strong,nonatomic)Trip *selectedTrip;
@property (weak,nonatomic) id<SelectTripCDTVCDelegate> delegate;
@end
