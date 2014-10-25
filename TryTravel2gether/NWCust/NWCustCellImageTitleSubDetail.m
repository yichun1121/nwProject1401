//
//  NWCustCellImageTitleSubDetail.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/6/14.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWCustCellImageTitleSubDetail.h"

@implementation NWCustCellImageTitleSubDetail

@synthesize titleTextLabel,subtitleTextLabel,detailTextLabel,imageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel=super.detailTextLabel;
        self.titleTextLabel=super.textLabel;
    }
    
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
