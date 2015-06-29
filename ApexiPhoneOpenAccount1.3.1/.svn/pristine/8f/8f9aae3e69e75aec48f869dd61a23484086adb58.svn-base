//
//  AccountTypeViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-11.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"
#import "TTTAttributedLabel.h"
#import "framework.h"
#import "CertHandle.h"

@interface AccountTypeViewCtrl : BaseViewController<UIScrollViewDelegate,TTTAttributedLabelDelegate,CertHandleDelegate>
{
    IBOutlet UIButton * headerFlowButton;
    IBOutlet UILabel * tipLabel;
    IBOutlet UIView * centerView;              //帐户界面view
    IBOutlet UIButton * shAgImage;          //上海A股图片
    IBOutlet UIButton * shAgButton;            //上海A股按钮
    IBOutlet UIButton * szAgImage;          //深圳A股图片
    IBOutlet UIButton * szAgButton;            //深圳A股按钮
    IBOutlet UIButton * hkfsjjImage;        //沪开放式基金图片
    IBOutlet UIButton * hkfsjjButton;          //沪开放式基金按钮
    IBOutlet UIButton * skfsjjImage;        //深开放式基金图片
    IBOutlet UIButton * skfsjjButton;          //深开放式基金按钮
    IBOutlet UIButton * readAndUnderstandImage;      //阅读并完全理解图片
    IBOutlet UIButton * readAndUnderstandButton;        //阅读并完全理解按钮
    IBOutlet UIView * protocolView;                     //协议界面view
//    IBOutlet UIButton * nextStepButton;                 
}


@property (retain,nonatomic) id<InfosecSecurity> infosec;

- (IBAction)onItemTouch:(id)sender;

@end
