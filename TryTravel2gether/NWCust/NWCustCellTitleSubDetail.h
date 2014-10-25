//
//  NWCustCellTitleSubDetail.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWCustCellTitleSubDetail : UITableViewCell

//+ (id)NWCustCellTitleSubDetail;
//- (id)init;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleTextLabel;

@property (weak, nonatomic) IBOutlet UIView *alertSignAccount;
@property (weak, nonatomic) IBOutlet UIView *alertSignGroup;
@property (weak, nonatomic) IBOutlet UIView *alertSignExpend;
@end
