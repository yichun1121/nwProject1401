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

        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"EmailTemplete" ofType:@"html"];
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
@end
