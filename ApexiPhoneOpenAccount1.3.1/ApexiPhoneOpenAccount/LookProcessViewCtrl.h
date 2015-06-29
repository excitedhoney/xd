//
//  LookProcessViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-22.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"
#import "RepointBankViewCtrl.h"

@interface LookProcessViewCtrl : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    @public
    NSMutableDictionary * khbdInfo;
    int dingZhiHeight;
    YEorNO shstate;                 //字符串等于0,上海a股就要重新指定
}

- (void)kaitongchaxun;

@end
