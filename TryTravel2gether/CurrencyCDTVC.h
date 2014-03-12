//
//  CurrencyCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Currency.h"

@class CurrencyCDTVC;
@protocol CurrencyCDTVCDelegate <NSObject>

-(void)currencyWasSelectedInCurrencyCDTVC:(CurrencyCDTVC*)controller;

@end

@interface CurrencyCDTVC : CoreDataTableViewController

@property (weak,nonatomic)id delegate;
@property (strong,nonatomic)NSManagedObjectContext * managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
@property (strong,nonatomic)Currency *selectedCurrency;

@end
