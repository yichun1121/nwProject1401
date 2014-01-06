//
//  AddTripCDTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddTripCDTVC.h"

@implementation AddTripCDTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;

-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void) save:(id)sender{
    NSLog(@"Telling the AddTripCDTVC Delegate that Save was tapped on the AddTripCDTVC");
    
    Trip *role = [NSEntityDescription insertNewObjectForEntityForName:@"Trip"
                                               inManagedObjectContext:self.managedObjectContext];
    
    role.name = self.tripName.text;
    
    [self.managedObjectContext save:nil];  // write to database
    
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheAddTripTVCWasTapped:self];
}
@end
