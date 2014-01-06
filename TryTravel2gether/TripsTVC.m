//
//  TripsTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripsTVC.h"

@implementation TripsTVC

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Trips Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}

// 內建，準備Segue的method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //判斷是哪條連線（會對應Segue的名稱）
	if ([segue.identifier isEqualToString:@"Add Trip Segue"])
	{
        NSLog(@"Setting TripTVC as a delegate of AddTripTVC");
        
        AddTripTVC *addTripTVC = segue.destinationViewController;
        addTripTVC.delegate = self;
        /*
            在AddTripTVC裡宣告了一個delegate（是AddTripTVCDelegate）
            addTripTVC.delegate=self的意思是：我要監控AddTripTVC
         */
	}
}

/*
    .h檔案宣告時有@interface TripsTVC : UITableViewController <AddTripTVCDelegate>
    就要實作AddTripTVCDelegate宣告的method
 */
- (void)theSaveButtonOnTheAddTripTVCWasTapped:(AddTripTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
