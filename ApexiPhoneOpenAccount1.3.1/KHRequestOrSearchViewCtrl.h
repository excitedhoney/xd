//
//  KHRequestOrSearchViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"
#import "CertHandle.h"

@interface KHRequestOrSearchViewCtrl : BaseViewController<UIBarPositioningDelegate, CertHandleDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    
    
}

- (void) vcOperation:(UIViewController *)vc;

//跳转到前一页面
- (void)popToZDPage:(NSString *)step preVC:(BaseViewController *)vc;


@end
