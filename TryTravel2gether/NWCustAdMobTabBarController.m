//
//  NWCustAdMobTabBarController.m
//  TryTravel2gether
//
//  Created by vincent on 2014/5/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWCustAdMobTabBarController.h"

@interface NWCustAdMobTabBarController ()

@end

@implementation NWCustAdMobTabBarController

@synthesize admobBannerView;

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
    
    [self.tabBar setFrame:CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y-50, 320, 49)];
    NSLog(@"%@",[self.tabBar subviews]);
    
    CGPoint origin = CGPointMake(0.0,
                                 self.tabBar.frame.size.height);
    
    admobBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    admobBannerView.adUnitID=@"ca-app-pub-1412142430031740/7628300912";
    admobBannerView.rootViewController=self;
    admobBannerView.delegate = self;
    
    [self.tabBar addSubview:admobBannerView];
    [self.admobBannerView loadRequest:[self request]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Google AdMob bannerView
//-(void)


- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView beginAnimations:@"BannerSlide" context:nil];

    bannerView.frame = CGRectMake(0.0,
                                  self.tabBar.frame.size.height,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    [UIView commitAnimations];

}

- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

#pragma mark GADRequest generation
- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID,@"cdd84c3116ff45f45c60b034313f9e568762647c"
                            ];
    return request;
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
