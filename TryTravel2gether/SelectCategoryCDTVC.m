//
//  SelectCategoryCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/7.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "SelectCategoryCDTVC.h"

@interface SelectCategoryCDTVC ()

@end

@implementation SelectCategoryCDTVC
-(void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - Table view data source

-(UITableViewCell *)configureCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell=[super configureCell:cell AtIndexPath:indexPath];
    Itemcategory *category=[self.fetchedResultsController objectAtIndexPath:indexPath];
    if (category!=self.selectedCategory) {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Category Segue From Add Item"]){
        AddCategoryTVC * addCategoryTVC=segue.destinationViewController;
        addCategoryTVC.delegate=self;
        addCategoryTVC.managedObjectContext=self.managedObjectContext;
    }
}

#pragma mark - 事件
//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Itemcategory *category=[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedCategory= category;
    
    UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    //先用迴圈把所有section裡面的row裡的checkmark取消
    long sectionCount=self.tableView.numberOfSections;
    for (int section = 0; section < sectionCount; ++section) {
        long rowCount=[self.tableView numberOfRowsInSection:section];
        for (int row = 0 ;row < rowCount; ++row) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
        }
    }
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    [self.delegate theDoneButtonOnTheSelectCategoryCDTVCWasTapped:self];
}


@end
