//
//  ShareOptionTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/25.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "ShareOptionTVC.h"
#import "NWValidate.h"
#import "Trip+Export.h"
#import "NWDataGetting.h"
#import "Trip+Days.h"

@interface ShareOptionTVC()
@property (weak, nonatomic) IBOutlet UITableViewCell *tripNameCell;
@property (weak, nonatomic) IBOutlet UIButton *export2TSV;
@property (weak, nonatomic) IBOutlet UIButton *export2CSV;


@end
@implementation ShareOptionTVC
-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tripNameCell.detailTextLabel.text=self.currentTrip.name;
}


#pragma mark - 事件
- (IBAction)save:(UIBarButtonItem *)sender {
    [self.delegate theSaveButtonOnTheShareOptionWasTapped:self];
    
}

- (IBAction)export2TSV:(UIButton *)sender {
    [self.currentTrip exportTripByType:ExportFileTSV];
    [self emailFileByType:ExportFileTSV];
}

- (IBAction)export2CSV:(UIButton *)sender {
    [self.currentTrip exportTripByType:ExportFileCSV];
    [self emailFileByType:ExportFileCSV];
}

-(void)emailFileByType:(ExportFileType)type{
    if ([MFMailComposeViewController canSendMail])
    {
        //建立物件與指定代理
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        //設定收件人
        //[mailController setToRecipients:@[@"yichun1121@gmail.com"]];
        //[mailController setCcRecipients:[NSArray arrayWithObjects:@"evelyn.y.yeh@gmail.com",@"yichun1121@gmail.com", nil]];
        //[mailController setBccRecipients:[NSArray arrayWithObjects:@"evelyn.y.yeh@gmail.com",@"yichun1121@gmail.com", nil]];
        
        //設定主旨
        [mailController setSubject:[NSString stringWithFormat:@" ★ LetsTravel2gether ✈ Travel Accounting：%@",self.currentTrip.name]];
        
        //設定內文並且不使用HTML語法
        //[mailController setMessageBody:@"Hi\n\n  The attached files are exported from LetsTravel2gether.\n\nFrom LetsTravel2gether" isHTML:NO];

        //下面這三句原本要做EmailTemplete的Localization，但是失敗，原因不明，於是先改用切換檔名方式
        //NSArray* availableLocalizations = [[NSBundle mainBundle] localizations];
        //NSArray* userPrefered = [NSBundle preferredLocalizationsFromArray:availableLocalizations forPreferences:[NSLocale preferredLanguages]];
        //NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"EmailTemplete" ofType:@"html"inDirectory:@"" forLocalization:[userPrefered objectAtIndex:0]];
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"EmailTemplete",@"LocalizedEmailTempleteName") ofType:@"html"];

        
        NSString *templeteString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        NSString *tripName=self.currentTrip.name;
        NSString *tripStart=[[Trip dateFormatter_Local]stringFromDate:self.currentTrip.startDate];
        NSString *tripEnd=[[Trip dateFormatter_Local]stringFromDate:self.currentTrip.endDate];
        NSString *subfileName=[self.currentTrip subfileNameByFileType:type];
        NSString *finalHtmlEmail=[NSString stringWithFormat:templeteString,tripName,tripStart,tripEnd,subfileName];
        //設定內文並且使用HTML語法
        [mailController setMessageBody:[NSString stringWithFormat:finalHtmlEmail,self.currentTrip.name] isHTML:YES];
        
        

//        //加入圖片
//        UIImage *theImage = [UIImage imageNamed:@"image.png"];
//        NSData *imageData = UIImagePNGRepresentation(theImage);
//        [mailController addAttachmentData:imageData mimeType:@"image/png" fileName:@"image"];
        
        NWDataGetting *dataGetter=[NWDataGetting new];
        //Item List
        NSString *fullItemPath=[self.currentTrip getItemExportRelativeFileNameByType:type];
        NSData *fileExportItem = [dataGetter getDataByFileName:fullItemPath];
        [mailController addAttachmentData:fileExportItem mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"items.%@",[self.currentTrip subfileNameByFileType:type ]]];
        
        //Receipt List
        NSString *fullReceiptPath=[self.currentTrip getReceiptExportRelativeFileNameByType:type];
        NSData *fileExportReceipt = [dataGetter getDataByFileName:fullReceiptPath];
        [mailController addAttachmentData:fileExportReceipt mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"receipts.%@",[self.currentTrip subfileNameByFileType:type ]]];

        
        //顯示電子郵件畫面
        [self presentViewController:mailController animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

#pragma mark - ➤ Navigation：Segue Settings
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Select Trip Segue From Share Main Page"]) {
        SelectTripCDTVC *selectTripCDTVC=[segue destinationViewController];
        selectTripCDTVC.managedObjectContext=self.managedObjectContext;
        selectTripCDTVC.selectedTrip=self.currentTrip;
        selectTripCDTVC.delegate=self;
    }
}
#pragma mark - Delegation
-(void)theTripCellOnSelectTripCDTVCWasTapped:(SelectTripCDTVC *)controller{
    if (controller.selectedTrip!=self.currentTrip) {
        self.currentTrip=controller.selectedTrip;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            [self popupView];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    //執行取消發送電子郵件畫面的動畫
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*!彈跳視窗提示已送出*/
-(void)popupView
{
    //------maskView---------
    CGRect maskRect=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIView *maskView=[[UIView alloc]initWithFrame:maskRect];
    maskView.backgroundColor=[UIColor blackColor];
    maskView.alpha=0.4f;
    //------popView--------
    float width=100;
    float height=100;
    float x=(self.view.frame.size.width-width)/2;
    float y=(self.view.frame.size.height-height)/3;
    CGRect popRect=CGRectMake(x, y, width, height);
    UIView *popView=[[UIView alloc]initWithFrame:popRect];
    //UIColor *bgColor=[UIColor colorWithRed:0.7 green:0.8 blue:1 alpha:1];
    popView.backgroundColor=[UIColor whiteColor];
    [popView.layer setCornerRadius:20.0f];
    //------label in popView-------
    CGRect lblRect=CGRectMake(0, 0, width, height);
    UILabel *label=[[UILabel alloc]initWithFrame:lblRect];
    label.textColor=[UIColor blackColor];
    label.text=NSLocalizedString(@"SentMail", @"Sent Message");
    label.textAlignment=NSTextAlignmentCenter;
    [popView addSubview:label];
    
    //add popView
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:maskView];
    [currentWindow addSubview:popView];
    
    maskView.hidden = NO;
    popView.hidden = NO;
    
    // 動畫淡出
    // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        maskView.alpha = 0.0f;
        popView.alpha=0.0f;
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        maskView.hidden = YES;
        popView.hidden = YES;
        
    }];
}
@end
