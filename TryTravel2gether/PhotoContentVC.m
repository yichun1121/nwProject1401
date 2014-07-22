//
//  PhotoContentVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/7/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "PhotoContentVC.h"

@interface PhotoContentVC ()

@end

@implementation PhotoContentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    //下面這句是讓圖片顯示等比例
    self.backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundImage.image=self.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
