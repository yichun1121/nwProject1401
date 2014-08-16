//
//  ReceiptPhotoVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/7/23.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "ReceiptPhotoVC.h"
#import "PhotoContentVC.h"
#import "Receipt+Photo.h"
#import "Photo.h"
#import "Photo+Image.h"

@interface ReceiptPhotoVC ()

@end

@implementation ReceiptPhotoVC

@synthesize pageViewController=_pageViewController;

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
    // Do any additional setup after loading the view.
    PhotoContentVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}
- (PhotoContentVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.currentReceipt.photosOrdered count] == 0) || (index >= [self.currentReceipt.photosOrdered count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PhotoContentVC *photoContentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoContent"];
    Photo * photo=self.currentReceipt.photosOrdered[index];
    photoContentVC.image = photo.image;
    photoContentVC.pageIndex = index;
    photoContentVC.delegate=self;
    return photoContentVC;
}
#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PhotoContentVC*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PhotoContentVC*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.currentReceipt.photos count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
#pragma mark - lazy instantiation
-(UIPageViewController *)pageViewController{
    
    // Create page view controller
    if(!_pageViewController){
        self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        self.pageViewController.dataSource = self;
    }
    return _pageViewController;
}

#pragma mark - delegation
-(void)changeTopBarStatus:(BOOL)toShow{
    if (toShow) {
        [self.navigationController setNavigationBarHidden:NO];
    }else{
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
