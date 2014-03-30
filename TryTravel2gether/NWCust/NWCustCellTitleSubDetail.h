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

@end
