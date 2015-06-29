//
//  VideoWitnessViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-10.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"

@interface VideoWitnessViewCtrl : BaseViewController<UIScrollViewDelegate>{
    @public
    NSString * roomid;
    NSString * uuid;
    
    IBOutlet UIButton * headerFlowButton;       //头部流程按钮
    IBOutlet UIView * centerView;               //中间提示界面；和作为本地界面
    IBOutlet UIView * remoteView;               //远程界面
    IBOutlet UIImageView * centerImageView;         //放主图标
    IBOutlet UILabel * tipLabel;
    IBOutlet UIButton * loginOrNextStepButton;
    IBOutlet UILabel * waitLabe;
}

-(void) BackToUrls:(id)sender;

@end
