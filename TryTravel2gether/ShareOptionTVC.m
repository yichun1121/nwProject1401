//
//  ShareOptionTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/25.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "ShareOptionTVC.h"
#import "NWValidate.h"
#import "Day.h"
#import "Receipt.h"
#import "Trip+Days.h"
#import "Item.h"
#import "CatInTrip.h"
#import "Itemcategory.h"
#import "Currency.h"
#import "DayCurrency.h"
#import "NWDataSaving.h"
#import "Trip+System.h"
#import "Item+Expend.h"


@interface ShareOptionTVC()
@property (weak, nonatomic) IBOutlet UITableViewCell *tripNameCell;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *export2TSV;
@property (weak, nonatomic) IBOutlet UIButton *export2CSV;


@end
@implementation ShareOptionTVC
-(void)viewDidLoad{
    [super viewDidLoad];
    self.email.delegate=self;
    self.export2CSV.enabled=NO;
    self.export2TSV.enabled=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.email];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tripNameCell.detailTextLabel.text=self.currentTrip.name;
}


#pragma mark - 事件
- (IBAction)save:(UIBarButtonItem *)sender {
    [self.delegate theSaveButtonOnTheShareOptionWasTapped:self];
    
}

typedef enum {
    ExportFileCSV,
    ExportFileTSV,
}ExportFileType;

- (IBAction)export2TSV:(UIButton *)sender {
    [self exportTrip:self.currentTrip ByType:ExportFileTSV];
}

- (IBAction)export2CSV:(UIButton *)sender {
    [self exportTrip:self.currentTrip ByType:ExportFileCSV];
}

-(BOOL)exportTrip:(Trip*)trip ByType:(ExportFileType)type{
    NSString *outputItemFormat=@"";
    NSString *outputReceiptFormat=@"";
    NSString *subFileName=@"";
    BOOL exportSuccess=NO;
    if (type==ExportFileCSV) {
        outputItemFormat=@"\n%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@";
        outputReceiptFormat=@"\n%@,%@,%@,%@,%@,%@,%@,%@";
        subFileName=@"csv";
    }else if (type==ExportFileTSV){
        outputItemFormat=@"\n%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@";
        outputReceiptFormat=@"\n%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@";
        subFileName=@"tsv";
    }
    //export item & receipt------------------------------------
    NSString *itemSavingString=@"";
    itemSavingString=[itemSavingString stringByAppendingString:[NSString stringWithFormat:outputItemFormat,@"流水號",@"日期",@"分類",@"收據說明",@"品項",@"幣別",@"單價",@"數量",@"原幣別金額",@"歸屬群組",@"分攤人數",@"對應收據代號",@"歸屬人",@"歸屬金額"]];


    NSString *receiptSavingString=@"";
    receiptSavingString=[receiptSavingString stringByAppendingString:[NSString stringWithFormat:outputReceiptFormat,@"收據代號",@"日期",@"收據說明",@"幣別",@"總金額",@"付款帳戶",@"付款方式",@"付款人"]];
    
    int itemSerial=0;
    //流水號格式：TxDxx，後加上收據在該天的流水號
    NSString *serTripID=@"T%@";
    serTripID=[NSString stringWithFormat:serTripID,trip.tripIndex];
    for (Day * day in trip.days) {
        NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc]init];
        [numberFormatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
        [numberFormatter setPaddingCharacter:@"0"];
        [numberFormatter setMinimumIntegerDigits:2];
        NSString *serDayID=[serTripID stringByAppendingString:[@"D" stringByAppendingString: [numberFormatter stringFromNumber: day.dayIndex]]];//旅遊日流水號
        int receiptSerial=0;

        for (Receipt * receipt in day.receipts) {
            receiptSerial=receiptSerial+1;
            //收據代號=旅遊日流水號+該日收據流水號
            NSString *receiptSerID=[serDayID stringByAppendingString:[NSString stringWithFormat:@"R%03i",receiptSerial]];
            NSString *thisCurrencySign=receipt.dayCurrency.currency.standardSign;
            NSString *thisReceiptDesc=receipt.desc;
            NSString *thisReceiptDayTime=[NSString stringWithFormat:@"%@ %@",[Trip.dateFormatter_GMT stringFromDate:receipt.day.date] ,[Trip.timeFormatter_GMT stringFromDate:receipt.time]];
            GuyInTrip *payedGuy=[receipt.account.guysInTrip anyObject];
            receiptSavingString=[receiptSavingString stringByAppendingString:[NSString stringWithFormat:outputReceiptFormat,
                                                          receiptSerID,
                                                          thisReceiptDayTime,
                                                          thisReceiptDesc,
                                                          thisCurrencySign,
                                                          [NSString stringWithFormat:@"%@",receipt.total],
                                                          receipt.account.name,
                                                          receipt.account.payWay.name,
                                                          payedGuy.guy.name
                                                          ]];
            for (Item *item in receipt.items) {
                itemSerial=itemSerial+1;
                for (GuyInTrip *guyInTrip in item.group.guysInTrip) {
                    itemSavingString=[itemSavingString stringByAppendingString:[NSString stringWithFormat:outputItemFormat,
                                                           [NSString stringWithFormat:@"R%05i",itemSerial],
                                                           thisReceiptDayTime,
                                                           item.catInTrip.category.name,
                                                           thisReceiptDesc,
                                                           item.name,
                                                           thisCurrencySign,
                                                           item.price,
                                                           item.quantity,
                                                           item.totalPrice,
                                                           item.group.name,
                                                           [NSString stringWithFormat:@"%lu", (unsigned long)item.group.guysInTrip.count],
                                                           receiptSerID,
                                                           guyInTrip.guy.name,
                                                           item.sharedPrice
                                                           ]];
                }
            }
        }
    }
    NSString *itemFileName=[NSString stringWithFormat:@"Trip%@_%@_items.%@",trip.tripIndex,trip.name,subFileName ];
    [NWDataSaving saveDataIntoFile:itemSavingString withName:itemFileName];
    NSString *receiptFileName=[NSString stringWithFormat:@"Trip%@_%@_receipts.%@",trip.tripIndex,trip.name,subFileName ];
    [NWDataSaving saveDataIntoFile:receiptSavingString withName:receiptFileName];
    return exportSuccess;
}

- (void)textFieldDidChange:(NSNotification *)notification {
    if ([NWValidate validateEmailWithString:self.email.text]) {
        self.export2CSV.enabled=YES;
        self.export2TSV.enabled=YES;
    }else{
        self.export2CSV.enabled=NO;
        self.export2TSV.enabled=NO;
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
#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
