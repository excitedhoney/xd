//
//  ClientInfoViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-8.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"
#import "TTTAttributedLabel.h"
#import "FlatDatePicker.h"

@interface ClientInfoViewCtrl : BaseViewController<UIScrollViewDelegate,UITextFieldDelegate,TTTAttributedLabelDelegate,FlatDatePickerDelegate,UIGestureRecognizerDelegate>{
    @public
    NSString * HTXYID;
    NSMutableDictionary * jbzl_step_OCR_Dic;
    NSMutableDictionary * jbzl_enterData_Dic;
    
}


- (void) failGetOcrData;


@end
