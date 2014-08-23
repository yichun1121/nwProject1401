//
//  ExportCSVFileCDTVC.m
//  TryTravel2gether
//
//  Created by vincent on 2014/8/22.
//  Copyright (c) 2014年 NW. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "ExportCSVFileCDTVC.h"
#import "SWRevealViewController.h"

@interface ExportCSVFileCDTVC ()

@end

@implementation ExportCSVFileCDTVC

@synthesize managedObjectContext=_managedObjectContext;

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
    //------Set Sidebar Menu--------
    [self setSidebarMenuAction];
    
}

-(void)findExportData
{
    NSString *entityName=@"Receipt";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    request.resultType=NSDictionaryResultType;
    
    NSError *error      = nil;
    NSArray *results    = [self.managedObjectContext executeFetchRequest:request
                                                                   error:&error];
    
}

-(void)exportCSVFile
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    //TODO: Trip加了index以後，用tripIndex當資料夾名字
    NSString *folderPath=[NSString stringWithFormat:@"%@/CSV/",basePath];
    //-----檢查預存放的資料夾路徑-------------------------
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        NSLog(@"folder path exists.");
    }else{
        NSLog(@"creating folder...");
        NSError *error=nil;
        //建立資料夾
        [[NSFileManager defaultManager]createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"fail to create folder, error: %@", [error localizedDescription]);
        }
 }
    
//    NSString *fileName=[NSString stringWithFormat:@"%lli.jpg",[@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue]];
//    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",folderPath,fileName];
    //-----儲存檔案-------------------------------------
//    bool saveSuccess=[binaryImageData writeToFile:imagePath atomically:YES];
//    if (saveSuccess) {
//        NSLog(@"save photo to file:%@",imagePath);
//    }else{
//        NSLog(@"failed to save photo:%@",imagePath);
//    }

}

-(void)sendMail:(NSString *) fullPath
{
    NSData *csvData =[NSData dataWithContentsOfFile:fullPath];
    //建立物件與指定代理
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    //設定收件人與主旨等資訊
    [controller setToRecipients:[NSArray arrayWithObject:@""]];
    [controller setSubject:@"Travel2gether CSV Export"];
    //設定內文並且不使用HTML語法
    [controller setMessageBody:@"" isHTML:NO];
    [controller addAttachmentData:csvData mimeType:@"text/csv" fileName:@"ExportTravel2gether.csv"];
    
    //加入圖片
//    UIImage *theImage = [UIImage imageNamed:@"image.png"];
//    NSData *imageData = UIImagePNGRepresentation(theImage);
//    [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"image"];

    
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        [self presentModalViewController:controller animated:YES];
    }
    
 
//    [controller release];
}



#pragma mark - Table view data source

-(void)setSidebarMenuAction{
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
#pragma mark 在sidebar menu下讓delete功能正常
    self.revealViewController.panGestureRecognizer.delegate = self;
    // Set the gesture （在下面delegation的地方）
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

@end
