//
//  ShareOptionTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/25.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "ShareOptionTVC.h"
#import "NWValidate.h"

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
}
- (IBAction)export2CSV:(UIButton *)sender {
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
    if ([NWValidate validateEmailWithString:self.email.text]) {
        self.export2CSV.enabled=YES;
        self.export2TSV.enabled=YES;
    }else{
        self.export2CSV.enabled=NO;
        self.export2TSV.enabled=NO;
    }
    return YES;
}
@end
