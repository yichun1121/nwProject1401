//
//  Calculator.m
//  popupcontainer
//
//  Created by apple on 2014/7/26.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "Calculator.h"

@interface Calculator ()
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (nonatomic) BOOL userIsInTheMiddleofEnteringANumber;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (nonatomic, strong) NSString * operator;
@end

@implementation Calculator

@synthesize display=_display;
@synthesize arrayOfStack=_arrayOfStack;
@synthesize userIsInTheMiddleofEnteringANumber;
@synthesize description;


-(NSMutableArray *)arrayOfStack
{
    if(!_arrayOfStack){
        _arrayOfStack=[NSMutableArray new];
    }
    return _arrayOfStack;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//畫面初始顯示為零
    self.display.text = @"0";
    self.result=0;
    self.description.text=@"";
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"elements of array2 in calculator =%lu",(unsigned long)[self.arrayOfStack count]);
    self.userIsInTheMiddleofEnteringANumber=NO;
    if ([self.arrayOfStack count]!=0) {
        [self calculatorBrian];
        [self descriptionOfCalculation];
    }
}

- (IBAction)digitPressed:(id)sender {

    //把初始的零、使用者確定輸入完成的數字消掉
    if ([self.display.text isEqual:@"0"]||self.userIsInTheMiddleofEnteringANumber==NO) {
        self.display.text=@"";
    }
    self.userIsInTheMiddleofEnteringANumber=YES;
    NSString *digit = [sender currentTitle];
    
    //檢查小數點有無重複出現
    if ([@"." isEqualToString:digit]) {
        NSRange range= [self.display.text rangeOfString:@"."];
        if (range.location==NSNotFound) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    }else{
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    //清除button顏色
    for (UIView *sub in self.view.subviews) {
        if ([sub isKindOfClass:[UIButton class]]&& sub.tag!=99) {
            UIButton *btn=(UIButton *)sub;
            btn.backgroundColor=[UIColor clearColor];
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    sender.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:1 alpha:0.6];
    //先把operationPressed前的數字記在Array中
    if (self.userIsInTheMiddleofEnteringANumber==YES) {
        [self.arrayOfStack addObject:self.display.text];
        [self calculatorBrian];
    }
    
    self.userIsInTheMiddleofEnteringANumber=NO;
    [self descriptionOfCalculation];
    
    self.result=[NSNumber numberWithDouble:[self.display.text doubleValue]];
    
    
    //再把operator存進array
    self.operator=[sender currentTitle];
    [self.arrayOfStack addObject:[sender currentTitle]];
    [self descriptionOfCalculation];
}
- (IBAction)enterPressed:(UIButton *)sender {
    
    if(self.userIsInTheMiddleofEnteringANumber==YES){
    [self.arrayOfStack addObject:self.display.text];
    }
    
    [self descriptionOfCalculation];
    [self calculatorBrian];
    self.userIsInTheMiddleofEnteringANumber=NO;

}
- (IBAction)backPressed:(id)sender {
    if ([self.display.text length]>0) {
        self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
    }
    if([self.display.text isEqualToString:@""]){
        self.display.text=@"0";
    }
    [self descriptionOfCalculation];
    
}
- (IBAction)clearPressed:(id)sender {
    
    self.display.text=@"0";
    [self.arrayOfStack removeAllObjects];
    self.description.text=@"";
    self.result=0;
    self.operator=@"";
    self.userIsInTheMiddleofEnteringANumber=YES;
}
-(void)calculatorBrian{
    
    if ([self.arrayOfStack count]==1) {
        self.result=[self.arrayOfStack objectAtIndex:0];
    }else if(self.userIsInTheMiddleofEnteringANumber==YES){
        double temp=0;
        if ([self.operator isEqualToString:@"+"]) {
            temp=[self.result doubleValue]+[self.display.text doubleValue];
        }else if ([self.operator isEqualToString:@"-"]) {
            temp=[self.result doubleValue]-[self.display.text doubleValue];
        }else if ([self.operator isEqualToString:@"×"]) {
            temp=[self.result doubleValue]*[self.display.text doubleValue];
        }else if ([self.operator isEqualToString:@"÷"]) {
            if([self.display.text doubleValue]!=0){
                temp=[self.result doubleValue]/[self.display.text doubleValue];
            }else{
                temp=0;
            }
        }
        self.result=[NSNumber numberWithDouble:temp];
    }
    
    self.display.text=[NSString stringWithFormat:@"%@",self.result];

}



-(void)descriptionOfCalculation{
    if (self.arrayOfStack!=nil) {
        self.description.text=@"";
        for (int i=0;i<[self.arrayOfStack count];i++) {
            id obj=[self.arrayOfStack objectAtIndex:i];
            if ([obj isEqualToString:@"×"]||[obj isEqualToString:@"÷"]) {
                if (i>2) {
                    id twobeforeobj=[self.arrayOfStack objectAtIndex:i-2];
                    if([twobeforeobj isEqualToString:@"+"]||[twobeforeobj isEqualToString:@"-"]){
                        self.description.text=[NSString stringWithFormat:@"(%@)%@",self.description.text,obj];
                    }else{
                        self.description.text=[self.description.text stringByAppendingString:[NSString stringWithFormat:@"%@",obj]];
                    }
                }else{
                    self.description.text=[self.description.text stringByAppendingString:[NSString stringWithFormat:@"%@",obj]];
                }
            }else{
                self.description.text=[self.description.text stringByAppendingString:[NSString stringWithFormat:@"%@",obj]];
            }
        }
        
    }
    if ([self.operator isEqualToString:@"÷"]&&[self.display.text doubleValue]==0) {
        self.description.text=@"Error";
    }
    
}

- (IBAction)okClick:(id)sender
{
    
    //如果沒按Enter，就幫忙按
    if (self.userIsInTheMiddleofEnteringANumber==YES) {
        [self enterPressed:sender];
    }
    
    [self.delegate theOkButtonOnCalcultorWasTapped:self];
    
}

- (IBAction)cancelClick:(id)sender
{
    [self.delegate theCancelButtonOnCalcultorWasTapped:self];
    
}

@end
