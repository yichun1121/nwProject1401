//
//  PayWayCDTVC.h
//  TryTravel2gether
//
//  Created by apple on 2015/1/17.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "PayWay.h"

@class PayWayCDTVC;

@protocol PayWayCDTVCDelegate <NSObject>
-(void)payWayWasSelectedInPayWayCDTVC:(PayWayCDTVC *)controller;
@end

@interface PayWayCDTVC : CoreDataTableViewController
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak,nonatomic) id<PayWayCDTVCDelegate> delegate;
@property (strong,nonatomic)PayWay* selectedPayWay;


@end
