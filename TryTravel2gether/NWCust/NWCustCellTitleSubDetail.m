//
//  NWCustCellTitleSubDetail.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWCustCellTitleSubDetail.h"

@implementation NWCustCellTitleSubDetail
@synthesize titleTextLabel,subtitleTextLabel,detailTextLabel;

//+(id)NWCustCellTitleSubDetail{
//    NWCustCellTitleSubDetail *customView = [[[NSBundle mainBundle] loadNibNamed:@"NWCustCellTitleSubDetail" owner:nil options:nil] lastObject];
//    
//    // make sure customView is not nil or the wrong class!
//    if ([customView isKindOfClass:[NWCustCellTitleSubDetail class]])
//        return customView;
//    else
//        return nil;
//}
//- (id)init {
//    NSArray* array;
//    
//    ////如果用下面這段，init就須為Class Method
//    //    UINib *nib = [UINib nibWithNibName:@"MyHeader" bundle:nil];
//    //    array = [nib instantiateWithOwner:nil
//    //                              options:nil];
//    
//    //用這段可以用instance method
//    array = [[NSBundle mainBundle] loadNibNamed:@"NWCustCellTitleSubDetail"
//                                          owner:nil
//                                        options:nil];
//    
//    self = (NWCustCellTitleSubDetail*)[array lastObject];
//    if(self) {
//        /**
//         * 需要修改 AutoresizingMask, 不然可能因為大小的關係跑掉.
//         */
//        self.autoresizingMask = UIViewAutoresizingNone;
//    }
//    return self;
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel=super.detailTextLabel;
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
