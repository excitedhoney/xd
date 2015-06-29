//
//  DepositBankViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-11.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"
#import "CertHandle.h"

@interface DepositBankViewCtrl : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,CertHandleDelegate,UIGestureRecognizerDelegate,CertHandleDelegate>{
    @public
    NSMutableArray * filterArray;
    BOOL hasLoaded;
    NSDictionary *bankCGXYDic;
    BOOL bIsRepointPage;
}


- (void)setViewBound;

@end
