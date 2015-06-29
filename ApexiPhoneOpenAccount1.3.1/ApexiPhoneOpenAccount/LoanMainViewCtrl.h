//
//  LoanMainViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoanBaseViewCtrl;
//#import "BaseViewController.h"

@interface LoanMainViewCtrl : UITabBarController<UITabBarControllerDelegate>{
    @public
    BOOL       bTouchFirstPage;
    UIButton * me_RedCycleButton;
    UIButton * jk_RedCycleButton;
}

- (void)onPopMessageOperation:(UIViewController *)vc popToRoot:(BOOL)bRoot;

- (void)onLoadLoginVC:(LoanBaseViewCtrl *)rootLoanVC naviVC:(UINavigationController *)loanVC;

@end
