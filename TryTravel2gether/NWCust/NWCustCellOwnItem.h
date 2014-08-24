//
//  NWCustCellOwnItem.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/8/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWCustCellOwnItem : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrency;
@property (weak, nonatomic) IBOutlet UIImageView *imgCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imgGroup;

@end
