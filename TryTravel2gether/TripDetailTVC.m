//
//  TripDetailCDTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripDetailTVC.h"

@interface TripDetailTVC ()

@end

@implementation TripDetailTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize trip=_trip;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Setting the value of fields in this static table to that of the passed Role");
    self.tripName.text = self.trip.name;
}

-(void) save:(id)sender{
    NSLog(@"Telling the TripDetailCDTVC Delegate that Save was tapped on the TripDetailTVC");
    
    /* 
        直接修改傳進來的這個trip物件，然後存起來，就直接同步managedObjectContext的資料了
        不需要再建一個新的managedObjectContext，也不用再建一個Trip，直接改舊的就可以了
    */
    [self.trip setName:self.tripName.text];
    [self.managedObjectContext save:nil];  // write to database
    
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheTripDetailTVCWasTapped:self];
}
@end
