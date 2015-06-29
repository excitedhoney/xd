//
//  KHRequestOrSearchViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "KHRequestOrSearchViewCtrl.h"
#import "UploadImageViewCtrl.h"
#import "RiskEvaluateViewCtrl.h"
#import "ReturnVisitViewCtrl.h"
#import "VideoWitnessViewCtrl.h"
#import <CoreFoundation/CoreFoundation.h>
#import "RootModelViewCtrl.h"
#import "UINavigationBar+Frame.h"
#import "ClientInfoViewCtrl.h"
//#import "ViewController.h"
#import "InstallProfileViewCtrl.h"
#import "SecretSetViewCtrl.h"
#import "DepositBankViewCtrl.h"
#import "RiskEvaluateViewCtrl.h"
#import "AccountTypeViewCtrl.h"
#import "ReturnVisitViewCtrl.h"
#import "VideoWitnessViewCtrl.h"
#import "LookProcessViewCtrl.h"
#import "CusObject.h"
#import "SettingViewController.h"

#define  serviceTag  1990

@interface KHRequestOrSearchViewCtrl (){
    UITextField * phoneEditor;
    UITextField * verifyEditor;
    CGRect centerViewNormalRect;
    NSMutableArray * verifyTitlts;
    NSTimer * verifyTextMonitor;
    int timeLeft;
    CGRect staticVerifyFieldRect;
    CGRect staticVerifyButtonRect;
    UIScrollView *rootScollView;
    UITextField *ocusView;
    UIButton * verifyButton;
    UITextField * dialogTextfield;
    UITextField * sureTextField;
    BOOL bSetPasswordFinish;
}

@end

@implementation KHRequestOrSearchViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView{
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated{
    if([SJKHEngine Instance]->SJHM && [SJKHEngine Instance]->SJHM.length > 0){
        [phoneEditor setText:[SJKHEngine Instance]->SJHM];
    }
    
    if([SJKHEngine Instance]->systemVersion >= 7){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    
//    [self addGesture:self.navigationController.navigationBar];
    
//    UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ButtonHeight, ButtonHeight)];
//    [cancelButton setImage:[UIImage imageNamed:@"button_back_default"] forState:UIControlStateNormal];
//    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
//    [cancelButton addTarget:self action:@selector(onCancelCurrentOperation:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
//    self.navigationItem.leftBarButtonItem = cancelItem;
    
//    UIButton * btn = self.navigationItem.leftBarButtonItem.customView;
//    NSLog(@"customview =%@,%@,%@",btn,[btn allTargets],((UILabel *)self.navigationItem.titleView).text);
//    [((UILabel *)self.navigationItem.titleView) setText:@"abcded"];
    
    [self.navigationItem.leftBarButtonItem.customView setAlpha:1];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar removeGestureRecognizer:singleTapRecognizer];
    [phoneEditor resignFirstResponder];
    [verifyEditor resignFirstResponder];
}

static bool showSettingVC = YES;
- (void)viewDidAppear:(BOOL)animated{
    BaseViewController * vc =nil;
    
//    vc = [[AccountTypeViewCtrl alloc]initWithNibName:@"AccountTypeView" bundle:nil];
//    vc = [[InstallProfileViewCtrl alloc]init];
//    vc = [[VideoWitnessViewCtrl alloc]initWithNibName:@"VideoWitnessView" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
    if(showSettingVC){
//        SettingViewController * settingVC = [[SettingViewController alloc]init];
//        UINavigationController * naviVC = [[UINavigationController alloc]initWithRootViewController:settingVC];
//        [self presentModalViewController:naviVC animated:YES];
        showSettingVC = NO;
    }
    [super viewDidAppear:animated];
}

static  double tt = 0;

- (void)viewDidLoad
{
    tt = CFAbsoluteTimeGetCurrent();
    [self InitConfig];
    [self InitWidgets];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
//    NSLog(@"zhi =%@",[SJKHEngine Instance]->dic);
//    [self.view removeObserver:self forKeyPath:@"frame"];
    [phoneEditor removeFromSuperview];
    phoneEditor = nil;
    [verifyEditor removeFromSuperview];
    verifyEditor = nil;
    
    [verifyTextMonitor invalidate];
    verifyTextMonitor = nil;
    [rootScollView removeFromSuperview];
    rootScollView = nil;
    [ocusView removeFromSuperview];
    ocusView = nil;
    [verifyButton removeFromSuperview];
    verifyButton = nil;
    [dialogTextfield removeFromSuperview];
    dialogTextfield = nil;
    
    NSLog(@"验证码页面回收");
}

- (void)vcOperation:(UIViewController *)vc{
//    [[SJKHEngine Instance] backToKaiHuLoginVCAndDealloc];
//
//    return;
    
    [[SJKHEngine Instance] onClearKaihuData];
    
    NSArray * ar = [self.navigationController childViewControllers];
    NSLog(@"vcs vcOperation =%@",self.navigationController.viewControllers);
    
    if([[ar lastObject] isMemberOfClass:[KHRequestOrSearchViewCtrl class]] ||
       [[ar lastObject] isMemberOfClass:[VideoWitnessViewCtrl class]])
    {
        [[ar lastObject] backOperation];
    }
    
    if(vc == Nil){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [SJKHEngine Instance]->rootVC = nil;
        __strong BaseViewController * _vc;
        for (int i = 1;i< ar.count; i++) {
            _vc = [ar objectAtIndex:i];
            if(![_vc isMemberOfClass:[KHRequestOrSearchViewCtrl class]]){
                
                __strong UIViewController * viewCtrl;
                for(viewCtrl in _vc.childViewControllers){
                    if([viewCtrl isMemberOfClass:[DepositBankViewCtrl class]]){
                        [[SJKHEngine Instance].observeCtrls removeObject:viewCtrl];
                        [viewCtrl removeFromParentViewController];
                        [viewCtrl.view removeFromSuperview];
                        viewCtrl = nil;
                        break ;
                    }
                }
                
                [[SJKHEngine Instance].observeCtrls removeObject:_vc];
                [_vc removeFromParentViewController];
                _vc = nil;
            }
        }
    }
    
    @autoreleasepool {
//        if(ar.count > 0){
//            BaseViewController *baseVC = [ar objectAtIndex:0];
//            [[SJKHEngine Instance].observeCtrls removeObject:baseVC];
//            [baseVC removeFromParentViewController];
//            [baseVC.view removeFromSuperview];
//            baseVC = nil;
//        }
    }
    
//    [[SJKHEngine Instance]->rootVC addChildViewController:vc];
//    [[SJKHEngine Instance]->rootVC.view addSubview:vc.view];
//    [vc.view.layer addAnimation:[SJKHEngine Instance]->rightTransition forKey:Nil];
}

- (void)backOperation{
    [self verifyButtonChange:NO];
}

#pragma tool methods
- (void)InitConfig{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
//    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:nil style: UIBarButtonItemStyleBordered target:nil action: nil];
    
//    UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [cancelButton setUserInteractionEnabled:NO];
////    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
//    [self.navigationController.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    self.navigationController.navigationBar.translucent = NO;
    bKeyBoardShow = NO;
    bSetPasswordFinish = NO;
    [SJKHEngine Instance]->rootVC = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage
                         imageWithColor:NAV_BG_COLOR
                         size:CGSizeMake(screenWidth, NAV_HEIGHT)]
                                                  forBarMetrics:UIBarMetricsDefault];
    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"bg_menu"] clipImagefromRect:CGRectMake(0, 8, screenWidth, 20)]
//                                                  forBarMetrics:UIBarMetricsDefault];
    
    NSLog(@" [SJKHEngine Instance]->rootVC =%@",[SJKHEngine Instance]->rootVC);
    
//    NSMutableDictionary *stepDic = nil;
//    CusObject * cus = [[CusObject alloc]init];
//    cus.de = @"123456789";
//    [SJKHEngine Instance]->dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:cus.de,@"a",@"3",@"b", nil];
//    [self sendSaveStepInfo:@"zsgl" dataDictionary:&stepDic arrar:[SJKHEngine Instance]->dic];
//    NSLog(@"dic arc =%@",[SJKHEngine Instance]->dic);
}

- (void)fieldTextChanged:(NSNotification *)noti{
    UITextField * textField = noti.object;
    NSString * fieldText = textField.text;
    
    if(!textField.markedTextRange){
        if(fieldText.length > 11 && textField == phoneEditor){
            [textField setText:[fieldText substringToIndex:11]];
        }
        if(fieldText.length > 6 && textField == dialogTextfield){
            [textField setText:[fieldText substringToIndex:6]];
        }
        if(fieldText.length > 6 && textField == sureTextField){
            [textField setText:[fieldText substringToIndex:6]];
        }
        if(fieldText.length > 6 && textField == verifyEditor){
            [textField setText:[fieldText substringToIndex:6]];
        }
    }
}

//- (void)saveSuccessContinueOpetion:(BOOL)bSaveSuccess{
//    NSLog(@"kankan =%@",[SJKHEngine Instance]->dic);
//    [self activityIndicate:NO tipContent:NO MBProgressHUD:nil target:nil];
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    NSLog(@"change =%@",change);
//    if([[change objectForKey:@"old"]intValue] == 2){
//        
//    }
//}

//- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
//{
//    return UIBarPositionTopAttached;
//}

- (void) InitWidgets{
    [super InitWidgets];
    rootScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - (IOS7_SYS?64:44))];
    rootScollView.bounces = NO;
    rootScollView.backgroundColor = PAGE_BG_COLOR;
    rootScollView.delegate = self;
//    [rootScollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouchDownResign:)]];
    [self addGesture:rootScollView];
    
    if([SJKHEngine Instance]->systemVersion < 6){
        singleTapRecognizer.delegate = self;
    }
    
//    CGSize size = CGSizeMake(screenWidth, screenHeight);
    [rootScollView setShowsVerticalScrollIndicator:NO];
    verifyTitlts = [NSMutableArray arrayWithObjects:@"获取验证码",@"重新获取验证码", nil];
    float width = [PublicMethod getStringWidth:[verifyTitlts objectAtIndex:0] font:TipFont] + 2*Padding;
    int fieldWidth = (screenWidth - levelSpace * 6) - width;
    
    [rootScollView setAlpha:1];
    
    UIImageView *banner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner.png"]];
    [banner setUserInteractionEnabled:NO];
    banner.frame = CGRectMake(0, 0, screenWidth, screenWidth + 10);
    banner.backgroundColor = BTN_DEFAULT_REDBG_COLOR;
    [rootScollView addSubview:banner];
    
//    UILabel * tipLabel = [PublicMethod initLabelWithFrame:CGRectMake(0, banner.frame.size.height, screenWidth, ButtonHeight) title:@"为了顺利开户,请您勿必填写真实信息!" target:rootScollView];
//    tipLabel.textAlignment = UITextAlignmentCenter;
//    tipLabel.textColor = GrayTipColor_Wu;
    
    float space = 10;
    phoneEditor = [PublicMethod CreateField:@"请输入您的手机号码" withFrame:CGRectMake(levelSpace , banner.frame.size.height + space, screenWidth - levelSpace * 2, ButtonHeight) tag:serviceTag target:rootScollView];
    phoneEditor.delegate = self;
    [phoneEditor positSpace:yep];
    
    verifyEditor = [PublicMethod CreateField:@"手机验证码" withFrame:CGRectMake(levelSpace , ButtonHeight  + space*2 + banner.frame.size.height,fieldWidth,ButtonHeight) tag:serviceTag + 2 target:rootScollView];
    verifyEditor.delegate =self;
    [verifyEditor positSpace:yep];
    staticVerifyFieldRect = verifyEditor.frame;
    
    verifyButton = [PublicMethod CreateButton:[verifyTitlts objectAtIndex:0]
                                               withFrame:CGRectMake(levelSpace*2 + fieldWidth,
                                                                ButtonHeight + space*2 + banner.frame.size.height,
                                                                width + 3*levelSpace,
                                                                ButtonHeight)
                                                 tag:serviceTag + 1
                                              target:rootScollView];
    verifyButton.titleLabel.font = PublicBoldFont;
    [verifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [verifyButton setBackgroundColor:LikeWhiteColor];
    verifyButton.layer.cornerRadius = 2;
    verifyButton.layer.masksToBounds = YES;
    verifyButton.layer.borderWidth = 0;
    verifyButton.backgroundColor = CLEAR_COLOR;
    [verifyButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [verifyButton setBackgroundImage:[[UIImage imageNamed:BTN_GRAY_NORMAL] stretchableImageWithLeftCapWidth:8 topCapHeight:8]  forState:UIControlStateNormal];
    [verifyButton setBackgroundImage:[[UIImage imageNamed:BTN_GRAY_HIGH] stretchableImageWithLeftCapWidth:8 topCapHeight:8]  forState:UIControlStateHighlighted];
    staticVerifyButtonRect = verifyButton.frame;
    
    [self InitNextStepButton:CGRectMake (levelSpace,
                                         verifyButton.frame.origin.y + ButtonHeight + space,
                                         screenWidth - 2 * levelSpace,
                                         ButtonHeight)
                         tag:serviceTag + 3
                       title:@"下一步"];
    [rootScollView addSubview:nextStepBtn];
    
    rootScollView.contentSize = CGSizeMake(screenWidth, nextStepBtn.frame.origin.y  + ButtonHeight + verticalHeight*2);
    [self.view addSubview:rootScollView];
}

//- (CGRect)placeholderRectForBounds:(CGRect)bounds{
//    return CGRectMake(levelSpace, (ButtonHeight - 30)/2 , bounds.size.width , 30);
//}

- (void)OnTouchDownResign:(UIControl *)control{
    [self resignAllResponse];
}

static bool bTest = YES;
- (void)onButtonClick:(UIButton *)btn{    
    [phoneEditor resignFirstResponder];
    [verifyEditor resignFirstResponder];
    
    
//    [self performSelectorOnMainThread:@selector(onShowAlert:) withObject:alertTitleString waitUntilDone:YES];
//    
//    return;
    
    switch (btn.tag) {
        case serviceTag + 1:{
            
#ifdef SelectTest
//            VideoWitnessViewCtrl * witnessVC = [[VideoWitnessViewCtrl alloc]init];
//            [self.navigationController pushViewController:witnessVC animated:YES];
            
//            InstallProfileViewCtrl * installVC = [[InstallProfileViewCtrl alloc]init];
//            [self.navigationController pushViewController:installVC animated:YES];
            
//            SecretSetViewCtrl *secretVC = [[SecretSetViewCtrl alloc]init];
//            [self.navigationController pushViewController:secretVC animated:YES];
            
//            DepositBankViewCtrl * depositVC = [[DepositBankViewCtrl alloc]init];
//            [self.navigationController pushViewController:depositVC animated:YES];
            
//            RiskEvaluateViewCtrl * riskVC = [[RiskEvaluateViewCtrl alloc]init];
//            [self.navigationController pushViewController:riskVC animated:YES];
            
//            ReturnVisitViewCtrl * returnVC = [[ReturnVisitViewCtrl alloc]init];
//            [self.navigationController pushViewController:returnVC animated:YES];
            
//            ClientInfoViewCtrl * clientVC = [[ClientInfoViewCtrl alloc]init];
//            [self.navigationController pushViewController:clientVC animated:YES];
            
//            AccountTypeViewCtrl * accountVC =[[AccountTypeViewCtrl alloc]init];
//            [self.navigationController pushViewController:accountVC animated:YES];

//            ReturnVisitViewCtrl *returnVC = [[ReturnVisitViewCtrl alloc]init];
////            [self.navigationController pushViewController:returnVC animated:YES];
//            NSArray * ar = [self getViewControllersByStep:returnVC];
//            [self.navigationController setViewControllers:ar animated:YES];
//            
//            return ;
//            [returnVC updateUI];
            
//            UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
//            [self.navigationController pushViewController:uploadVC animated:YES];
//
//            return;
//            LookProcessViewCtrl * lookVC =[[LookProcessViewCtrl alloc]init];
//            [self.navigationController pushViewController:lookVC animated:YES];
            
#endif
            
            NSString * text = [phoneEditor.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if(text && text.length > 0){
                [self verifyButtonChange:YES];
                [self ServerAuthenticate:HQNZM_REQUEST];
            }
            else{
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先输入手机号码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertview show];
            }
            break;
        }
            //开户申请或转户
        case serviceTag + 3:{
#ifdef SelectTest
//            UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
//            [self addChildViewController:uploadVC];
//            [self.view addSubview:uploadVC.view];
            
//            LookProcessViewCtrl * lookVC =[[LookProcessViewCtrl alloc]init];
//            [self.navigationController pushViewController:lookVC animated:YES];
//            
//            return ;
#endif
            
            [self verifyButtonChange:NO];
            
//            if(!bTest){
//                LookProcessViewCtrl * lookVC = [[LookProcessViewCtrl alloc]init];
//                [self.navigationController pushViewController:lookVC animated:YES];
//                return ;
//            }
//            else{
//                bTest = NO;
                [self ServerAuthenticate:NZNZM_REQUEST];
//                break;
//            }
        }
    }
}

- (void)verifyButtonChange:(BOOL)isWait{
    UIButton * verifyButton = (UIButton *)[rootScollView viewWithTag: serviceTag + 1];
    
    if(isWait){
        timeLeft = 60;
        verifyTextMonitor = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setVerifyTitle:) userInfo:verifyButton repeats:YES];
        NSString * title = [[verifyTitlts objectAtIndex:1] stringByAppendingString:@"(60s)"];
        float width = [PublicMethod getStringWidth:title font:TipFont] + 2*Padding;
        float verifyFieldWidth = (screenWidth - levelSpace*3) - width;
        [verifyButton setTitle:title forState:UIControlStateNormal];
        [verifyButton setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.2 animations:^{
            [verifyEditor setFrame:CGRectMake(levelSpace, staticVerifyFieldRect.origin.y, verifyFieldWidth, staticVerifyFieldRect.size.height)];
            [verifyButton setFrame:CGRectMake(levelSpace * 2 + verifyFieldWidth, staticVerifyButtonRect.origin.y, width, staticVerifyButtonRect.size.height)];
        }completion:^(BOOL finish){
            
        }];
    }
    else{
        if (verifyTextMonitor != nil) {
            [verifyTextMonitor invalidate];
            verifyTextMonitor = nil;
        }
        [verifyButton setTitle:[verifyTitlts objectAtIndex:0] forState:UIControlStateNormal];
        [verifyButton setUserInteractionEnabled:YES];
        [UIView animateWithDuration:0.2 animations:^{
            [verifyEditor setFrame:staticVerifyFieldRect];
            [verifyButton setFrame:staticVerifyButtonRect];
        }completion:^(BOOL finish){
            
        }];
    }
}

- (void)setVerifyTitle:(NSTimer *)timer{
    UIButton * btn = [timer userInfo];
    NSString * title = [[verifyTitlts objectAtIndex:1] stringByAppendingFormat: @"(%is)",--timeLeft];
    [btn setTitle:title forState:UIControlStateNormal];
    if(timeLeft == 0){
        [self verifyButtonChange:NO];
    }
}

- (void)ServerAuthenticate:(REQUEST_TYPE)request_type{
    NSString * urlComponent = nil;
    
    switch (request_type) {
        case HQNZM_REQUEST:{
            urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,HQNZM];
            break;
        }
        case NZNZM_REQUEST:
            urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,NZNZM];
            break;
    }
    NSURL * URL = [NSURL URLWithString:urlComponent];
    
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:[PublicMethod suburlString:URL]];
    //    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://192.168.1.108:8443/WebServer/request.jsp"]];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    
    //为调试https://192.168.1.108:8443/WebServer/request.jsp而作的操作。
    //    [theRequest setTimeOutSeconds:15];
    //    [theRequest startAsynchronous];
    //
    //    return ;
    
    NSArray *ar = [PublicMethod convertURLToArray:[URL absoluteString]];
    if(ar.count > 0){
        switch (request_type) {
            case HQNZM_REQUEST:{
                NSString * phoneText = [phoneEditor.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                if(![PublicMethod validateCellPhone:phoneText]){
                    [self verifyButtonChange:NO];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil
                                                                    message: @"请输入正确的手机号码"
                                                                   delegate: self
                                                          cancelButtonTitle: @"我知道了!"
                                                          otherButtonTitles: nil];
                    [alert show];
                    return;
                }
                
                theRequest.request_type = HQNZM_REQUEST;
                [theRequest setDelegate:self];
                [theRequest setDidFailSelector:@selector(httpFailed:)];
                [theRequest setDidFinishSelector:@selector(httpFinished:)];
                
                [theRequest setPostValue:phoneText forKey:[ar firstObject]];
                [theRequest startAsynchronous];
                break;
            }
            case NZNZM_REQUEST:{
                #ifndef Test
                if (phoneEditor.text.length == 0 || verifyEditor.text.length == 0)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"开户提示"
                                                                    message: @"请输入手机号码或验证码."
                                                                   delegate: self
                                                          cancelButtonTitle: @"我知道了!"
                                                          otherButtonTitles: nil];
                    [alert show];
                    return;
                }
                #endif
                [self activityIndicate:YES tipContent:@"正在登录..." MBProgressHUD:nil target:self.navigationController.view];
                [self dispatchUploadImageViewCtrl:ar request:theRequest];
            }
        }
    }
}

- (void)dispatchUploadImageViewCtrl:(NSArray *)ar request:(ASIFormDataRequest *)theRequest{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [theRequest setPostValue:[phoneEditor.text stringByReplacingOccurrencesOfString:@" " withString:@""]
                          forKey:[ar firstObject]];
        [theRequest setPostValue:[verifyEditor.text stringByReplacingOccurrencesOfString:@" " withString:@""]
                          forKey:[ar objectAtIndex:1]];
        
        NSDictionary * responseDic = nil;
        
        [theRequest startSynchronous];
        
        if(theRequest.responseData){
            [self verifyButtonChange:NO];
            responseDic = [NSJSONSerialization JSONObjectWithData:theRequest.responseData options:NSJSONReadingMutableContainers error:Nil] ;
            
            NSLog(@"responseDic:\n%@",responseDic);
            
            [SJKHEngine Instance]->isKaiHuOVER = nop;
            
            NSLog(@"khbdinfo:\n%@",[responseDic objectForKey:@"khbdinfo"]);
            NSLog(@"count:\n%d",((NSDictionary *)[responseDic objectForKey:@"khbdinfo"]).count);
            
            if ([responseDic objectForKey:@"khbdinfo"] && ((NSDictionary *)[responseDic objectForKey:@"khbdinfo"]).count) {
                [SJKHEngine Instance]->isKaiHuOVER = yep;
                [SJKHEngine Instance]->khbd_info_Dic = [[responseDic objectForKey:@"khbdinfo"] mutableCopy];
            }
            else{
                [SJKHEngine Instance]->isKaiHuOVER = nop;
                NSString * phontText = phoneEditor.text;
                [PublicMethod trimText:&phontText];
                [SJKHEngine Instance]->khsq_info_Dic = [[responseDic objectForKey:phontText] mutableCopy];
            }
            NSLog(@"khsq_info_Dic = %@",[SJKHEngine Instance]->khsq_info_Dic);
            
            NSString * tip = nil;
            
            if([responseDic objectForKey:NOTE]){
//                tip = [PublicMethod getNSStringFromCstring:[[responseDic objectForKey:NOTE] UTF8String]];
            }
            if(responseDic && ([[responseDic objectForKey:SUCCESS] intValue] == 1 || [[responseDic objectForKey:SUCCESS] boolValue] == true))
            {
                [SJKHEngine Instance]->SJHM = [phoneEditor.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                [PublicMethod saveToUserDefaults:[SJKHEngine Instance]->SJHM key:SJHMNUMBER];
                
                //如果已经申请成功，则直接处理，不往下派发
                if([responseDic objectForKey:KhbdInfo]){
                    NSMutableDictionary * khbdinfo = [responseDic objectForKey:KhbdInfo];
                    if (![self vailToCert]) {
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                        LookProcessViewCtrl * lookVC = [[LookProcessViewCtrl alloc]init];
                        lookVC->khbdInfo = [khbdinfo mutableCopy];
                        [self.navigationController pushViewController:lookVC animated:YES];
                    });
                    
                    return ;
                }
                
                NSDictionary * dic = [responseDic objectForKey:[SJKHEngine Instance]->SJHM];
                if(dic){
                    NSString * step = [dic objectForKey:CurrentStep_Login];
                    NSLog(@"step_%@_",step);
                    if (!step || !step.length) {
                        
                    }
                    else if(step.length &&
                        ![step isEqualToString:YXCJ_STEP] &&
                        ![step isEqualToString:JBZL_STEP] &&
                        ![step isEqualToString:SPJZ_STEP] &&
                        ![step isEqualToString:ZSGL_STEP])
                    {
                        if (![self vailToCert]) {
                            return;
                        }
                        else {
                            [self activityIndicate:YES tipContent:@"页面加载中..." MBProgressHUD:nil target:self.navigationController.view];
                        }
                    }
                    
                    NSDictionary * stepResponseDic = nil;
                    //如果是视频见证步骤，则加载khjbzl，因为在startagent()中要传入username.后续步骤可能还要用到jbzl数据。
                    if([dic objectForKey:StepData_Login]){
                        [SJKHEngine Instance]->jbzl_cache_dic = [[dic objectForKey:StepData_Login] objectForKey:JBZL_STEP];
                    }
                    if(step.length == 0 || step == Nil){
                        step = YXCJ_STEP;
                    }
                    
                    BaseViewController * vc = [self getVCByStep:step];
                    
                    [self goZDPage:step viewCtrl:vc frontVC:nil];
                    
                }
                else{
                    [self activityIndicate:NO tipContent:@"加载数据失败" MBProgressHUD:hud target:self.navigationController.view];
                }
            }
            else{
                NSString * tipContent = @"登录失败";
                if([responseDic objectForKey:NOTE]){
                    tipContent = [responseDic objectForKey:NOTE];
                }
                [self activityIndicate:NO tipContent:tipContent MBProgressHUD:hud target:self.navigationController.view];
            }
        }
        else{
            [self activityIndicate:NO tipContent:@"登录失败" MBProgressHUD:hud target:self.navigationController.view];
        }
    });
}

- (void)reposControl{
    int offset = 0;
    
    if([SJKHEngine Instance]->systemVersion >= 7){
        offset = 64;
    }
    else{
        offset = 0;
    }
    
	if (bKeyBoardShow)
	{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, offset-(keyboardOffset + 10), screenWidth, screenHeight - UpHeight );
        }
        completion:^(BOOL finish){
            
        }];
	}
	else
	{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, offset, screenWidth, screenHeight - UpHeight );
        }completion:^(BOOL finish){
            
        }];
	}
}

- (void)popToZDPage:(NSString *)step preVC:(BaseViewController *)vc{
    [self activityIndicate:YES tipContent:@"页面跳转中..." MBProgressHUD:nil target:self.navigationController.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * stepResponseDic = nil;
        if ([self sendGoToStep:step dataDictionary:&stepResponseDic]) {
            [self activityIndicate:NO tipContent:Nil MBProgressHUD:nil target:self.navigationController.view];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadDataAndPushVC:step dataSource:stepResponseDic pushVC:vc];
                
                [self.navigationController popViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
                
                if([step isEqualToString:JBZL_STEP] ||
                   [step isEqualToString:FXPC_STEP])
                {
//                    [vc updateUI];
                }
                if([step isEqualToString:CGZD_STEP]){
                    [((DepositBankViewCtrl *)vc) setViewBound];
//                    [vc updateUI];
                }
            });
        }
        else{
            [self activityIndicate:NO tipContent:@"加载页面数据失败" MBProgressHUD:hud target:self.navigationController.view];
        }
    });
}

- (void)goZDPage:(NSString *)step viewCtrl:(BaseViewController *)vc frontVC:(BaseViewController *)frontVC{
    NSDictionary * stepResponseDic = nil;
    if ([self sendGoToStep:step dataDictionary:&stepResponseDic]) {
        [self loadDataAndPushVC:step dataSource:stepResponseDic pushVC:vc];
        dispatch_async(dispatch_get_main_queue(), ^{
        
        //要完善
//                [self addChildViewController:vc];
//                [self.view addSubview:vc.view];
                
//                [super customPushAnimation:rootScollView withFrame:CGRectMake(-screenWidth, 0, screenWidth, screenHeight - UpHeight) controller:vc];
                
//                [self.navigationController pushViewController:vc animated:YES];
//                [self performSelectorOnMainThread:@selector(pushViewControllersOperation) withObject:nil waitUntilDone:YES];
            
            NSArray * ar = [self getViewControllersByStep:vc];
            NSLog(@"指定跳转 = %@",ar);
            
            if(![vc isMemberOfClass:[UploadImageViewCtrl class]]){
                vc->bReEnter = YES;
            }
            
            [self activityIndicate:NO tipContent:Nil MBProgressHUD:nil target:self.navigationController.view];
            [self.navigationController setViewControllers:ar animated:YES];
//                [self.navigationController pushViewController:vc animated:YES];
//                [self.view addSubview:vc.view];
            
//            [self.navigationController setViewControllers: ar animated:YES];
            
            if([step isEqualToString:JBZL_STEP] ||
               [step isEqualToString:FXPC_STEP])
            {
//                [vc updateUI];
            }
            if([step isEqualToString:CGZD_STEP]){
                [((DepositBankViewCtrl *)vc) setViewBound];
//                [vc updateUI];
            }
        });
    }
    else{
        NSLog(@"stepRepsonsedic = %@",stepResponseDic);
        [self activityIndicate:NO tipContent:@"加载页面数据失败" MBProgressHUD:hud target:self.navigationController.view];
    }
}

//- (void)pushViewControllersOperation{
//    [self.navigationController setViewControllers:[self getViewControllersByStep] animated:YES];
//}

- (NSArray *)getViewControllersByStep:(BaseViewController *)vc{
    NSMutableArray * ar = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    if([vc isMemberOfClass:[UploadImageViewCtrl class]]){
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:vc, nil]];
    }
    else if ([vc isMemberOfClass:[ClientInfoViewCtrl class]]){
        UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
        
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:uploadVC, vc, nil]];
//        return [NSArray arrayWithObjects:uploadVC, vc, nil];
    }
    else if ([vc isMemberOfClass:[VideoWitnessViewCtrl class]]){
        UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
        ClientInfoViewCtrl * clientVC = [[ClientInfoViewCtrl alloc]init];
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:uploadVC, clientVC,vc, nil]];
    }
    else if ([vc isMemberOfClass:[InstallProfileViewCtrl class]]){
        UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
        ClientInfoViewCtrl * clientVC = [[ClientInfoViewCtrl alloc]init];
        VideoWitnessViewCtrl * videoVC = [[VideoWitnessViewCtrl alloc]initWithNibName:@"VideoWitnessView" bundle:nil];
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:uploadVC, clientVC,videoVC ,vc, nil]];
    }
    else if ([vc isMemberOfClass:[AccountTypeViewCtrl class]]){
        UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
        ClientInfoViewCtrl * clientVC = [[ClientInfoViewCtrl alloc]init];
        VideoWitnessViewCtrl * videoVC = [[VideoWitnessViewCtrl alloc]initWithNibName:@"VideoWitnessView" bundle:nil];
        InstallProfileViewCtrl * installVC = [[InstallProfileViewCtrl alloc]init];
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:uploadVC, clientVC,videoVC,installVC,vc, nil]];
    }
    else if ([vc isMemberOfClass:[SecretSetViewCtrl class]]){
        UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
        ClientInfoViewCtrl * clientVC = [[ClientInfoViewCtrl alloc]init];
        VideoWitnessViewCtrl * videoVC = [[VideoWitnessViewCtrl alloc]initWithNibName:@"VideoWitnessView" bundle:nil];
        InstallProfileViewCtrl * installVC = [[InstallProfileViewCtrl alloc]init];
        AccountTypeViewCtrl * accoutVC = [[AccountTypeViewCtrl alloc]initWithNibName:@"AccountTypeView" bundle:nil];
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:uploadVC, clientVC,videoVC,installVC,accoutVC ,vc, nil]];
    }
    else if ([vc isMemberOfClass:[DepositBankViewCtrl class]]){
        UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
        ClientInfoViewCtrl * clientVC = [[ClientInfoViewCtrl alloc]init];
        VideoWitnessViewCtrl * videoVC = [[VideoWitnessViewCtrl alloc]initWithNibName:@"VideoWitnessView" bundle:nil];
        InstallProfileViewCtrl * installVC = [[InstallProfileViewCtrl alloc]init];
        AccountTypeViewCtrl * accoutVC = [[AccountTypeViewCtrl alloc]initWithNibName:@"AccountTypeView" bundle:nil];
        SecretSetViewCtrl * secretVC = [[SecretSetViewCtrl alloc]init];
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:uploadVC, clientVC,videoVC,installVC,accoutVC ,secretVC, vc, nil]];
    }
    else if ([vc isMemberOfClass:[RiskEvaluateViewCtrl class]]){
        UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
        ClientInfoViewCtrl * clientVC = [[ClientInfoViewCtrl alloc]init];
        VideoWitnessViewCtrl * videoVC = [[VideoWitnessViewCtrl alloc]initWithNibName:@"VideoWitnessView" bundle:nil];
        InstallProfileViewCtrl * installVC = [[InstallProfileViewCtrl alloc]init];
        AccountTypeViewCtrl * accoutVC = [[AccountTypeViewCtrl alloc]initWithNibName:@"AccountTypeView" bundle:nil];
        SecretSetViewCtrl * secretVC = [[SecretSetViewCtrl alloc]init];
        DepositBankViewCtrl * depositVC = [[DepositBankViewCtrl alloc]init];
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:uploadVC, clientVC,videoVC,installVC,accoutVC ,secretVC,depositVC, vc, nil]];
    }
    else if ([vc isMemberOfClass:[ReturnVisitViewCtrl class]]){
        UploadImageViewCtrl * uploadVC = [[UploadImageViewCtrl alloc]init];
        ClientInfoViewCtrl * clientVC = [[ClientInfoViewCtrl alloc]init];
        VideoWitnessViewCtrl * videoVC = [[VideoWitnessViewCtrl alloc]initWithNibName:@"VideoWitnessView" bundle:nil];
        InstallProfileViewCtrl * installVC = [[InstallProfileViewCtrl alloc]init];
        AccountTypeViewCtrl * accoutVC = [[AccountTypeViewCtrl alloc]initWithNibName:@"AccountTypeView" bundle:nil];
        SecretSetViewCtrl * secretVC = [[SecretSetViewCtrl alloc]init];
        DepositBankViewCtrl * depositVC = [[DepositBankViewCtrl alloc]init];
        RiskEvaluateViewCtrl * riskVC = [[RiskEvaluateViewCtrl alloc]init];
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:uploadVC, clientVC,videoVC,installVC,accoutVC ,secretVC,depositVC,riskVC, vc, nil]];
    }
    else if ([vc isMemberOfClass:[LookProcessViewCtrl class]]){
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:vc, nil]];
    }
    else{
        return [ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:vc, nil]];
    }
}

- (BaseViewController *)getVCByStep:(NSString *)step{
    BaseViewController * vc = nil;
    
    if([step isEqualToString:YXCJ_STEP]){
        vc = [[UploadImageViewCtrl alloc]init];
    }
    else if([step isEqualToString:JBZL_STEP]){
        vc = [[ClientInfoViewCtrl alloc]init];
    }
    else if([step isEqualToString:SPJZ_STEP]){
        vc = [[VideoWitnessViewCtrl alloc]initWithNibName:@"VideoWitnessView" bundle:nil];
    }
    else if([step isEqualToString:ZSGL_STEP]){
        vc = [[InstallProfileViewCtrl alloc]init];
    }
    else if([step isEqualToString:FXPC_STEP]){
        vc = [[RiskEvaluateViewCtrl alloc]init];
    }
    else if ([step isEqualToString:MMSZ_STEP]){
        vc = [[SecretSetViewCtrl alloc]init];
    }
    else if([step isEqualToString:CGZD_STEP]){
        vc = [[DepositBankViewCtrl alloc]init];
    }
    else if([step isEqualToString:ZQZH_STEP]){
        vc = [[AccountTypeViewCtrl alloc]initWithNibName:@"AccountTypeView" bundle:nil];
    }
    else if([step isEqualToString:HFWJ_STEP]){
        vc = [[ReturnVisitViewCtrl alloc]init];
    }
    else{
        NSLog(@"vc为空");
        vc = [[UploadImageViewCtrl alloc]init];
    }
    
    NSLog(@"vc =%@",vc);
    
    return vc;
}

- (void)loadDataAndPushVC:(NSString *)step dataSource:(NSDictionary *)stepResponseDic pushVC:(BaseViewController *)vc{
    [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
//    NSLog(@"stepResponseDic =%@",stepResponseDic);
    
    if([step isEqualToString:YXCJ_STEP]){
        NSArray * arr = (NSArray *)[stepResponseDic objectForKey:YXSZ];
        [SJKHEngine Instance]->yxData = [arr mutableCopy];
        [SJKHEngine Instance]->yxcj_step_Dic = [stepResponseDic mutableCopy];
    }
    else if([step isEqualToString:JBZL_STEP]){
        NSArray * arr = (NSArray *)[stepResponseDic objectForKey:YXSZ];
        
        [SJKHEngine Instance]->yxData = [arr mutableCopy];
        [SJKHEngine Instance]->jbzl_step_Dic = [stepResponseDic mutableCopy];
    }
    else if([step isEqualToString:SPJZ_STEP]){
        [SJKHEngine Instance]->spzj_step_Dic = [stepResponseDic mutableCopy];
//        [[SJKHEngine Instance]->spzj_step_Dic writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:SPJZ_KEY] atomically:YES];
        BOOL ok = [self sendGetUUID:&stepResponseDic];
        if(ok){
            ((VideoWitnessViewCtrl *)vc)->uuid = [stepResponseDic objectForKey:UUID];
        }
        else {
            [self activityIndicate:NO tipContent:@"获取视频数据失败" MBProgressHUD:nil target:self.navigationController.view];
//            [[SJKHEngine Instance] dispatchMessage:POP_MESSAGE];
        }
    }
    else if([step isEqualToString:ZSGL_STEP]){
        [SJKHEngine Instance]->zsgl_step_Dic = [stepResponseDic mutableCopy];
    }
    else if([step isEqualToString:FXPC_STEP]){
        [SJKHEngine Instance]->fxpc_step_Dic = [stepResponseDic mutableCopy];
    }
    else if ([step isEqualToString:MMSZ_STEP]){
        [SJKHEngine Instance]->mmsz_step_Dic = [stepResponseDic mutableCopy];
        NSMutableArray * ar = [[SJKHEngine Instance]->mmsz_step_Dic objectForKey:RMMARR_MMSZ];
        ((SecretSetViewCtrl *)vc)->rmmArray = [NSMutableArray array];
        for (NSDictionary * rmm in ar) {
            [((SecretSetViewCtrl *)vc)->rmmArray addObject:[rmm objectForKey:@"MM"]];
        }
    }
    else if([step isEqualToString:CGZD_STEP]){
        [SJKHEngine Instance]->cgzd_step_Dic = [stepResponseDic mutableCopy];
        NSLog(@"cgzd data %@",[SJKHEngine Instance]->cgzd_step_Dic);
        ((DepositBankViewCtrl *)vc)->filterArray = [NSMutableArray array];
        NSMutableArray * cgyharr = [NSMutableArray arrayWithArray:[[SJKHEngine Instance]->cgzd_step_Dic objectForKey:CGYHARR_CGYH]];
        [cgyharr sortUsingComparator:^NSComparisonResult(id obj1 ,id obj2){
            NSDictionary *data1 = (NSDictionary *)obj1;
            NSDictionary *data2 = (NSDictionary *)obj2;
            
            NSLog(@"obj1 , obj 2=%@,%@",obj1,obj2);
            return [[data1 objectForKey:PX_CGYH] compare:[data2 objectForKey:PX_CGYH]];
        }];
        [[SJKHEngine Instance]->cgzd_step_Dic setObject:cgyharr forKey:CGYHARR_CGYH];
        
        for (NSDictionary * yhDic in [[SJKHEngine Instance]->cgzd_step_Dic objectForKey:CGYHARR_CGYH]) {
            NSLog(@"[yhDic objectForKey:YHMC_CGYH] =%@",[yhDic objectForKey:YHMC_CGYH]);
            [((DepositBankViewCtrl *)vc)->filterArray addObject:[yhDic objectForKey:YHMC_CGYH]];
        }
    }
    else if([step isEqualToString:ZQZH_STEP]){
        [SJKHEngine Instance]->zqzh_step_Dic = [[stepResponseDic objectForKey:KhxyArr_ZQZH] mutableCopy];
    }
    else if([step isEqualToString:HFWJ_STEP]){
        [SJKHEngine Instance]->hfwj_step_Dic = [stepResponseDic mutableCopy];
    }
    
//    [vc updateUI];
    
    NSLog(@"step vc =%@,%@",step,vc);
}

- (void)httpFinished:(ASIHTTPRequest *)http{
    [super httpFinished:http];
    
    if(http.request_type == HQNZM_REQUEST){
        if([[responseDictionary objectForKey:SUCCESS]intValue] == 1){
#ifdef ShengChanMode
//            [verifyEditor setText:[responseDictionary objectForKey:YZM]];
#endif
            
#ifdef CeShiMode
            [verifyEditor setText:[responseDictionary objectForKey:YZM]];
#endif
            
#ifdef UATMode
            [verifyEditor setText:[responseDictionary objectForKey:YZM]];
#endif
//            验证码已发出,请留意手机短信
            delayTime = 3;
            [self activityIndicate:NO tipContent:@"短信验证码已发出,请在5分钟内完成输入验证" MBProgressHUD:nil target:self.navigationController.view];
        }
        else{
//            NSString * tip = [responseDictionary objectForKey:NOTE];
            NSString * tip = @"获取验证码失败";
            
            [self activityIndicate:NO tipContent:tip MBProgressHUD:hud target:self.navigationController.view];
            [self verifyButtonChange:NO];
        }
    }
}

- (void)httpFailed:(ASIHTTPRequest *)http{
    [super httpFailed:http];
    
    [self verifyButtonChange:NO];
    
    if(http.request_type == HQNZM_REQUEST){
        if ([responseDictionary objectForKey:NOTE]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil
//                                                            message:[responseDictionary objectForKey:NOTE]
//                                                           delegate: self
//                                                  cancelButtonTitle: @"我知道了!"
//                                                  otherButtonTitles: nil];
//            [alert show];
            
            [self activityIndicate:NO tipContent:@"获取验证码失败" MBProgressHUD:hud target:self.navigationController.view];
        }
        if(http.responseData.length == 0){
            [self activityIndicate:NO tipContent:@"获取验证码失败" MBProgressHUD:hud target:self.navigationController.view];
        }
    }
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    ocusView = textField;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:scrollView.subviews, nil]];
    [phoneEditor resignFirstResponder];
    ocusView = nil;
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString * fieldText = [NSString stringWithFormat:@"%@%@", textField.text , string];
//    if(fieldText.length > 11){
//        return NO;
//    }
//    if(fieldText.length > 6 && textField == dialogTextfield){
//        return NO;
//    }
    return  YES;
}

#pragma textfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bKeyBoardShow = YES;
    NSLog(@"scrollView.contentInset.top = %f",rootScollView.contentOffset.y);
    keyboardOffset = textField.frame.origin.y + ButtonHeight - rootScollView.contentOffset.y - (screenHeight - UpHeight - KeyBoardHeight);
    textField.layer.borderColor = TEXTFEILD_BOLD_HIGHLIGHT_COLOR.CGColor;
    
    if(keyboardOffset > 0){
        [self beginEdit:YES textFieldArrar:nil];
    }
    
    switch (textField.tag) {
        case serviceTag:
            
            break;
        case serviceTag + 2:
            
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor = FieldNormalColor.CGColor;
}

- (void)resignAllResponse{
    [phoneEditor resignFirstResponder];
    [verifyEditor resignFirstResponder];
    
    [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:scrollView.subviews, nil]];
}

#pragma scrollview delegate
- (void)scrollViewWillBeginDragging: (UIScrollView *)_scrollView
{
    [self resignAllResponse];
}

- (YEorNO)vailToCert{
    [self activityIndicate:YES tipContent:@"检查证书..." MBProgressHUD:nil target:self.navigationController.view];
    CertHandle *certClass = [CertHandle defaultCertHandle];
    [certClass createHandleData];
    certClass.delegate = self;
    YEorNO resault = nop;
    resault = [certClass vailCertExist];
    if (!resault) {
        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        [self performSelectorOnMainThread:@selector(onShowAlert:) withObject:alertTitleString waitUntilDone:YES];
        
        while (!bSetPasswordFinish) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        bSetPasswordFinish = NO;
        
        sleep(0.4);
        [self activityIndicate:YES tipContent:@"正在发起证书申请..." MBProgressHUD:nil target:self.navigationController.view];
        YEorNO isLoadCert = nop;
        isLoadCert = [certClass certToHandle];
        if(isLoadCert){
            [certClass toSaveProfileStepData];
        }
        NSLog(@"去下载证书");
        return isLoadCert;
    }
    NSLog(@"证书存在");
    return resault;
}

- (void)onShowAlert:(NSString *)tipMessage{
    UIAlertView* dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setTitle:tipMessage];
    if([tipMessage isEqualToString:alertTitleString]){
        if([SJKHEngine Instance]->systemVersion >= 7){
            [dialog setTitle:@"请设置数字证书密码"];
            [dialog setMessage:@"请您妥善保管证书密码,使用该密码进行的任何操作视为本人操作"];
        }
    }
    
    [dialog addButtonWithTitle:@"确定"];
    dialog.tag = 5;
    
    [dialog setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    dialogTextfield = [dialog textFieldAtIndex:0];
    dialogTextfield.layer.cornerRadius = 3;
    dialogTextfield.layer.masksToBounds = YES;
    [dialogTextfield setPlaceholder:@"密码"];
    dialogTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [dialogTextfield setSecureTextEntry:YES];
    
    sureTextField = [dialog textFieldAtIndex:1];
    sureTextField.layer.cornerRadius = 3;
    sureTextField.layer.masksToBounds = YES;
    [sureTextField setSecureTextEntry:YES];
    sureTextField.keyboardType = UIKeyboardTypeNumberPad;
    [sureTextField setPlaceholder:@"确认密码"];
    
    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
    [dialog setTransform: moveUp];
    [dialog show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    NSLog(@"weizhi = %@",alertView.subviews);
    if(alertView.tag == 5){
        if([SJKHEngine Instance]->systemVersion < 7){
            if(![alertView.title isEqualToString:alertTitleString]){
                return ;
            }
            alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y -15
                                         ,alertView.frame.size.width, alertView.frame.size.height + 30);
            CGSize size = alertView.frame.size;
            for (UIView * view in alertView.subviews) {
                if(([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UIImageView class]]) && !CGSizeEqualToSize(view.frame.size, size))
                {
                    view.frame = CGRectMake(view.frame.origin.x,
                                            view.frame.origin.y + 25,
                                            view.frame.size.width,
                                            view.frame.size.height);
                }
                if(view.frame.size.height == 1){
                    view.frame = CGRectMake(view.frame.origin.x,
                                            view.frame.origin.y + 25,
                                            view.frame.size.width,
                                            view.frame.size.height);
                }
                if([view isKindOfClass:[UILabel class]]){
                    [view setHidden:YES];
                    
                    TTTAttributedLabel *la=[[TTTAttributedLabel alloc]initWithFrame: view.frame];
                    la.font = [UIFont boldSystemFontOfSize:19];
                    la.textColor = [UIColor whiteColor];
                    la.lineBreakMode = NSLineBreakByWordWrapping;
                    la.numberOfLines = 0;
                    la.backgroundColor = [UIColor clearColor];
                    la.highlightedTextColor = [UIColor whiteColor];
                    la.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
                    la.textAlignment = UITextAlignmentCenter;
                    
                    [la setText:alertTitleString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
                     {
                         UIFont *systemFont = [UIFont systemFontOfSize:16];
                         CTFontRef fontRef = CTFontCreateWithName((CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
                         [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:[[mutableAttributedString string] rangeOfString:@"请您妥善保管证书密码,使用该密码进行的任何操作视为本人操作"]];
                         CFRelease(fontRef);
                        
                        return mutableAttributedString;
                    }];
                    
                    [alertView addSubview:la];
                }
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"alertview =%@,%i",alertView,buttonIndex);
    
    if(alertView.tag == 5){
        UITextField * textField = [alertView textFieldAtIndex:0];
        NSString * sTextField = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(sTextField.length != 6){
            [self onShowAlert:@"密码长度需要是6位,请重新输入"];
        }
        else if(![[dialogTextfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[sureTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]])
        {
            [self onShowAlert:@"密码输入不一致,请重新输入"];
        }
        else{
            [SJKHEngine Instance]->sImportPassword = [sTextField mutableCopy];
            [PublicMethod saveToUserDefaults:sTextField key:SIMPORTPASSWORD];
            bSetPasswordFinish = YES;
        }
    }
    else if(alertView.tag == 10000){
        if(buttonIndex == 1)
        {
            if([SJKHEngine Instance]->rootVC){
                [[SJKHEngine Instance]->rootVC vcOperation:Nil];
            }
        }
    }
    else{
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)certHandleResault:(NSString *)resaultString{
    NSLog(@"开始");
    [self activityIndicate:NO tipContent:resaultString MBProgressHUD:nil target:self.navigationController.view];
    NSLog(@"结束");
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view == [phoneEditor valueForKey:@"_clearButton"] ||
       touch.view == [verifyEditor valueForKey:@"_clearButton"] ||
       touch.view == verifyButton ||
       touch.view == nextStepBtn )
    {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)popToLastPage{
    [self backOperation];
    
    [self.navigationController popViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
    
    [super popToLastPage];
    [SJKHEngine Instance]->rootVC = nil;
    
    [phoneEditor resignFirstResponder];
    [verifyEditor resignFirstResponder];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//
//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

@end
