//
//  SelectTripCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/23.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "SelectTripCDTVC.h"

@interface SelectTripCDTVC ()

@end

@implementation SelectTripCDTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Table view data source
-(UITableViewCell *)configureCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell=[super configureCell:cell AtIndexPath:indexPath];
    Trip *trip=[self.fetchedResultsController objectAtIndexPath:indexPath];
    if (trip==self.selectedTrip){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Trip *trip=[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedTrip=trip;
    [self.delegate theTripCellOnSelectTripCDTVCWasTapped:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
