//
//  SecretSetViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-11.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"

@interface SecretSetViewCtrl : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    @public
    NSMutableArray * rmmArray;
}

@end
