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
        self.imageView=super.imageView;
        self.imageView.hidden=NO;
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

@end
