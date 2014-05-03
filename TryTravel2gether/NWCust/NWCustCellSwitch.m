//
//  NWCustCellSwitch.m
//  TryTravel2gether
//
//  Created by apple on 2014/5/3.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWCustCellSwitch.h"

@implementation NWCustCellSwitch
@synthesize textLabel,switchControl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel=super.textLabel;
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
