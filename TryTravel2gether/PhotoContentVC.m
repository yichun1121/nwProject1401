//
//  PhotoContentVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/7/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "PhotoContentVC.h"

@interface PhotoContentVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property BOOL zoomCheck;
@property (nonatomic) BOOL showTopBar;
@end

@implementation PhotoContentVC
@synthesize scrollView=_scrollView;
@synthesize showTopBar=_showTopBar;
//@synthesize zoomCheck=_zoomCheck;
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
//    self.backgroundImage.userInteractionEnabled = YES;
    self.showTopBar=NO;
    [self.delegate changeTopBarStatus:NO];
    [self setTabGesture];
}
-(void)setTabGesture{
    UITapGestureRecognizer *tapOnce =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapOnce:)];
    UITapGestureRecognizer *tapTwice =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapTwice:)];
    
    tapOnce.numberOfTapsRequired = 1;
    tapTwice.numberOfTapsRequired = 2;
    
    //stops tapOnce from overriding tapTwice
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    
    // then need to add the gesture recogniser to a view
    // - this will be the view that recognises the gesture
    [self.view addGestureRecognizer:tapOnce];
    [self.view addGestureRecognizer:tapTwice];
}
- (void)tapOnce:(UIGestureRecognizer *)gesture
{
    if (self.showTopBar==YES) {
        [self.delegate changeTopBarStatus:NO];
        self.showTopBar=NO;
    }else{
        [self.delegate changeTopBarStatus:YES];
        self.showTopBar=YES;
    }
    NSLog(@"tapOnce");
    //on a single  tap, call zoomToRect in UIScrollView
//    [self.scrollView zoomToRect:rectToZoomInTo animated:NO];
}
- (void)tapTwice:(UIGestureRecognizer *)gesture
{
    NSLog(@"tapTwice");
    //on a double tap, call zoomToRect in UIScrollView
//    [self.scrollView zoomToRect:rectToZoomOutTo animated:NO];
}
//- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer {
//    if(self.zoomCheck){
//        CGPoint Pointview=[recognizer locationInView:self];
//        CGFloat newZoomscal=3.0;
//        
//        newZoomscal=MIN(newZoomscal, self.maximumZoomScale);
//
//        CGSize scrollViewSize=self.bounds.size;
//        
//        CGFloat w=scrollViewSize.width/newZoomscal;
//        CGFloat h=scrollViewSize.height /newZoomscal;
//        CGFloat x= Pointview.x-(w/2.0);
//        CGFloat y = Pointview.y-(h/2.0);
//        
//        CGRect rectTozoom=CGRectMake(x, y, w, h);
//        [self zoomToRect:rectTozoom animated:YES];
//        
//        [self setZoomScale:3.0 animated:YES];
//        zoomCheck=NO;
//    }
//    else{
//        [self setZoomScale:1.0 animated:YES];
//        zoomCheck=YES;
//    }
//}
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
