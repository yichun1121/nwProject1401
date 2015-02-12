//
//  ShareOptionTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/25.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "SelectTripCDTVC.h"
#import <MessageUI/MessageUI.h>

@class ShareOptionTVC;
@protocol ShareOptionDelegate <NSObject>

-(void)theSaveButtonOnTheShareOptionWasTapped:(ShareOptionTVC *)controller;

@end


@interface ShareOptionTVC : UITableViewController<SelectTripCDTVCDelegate,MFMailComposeViewControllerDelegate>
@property (weak,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)id<ShareOptionDelegate> delegate;
@property (strong,nonatomic)Trip *currentTrip;
@end
