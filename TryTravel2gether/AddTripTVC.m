//
//  AddTripTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddTripTVC.h"

@interface AddTripTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation AddTripTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize dateFormatter;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //-----Date Formatter----------
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    //-----顯示當天的日期-----------
    self.startDate.detailTextLabel.text= [self.dateFormatter stringFromDate:[NSDate date]];
    self.endDate.detailTextLabel.text=[self.dateFormatter stringFromDate:[NSDate date]];
}
-(void) save:(id)sender{
    NSLog(@"Telling the AddTripTVC Delegate that Save was tapped on the AddTripTVC");
    
    Trip *role = [NSEntityDescription insertNewObjectForEntityForName:@"Trip"
                                               inManagedObjectContext:self.managedObjectContext];
    
    role.name = self.tripName.text;
    
    [self.managedObjectContext save:nil];  // write to database
    
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheAddTripTVCWasTapped:self];
}
@end
