//
//  NWCustCellReceipt.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/10/25.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWCustCellReceipt.h"

@implementation NWCustCellReceipt
@synthesize titleTextLabel,detailTextLabel;

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.detailLabel=super.detailTextLabel;
        self.titleTextLabel=super.textLabel;
    }
    return self;
}

-(UIView *)alertSignGroup{
    _alertSignGroup.layer.cornerRadius=5;
    return _alertSignGroup;
}
-(UIView *)alertSignExpend{
    _alertSignExpend.layer.cornerRadius=5;
    return _alertSignExpend;
}
-(UIView *)alertSignAccount{
    _alertSignAccount.layer.cornerRadius=5;
    return _alertSignAccount;
}
@end
