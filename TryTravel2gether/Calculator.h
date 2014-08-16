//
//  Calculator.h
//  popupcontainer
//
//  Created by apple on 2014/7/26.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Calculator;
@protocol CalculatorDelegate <NSObject>
-(void)theCancelButtonOnCalcultorWasTapped:(Calculator *)controller;
-(void)theOkButtonOnCalcultorWasTapped:(Calculator *)controller;
@end

@interface Calculator : UIViewController
@property(strong, nonatomic) NSMutableArray * arrayOfStack;
@property(strong, nonatomic) NSNumber *result;
@property(weak,nonatomic) id<CalculatorDelegate>delegate;


- (IBAction)okClick:(id)sender;
- (IBAction)cancelClick:(id)sender;

@end
