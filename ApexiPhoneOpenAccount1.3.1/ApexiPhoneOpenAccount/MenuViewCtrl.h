//
//  MenuViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-6-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"
#import "CustomIntroductionView.h"

@interface MenuViewCtrl : BaseViewController<MYIntroductionDelegate>{
    IBOutlet UIImageView * backImageView;
    IBOutlet UIButton * caculateButton;
    IBOutlet UIButton * borrowButton;
    IBOutlet UIButton * kaihuButton;
    IBOutlet UIView * centerView;
}

- (void)dispatchCheckVersion;

- (void)dispatchUploadConsoleLog;

- (void)onShowIntroductionView;

@end
