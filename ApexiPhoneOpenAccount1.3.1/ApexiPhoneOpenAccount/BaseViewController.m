//
//  BaseViewController.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"
#import <Security/Security.h>
#import "SJKHEngine.h"
#import "UploadImageViewCtrl.h"
#import "ClientInfoViewCtrl.h"
#import "VideoWitnessViewCtrl.h"
#import "InstallProfileViewCtrl.h"
#import "AccountTypeViewCtrl.h"
#import "SecretSetViewCtrl.h"
#import "DepositBankViewCtrl.h"
#import "RiskEvaluateViewCtrl.h"
#import "ReturnVisitViewCtrl.h"
#import "LookProcessViewCtrl.h"
#import "RepointBankViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "LoginViewCtrl.h"
#import "MenuViewCtrl.h"
#import "UIKit+Tools.h"

@interface BaseViewController (){
    
}

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([SJKHEngine Instance]->systemVersion < 6) {
        nibNameOrNil = [nibNameOrNil stringByAppendingString:FORIOS5XIB];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self changeBackBarButtonItem];
    }
    return self;
}

- (id)init{
    self = [super init];
    if(self){
        bReEnter = NO;
        [self changeBackBarButtonItem];
    }
    return self;
}

- (void)changeBackBarButtonItem{
    if ([SJKHEngine Instance]->systemVersion < 7) {
        UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(60, ButtonHeight) ]style: UIBarButtonItemStylePlain target:nil action:nil];
        [newBackButton setBackButtonBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(60, ButtonHeight)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self indispensableInit];
}

- (void)viewWillAppear:(BOOL)animated{
    BOOL bShowCancelButton =
    [self isMemberOfClass:[LoginViewCtrl class]] ||
    [self isMemberOfClass:[KHRequestOrSearchViewCtrl class]] ||
    [self isMemberOfClass:[ClientInfoViewCtrl class]] ||
    [self isMemberOfClass:[SecretSetViewCtrl class]] ||
    [self isMemberOfClass:[DepositBankViewCtrl class]] ||
    [self isMemberOfClass:[InstallProfileViewCtrl class]] ||
    [self isMemberOfClass:[AccountTypeViewCtrl class]];
    
    if(bShowCancelButton){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    BOOL bShowCancelButton =
    [self isMemberOfClass:[LoginViewCtrl class]] ||
    [self isMemberOfClass:[KHRequestOrSearchViewCtrl class]] ||
    [self isMemberOfClass:[ClientInfoViewCtrl class]] ||
    [self isMemberOfClass:[SecretSetViewCtrl class]] ||
    [self isMemberOfClass:[DepositBankViewCtrl class]] ||
    [self isMemberOfClass:[InstallProfileViewCtrl class]] ||
    [self isMemberOfClass:[AccountTypeViewCtrl class]];
    
    if(bShowCancelButton){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }
    
    [super viewWillDisappear: animated];
}

- (void)fieldTextChanged:(NSNotification *)noti{
    
}

//这个方法，作一些必需的操作。
- (void) indispensableInit{
//    UIButton * _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [_cancelButton setUserInteractionEnabled:NO];
//    //    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
//    [self.navigationController.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_cancelButton]];
    
//    [self.navigationItem setHidesBackButton:YES animated:NO];
//    [self.navigationItem setBackBarButtonItem:nil];
    
    [[SJKHEngine Instance].observeCtrls addObject:self];
    bSaveStepFinish = NO;
    bSaveStepSuccess = NO;
    bFirstShow = YES;
    delayTime = 1.4;
    
//    self.navigationItem.title = @"融易宝";
    UILabel * localtipLabel = [PublicMethod initLabelWithFrame:CGRectMake(screenWidth/2 - 100/2, 0 , 100, ButtonHeight)
                                                         title:@"小薇"
                                                        target:nil];
    localtipLabel.font = [UIFont boldSystemFontOfSize:22];
    [localtipLabel setTextColor:[UIColor whiteColor]];
    localtipLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = localtipLabel;
    
    UINavigationController * firstNaviCtrl = [[SJKHEngine Instance]->loanMainVC.viewControllers firstObject];
    BaseViewController * lastVC = [firstNaviCtrl.viewControllers lastObject];
    BOOL bShowCancelButton =
    [lastVC isMemberOfClass:[LoginViewCtrl class]] ||
    [lastVC isMemberOfClass:[KHRequestOrSearchViewCtrl class]] ||
    [lastVC isMemberOfClass:[UploadImageViewCtrl class]] ||
    [lastVC isMemberOfClass:[ClientInfoViewCtrl class]] ||
    ([lastVC isMemberOfClass:[VideoWitnessViewCtrl class]] && ![SJKHEngine Instance]->bVideoAccess) ||
    [lastVC isMemberOfClass:[SecretSetViewCtrl class]] ||
    [lastVC isMemberOfClass:[DepositBankViewCtrl class]] ||
    [lastVC isMemberOfClass:[RiskEvaluateViewCtrl class]] ||
    [lastVC isMemberOfClass:[ReturnVisitViewCtrl class]] ||
    [lastVC isMemberOfClass:[LookProcessViewCtrl class]] ;
    
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ButtonHeight, ButtonHeight)];
    [cancelButton setImage:[UIImage imageNamed:@"button_back_default"] forState:UIControlStateNormal];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 14)];
    [cancelButton addTarget:self action:@selector(onCancelCurrentOperation:) forControlEvents:UIControlEventTouchUpInside];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCancelCurrentOperation:)];
//    tap.delegate = self;
//    [cancelButton addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressedCancel:)];
    longPress.allowableMovement = NO;
    longPress.minimumPressDuration = 0.7;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    
    if(![lastVC isMemberOfClass:[KHRequestOrSearchViewCtrl class]] &&
       ![lastVC isMemberOfClass:[LoginViewCtrl class]])
    {
        [cancelButton addGestureRecognizer:doubleTapRecognizer];
        [cancelButton addGestureRecognizer:longPress];
    }
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    if (bShowCancelButton) {
        [cancelButton setHidden:NO];
    }
    else {
        [cancelButton setHidden:YES];
    }
    
    if(![self isMemberOfClass:[LookProcessViewCtrl class]] && ![SJKHEngine Instance]->isKaiHuOVER){
        UIButton * exitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ButtonHeight, ButtonHeight)];
        [exitButton setImage:[UIImage imageNamed:@"icon-close.png"] forState:UIControlStateNormal];
        [exitButton setImageEdgeInsets:UIEdgeInsetsMake(4, 10, 4, 0)];
        [exitButton addTarget:self action:@selector(onDoubleTap:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * exitItem = [[UIBarButtonItem alloc]initWithCustomView:exitButton];
        self.navigationItem.rightBarButtonItem = exitItem;
    }
    
    if([SJKHEngine Instance]->systemVersion < 7){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"touch.view =%@,%@",gestureRecognizer.view,touch.view);
    
    return YES;
}

- (void) InitConfig{
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    if([SJKHEngine Instance]->systemVersion >= 7){
        self.view.bounds = CGRectMake(0, 0, screenWidth, self.view.bounds.size.height);
    }
}

//一般子类都会调用父类的InitWidgets方法，InitConfig并不一定。
- (void) InitWidgets{
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setHidden:YES];
    
    
    rootView = [PublicMethod CreateView:CGRectMake(0, 0, screenWidth, self.view.frame.size.height)
                                    tag:0
                                 target:self.view];
    [rootView setAlpha:0];
    
//    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_default"] style:UIBarButtonSystemItemAction target:self action:@selector(backBarBtnClicked:)];
    
    flowView = [[UIImageView alloc] initWithFrame:FLOWVIEW_FRAME];
}

- (void)onDoubleTap:(UIGestureRecognizer *)gesture{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要退出开户流程？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
    alert.tag = 10002;
    alert.delegate = self;
    [alert show];
}

- (void)onLongPressedCancel:(UIGestureRecognizer *)gesture{
     if ([gesture state] == UIGestureRecognizerStateBegan) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要退出开户流程？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
         alert.tag = 10001;
         alert.delegate = self;
         [alert show];
     }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(alertView.tag == 10001 || alertView.tag == 10002){
            alertView.delegate = nil;
            [[SJKHEngine Instance]->rootVC vcOperation:Nil];
//            [[SJKHEngine Instance] backToKaiHuLoginVCAndDealloc];
        }
    }
}

- (void)onCancelCurrentOperation:(UIButton *)cancelButton{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [cancelButton setUserInteractionEnabled:NO];
//        [cancelButton performSelector:@selector(setUserInteractionEnabled:)  withObject:[NSNumber numberWithBool:YES]  afterDelay:0.8];
        [SJKHEngine Instance]->bPopAnimate = YES;
        [[SJKHEngine Instance] dispatchMessage:POP_MESSAGE];
    });
}

- (void)backBarBtnClicked:(UIBarButtonItem *)btn{
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定退出开户么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertview.delegate = [SJKHEngine Instance]->rootVC;
    
    alertview.tag = 10000;
    [alertview show];
}

- (void) InitScrollView{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - UpHeight)];
    scrollView.scrollEnabled = YES;
    [scrollView setShowsVerticalScrollIndicator:NO];
}

- (void)chageNextStepButtonStype:(BOOL)isOK{
    if(isOK){
        [nextStepBtn setBackgroundImage:[[UIImage imageNamed:BTN_NORMAL] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [nextStepBtn setBackgroundImage:[[UIImage imageNamed:BTN_HIGH] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    }
    else{
        [nextStepBtn setBackgroundImage:[[UIImage imageNamed:BTN_DISABLE] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        nextStepBtn.layer.borderWidth = 0;
    }
}

- (void)changeFieldBorderColor:(BOOL)isChange targetView:(UIView *)vi bJustChangeLayer:(BOOL)bJustChangeLayer{
    if(bJustChangeLayer){
        vi.layer.cornerRadius = 4;
        vi.layer.masksToBounds = YES;
        vi.layer.borderWidth = 1;
    }
    else{
        UIColor * color = nil;
        if(isChange){
            color = [UIColor colorWithRed:255.0/255 green:71.0/255 blue:96.0/255 alpha:1];
        }
        else{
            color = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1];
        }
        
        vi.layer.borderColor = color.CGColor;
        vi.layer.cornerRadius = 4;
        vi.layer.masksToBounds = YES;
        vi.layer.borderWidth = 1;
    }
}

- (void) InitNextStepButton:(CGRect) rect tag:(int)tag title:(NSString *)title{
    nextStepBtn = [[UIButton alloc]initWithFrame:rect];
//    [nextStepBtn setBackgroundImage:[[UIImage imageNamed:BTN_NORMAL] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
//    [nextStepBtn setBackgroundImage:[[UIImage imageNamed:BTN_HIGH] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    nextStepBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    UIColor * color = [UIColor colorWithRed:255.0/255 green:71.0/255 blue:96.0/255 alpha:1];
    [PublicMethod publicCornerBorderStyle:nextStepBtn];
    nextStepBtn.layer.borderColor = color.CGColor;
    [nextStepBtn setBackgroundColor:color];
    
    nextStepBtn.tag = tag;
    nextStepBtn.layer.cornerRadius=4;
    nextStepBtn.layer.masksToBounds=YES;
    [nextStepBtn addTarget: self action: @selector(onButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    [nextStepBtn setTitle:title forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:TITLE_WHITE_COLOR forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:WARN_TITLE_COLOR forState:UIControlStateHighlighted];
}

- (void)beginEdit:(BOOL)isStart textFieldArrar:(NSMutableArray *)fields{
    bKeyBoardShow = isStart;
//    [self reposControl];
    
    if(isStart){
        [self reposControl];
    }
    else{
        for (UIView * view in fields) {
            if([view isMemberOfClass:[UITextField class]]){
                [(UITextField *)view resignFirstResponder];
            }
        }
        [self reposControl];
    }
}

- (void)reposControl{
   int offset = IOS7_SYS?64:44;
    if([SJKHEngine Instance]->systemVersion < 7){
        int offset = 0;
    }
	if (bKeyBoardShow)
	{
        [UIView animateWithDuration:0.2 animations:^{
            CGRect tempFrame = self.view.frame;
;
            if (tempFrame.origin.y >= 0) {
                NSLog(@"11111\n%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
                tempFrame.origin.y -= 150;
            }
            
//            NSLog(@"up2:::%f",tempFrame.origin.y);
            self.view.frame = tempFrame;
            
            NSLog(@"22222\n%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        }completion:^(BOOL finish){
            
        }];
	}
	else
	{
        [UIView animateWithDuration:0.2 animations:^{
            CGRect tempFrame = self.view.frame;
//            NSLog(@"down1:::%f",tempFrame.origin.y);
            
            if (tempFrame.origin.y <0) {
                tempFrame.origin.y = IOS7_SYS ? offset : 0.0;
            }
//            NSLog(@"down2:::%f",tempFrame.origin.y);
            self.view.frame = tempFrame;
        }completion:^(BOOL finish){
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAV_BG_COLOR size:CGSizeMake(320, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
        }];
	}
}

//- (void)reposControl{
//    int offset = IOS7_SYS?64:44;
//    if([SJKHEngine Instance]->systemVersion < 7){
//        int offset = 0;
//    }
//	if (bKeyBoardShow)
//	{
//        [UIView animateWithDuration:0.2 animations:^{
//            CGRect tempFrame = self.view.frame;
//            if (tempFrame.origin.y > 0) {
//                tempFrame.origin.y -= 150;
//            }
//            
//            self.view.frame = tempFrame;
//        }completion:^(BOOL finish){
//            
//            
//        }];
//	}
//	else
//	{
//        [UIView animateWithDuration:0.2 animations:^{
//            CGRect tempFrame = self.view.frame;
//            
//            if (tempFrame.origin.y <0) {
//                tempFrame.origin.y = offset;
//            }
//            self.view.frame = tempFrame;
//        }
//        completion:^(BOOL finish){
//            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAV_BG_COLOR size:CGSizeMake(320, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
//        }];
//	}
//}

- (void)ServerAuthenticate:(REQUEST_TYPE)request_type{
    
}

//-(BOOL) respondsToSelector:(SEL)aSelector {
//    NSLog(@"SELECTOR: %@", NSStringFromSelector(aSelector));
//    return [super respondsToSelector:aSelector];
//}

- (ASIFormDataRequest *)createASIRequest:(NSString *)urlComponent{
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:[PublicMethod suburlString:URL]];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
//    [theRequest setShouldContinueWhenAppEntersBackground:YES];
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    
    return theRequest;
}

- (BOOL)parseResponseData:(ASIFormDataRequest *)theRequest dic:(NSDictionary **)stepResponseDic{
    if(theRequest.responseData){
        *stepResponseDic = [NSJSONSerialization JSONObjectWithData:theRequest.responseData options:NSJSONReadingMutableContainers error:Nil];
        NSString * tip = nil;
        
//        NSString *testSTR = [*stepResponseDic objectForKey:NOTE];
        
//        if([*stepResponseDic objectForKey:NOTE]){
//            tip = [PublicMethod getNSStringFromCstring:[[*stepResponseDic objectForKey:NOTE] UTF8String]];
//        }
        
        if(*stepResponseDic && [[*stepResponseDic objectForKey:SUCCESS] intValue] == 1){
            return YES;
        }
    }
    return NO;
}

//这里要上传json数据体
- (BOOL)sendSaveStepInfo:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic arrar:(NSMutableDictionary *)jsonDic
{
    [self activityIndicate:YES tipContent:@"保存数据..." MBProgressHUD:nil target:self.navigationController.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isOk = [self toSendSaveStepInfo:stepName dataDictionary:stepResponseDic arrar:jsonDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveSuccessContinueOpetion:isOk];
        });
    });
    
    return YES;
}

- (void)saveSuccessContinueOpetion:(BOOL)bSaveSuccess{
    bSaveStepFinish = YES;
    bSaveStepSuccess = bSaveSuccess;
}

- (void)toSendLastCommit:(NSString *)khzd dataDictionary:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,KHQRTJ];
    
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:khzd
                      forKey:[ar firstObject]];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar objectAtIndex:1]];
    theRequest.request_type = KHQRTJ_REQUEST;
    [theRequest setDelegate:self];
    [theRequest setDidFailSelector:@selector(httpFailed:)];
    [theRequest setDidFinishSelector:@selector(httpFinished:)];
    
    [theRequest startAsynchronous];
}

- (void)toSendQueryKHXX{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,CXKHXX];
    
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
//    [theRequest setPostValue:@"13800000015"
//                      forKey:[ar firstObject]];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar firstObject]];
    theRequest.request_type = CXKHXX_REQUEST;
    [theRequest setDelegate:self];
    [theRequest setDidFailSelector:@selector(httpFailed:)];
    [theRequest setDidFinishSelector:@selector(httpFinished:)];
    
    [theRequest startAsynchronous];
}

// 每一步返回给服务器
- (BOOL)toSendSaveStepInfo:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic arrar:(NSMutableDictionary *)jsonDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,BCBZSJXX];
    
    if ([NSJSONSerialization isValidJSONObject:jsonDic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString *jsonString = [[NSString alloc]initWithData:tempJsonData encoding:NSUTF8StringEncoding];
        
        ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
        
        NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
        [theRequest setPostValue:jsonString forKey:[ar firstObject]];
        [theRequest setPostValue:[SJKHEngine Instance]->SJHM forKey:[ar objectAtIndex:1]];
        [theRequest setPostValue:stepName
                          forKey:[ar objectAtIndex:2]];
        
        [theRequest startSynchronous];
        BOOL ret;
        ret = [self parseResponseData:theRequest dic:stepResponseDic];
        return ret;
    }
    return NO;
}

- (BOOL)sendCGYHXYID:(NSString *)yhdm dataDictionary:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,CXCGYHDSFCGYX];
    
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:yhdm
                      forKey:[ar firstObject]];
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}


- (BOOL)sendSaveCurrentStepKey:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,BCDQBZKEY];
    
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar firstObject]];
    [theRequest setPostValue:stepName
                      forKey:[ar objectAtIndex:1]];
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL)sendGoToStep:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,HQDQBUYMSJ];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:stepName
                      forKey:[ar firstObject]];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar objectAtIndex:1]];
    
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL)sendGetUUID:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,SCSPJZDFWDKHXX];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar objectAtIndex:0]];
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL)sendGetStepInfo:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,JZYHSRSJ];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar firstObject]];
    [theRequest setPostValue:stepName
                      forKey:[ar objectAtIndex:1]];
    
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL)sendOCRInfo:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,HQOCRSBXX];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar firstObject]];
    
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL)sendCheckVersion:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,IOSBBJC];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    
    NSString * localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
//    NSString * localVersion =[localDic objectForKey:@"CFBundleVersion"];
    [theRequest setPostValue:localVersion forKey:[ar firstObject]];
    [theRequest setPostValue:@"0" forKey:[ar objectAtIndex:1]];
    
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL)sendUploadConsoleLog:(NSDictionary **)stepResponseDic path:(NSString *)path{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,BKRJSC];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    
    [theRequest setFile:path forKey:[ar objectAtIndex:0]];
    
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL)sendTaskBook:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,HQDZHTXY];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    
    NSString * postValue = nil;
    NSArray * arr = [[SJKHEngine Instance]->yxcj_step_Dic objectForKey:SZZRSARR];
    if (arr.count > 0) {
        NSDictionary * dic = [arr objectAtIndex:0];
        NSString * IDString= [dic objectForKey:ID];
        if(IDString){
            postValue = [dic objectForKey:ID];
        }
    }
    [theRequest setPostValue:postValue
                      forKey:[ar firstObject]];
    
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL) toSendKHSFNZ:(NSDictionary **)stepResponseDic sourceArray:(NSArray *)sourceArr{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,KHSFNZ];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];

    [theRequest setPostValue:[sourceArr objectAtIndex:0] forKey:[ar firstObject]];
    [theRequest setPostValue:[sourceArr objectAtIndex:1]
                      forKey:[ar objectAtIndex:1]];
    
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (NSData *) toSendYXCJTPXZ:(NSDictionary **)stepResponseDic sourceArray:(NSArray *)sourceArr{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,YXCJTPXZ];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    
    [theRequest setPostValue:[sourceArr objectAtIndex:0] forKey:[ar firstObject]];
    
    [theRequest startSynchronous];
    
    return theRequest.responseData;
}

- (void)customPushAnimation:(UIView *)target withFrame:(CGRect)frame controller:(UIViewController *)vc{
    [UIView animateWithDuration:0.3 animations:^(void) {
        target.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    [vc.view.layer addAnimation:[SJKHEngine Instance]->rightTransition forKey:nil];
}

- (void)sendAsychronizeSaveCurrentStep:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,BCDQBZKEY];
    
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar firstObject]];
    [theRequest setPostValue:stepName
                      forKey:[ar objectAtIndex:1]];
    [theRequest setDelegate:self];
    [theRequest setDidFailSelector:@selector(httpFailed:)];
    [theRequest setDidFinishSelector:@selector(httpFinished:)];
    
    [theRequest startAsynchronous];
}

- (void)dismissHUD{
    [self activityIndicate:NO tipContent:Nil MBProgressHUD:Nil target:self.navigationController.view];
}

//- (void)activityIndicateTextMode:(BOOL)isBegin tipContent:(NSString *)content target:(UIView *)target {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if(isBegin){
//            if(hud == nil){
//                hud = [MBProgressHUD showHUDAddedTo:target animated:YES];
//            }
//            [hud setHidden:NO];
//            [hud setOpaque:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = content;
//            [target bringSubviewToFront:hud];
//        }
//        else {
//            if(content == nil){
//                [hud hide:YES];
//                
//                [hud setHidden:YES];
//                hud = nil;
//            }
//            else{
//                if(hud == nil){
//                    hud = [MBProgressHUD showHUDAddedTo:target animated:YES];
//                }
//                hud.mode = 	MBProgressHUDModeText;
//                hud.labelText = content;
//                [self performSelector:@selector(hiddenHud) withObject:nil afterDelay:1];
//            }
//        }
//    });
//}

- (void)activityIndicate:(BOOL)isBegin tipContent:(NSString *)content MBProgressHUD:(MBProgressHUD *)hudd target:(UIView *)target  {
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud setHidden:NO];
        [hud setOpaque:YES];
        
        if(isBegin){
            if(hud == nil ){
                hud = [MBProgressHUD showHUDAddedTo:target animated:YES];
            }
            if(hud.bNeedHidden && hud){
                [hud hide:YES];
                hud = nil;
                hud = [MBProgressHUD showHUDAddedTo:target animated:YES];
            }
            
            [target setUserInteractionEnabled:NO];
            if(target == nil){
                [[[UIApplication sharedApplication] keyWindow].rootViewController.view setUserInteractionEnabled:NO];
            }
            
            hud.animationType = MBProgressHUDAnimationZoomOut;
            hud.detailsLabelText = content;
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
            hud.mode = MBProgressHUDModeIndeterminate;
            [target bringSubviewToFront:hud];
        }
        else {
            if(hud == nil && content.length > 0 && content){
                hud = [MBProgressHUD showHUDAddedTo:target animated:YES];
            }
            
            [target setUserInteractionEnabled:YES];
            if(target == nil){
                [[[UIApplication sharedApplication] keyWindow].rootViewController.view setUserInteractionEnabled:YES];
            }
            
            if(content == nil){
                [hud hide:YES];
                hud = nil;
            }
            else{
                hud.mode = 	MBProgressHUDModeText;
                hud.animationType = MBProgressHUDAnimationZoomOut;
                [hud setUserInteractionEnabled:NO];
                hud.detailsLabelText = content;
                hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
                if([self isMemberOfClass:[VideoWitnessViewCtrl class]]){
                    delayTime = 2.5;
                }
                hud.bNeedHidden = YES;
                [self performSelector:@selector(hiddenHud) withObject:nil afterDelay:delayTime];
            }
        }
        
    });
}

- (void) hiddenHud{
    if(hud.bNeedHidden){
        [hud hide:YES];
        hud = nil;
    }
}

- (void) addGesture:(UIView *)view{
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouchDownResign:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:singleTapRecognizer];
}

- (void) httpFailed:(ASIHTTPRequest *)http{
    NSError * error = nil;
    if (http.responseData && http.responseData.length > 0) {
        responseDictionary = [NSJSONSerialization JSONObjectWithData:http.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"dic fail error= %@,%@,%@",responseDictionary,self,error);
    }
}

- (void) httpFinished:(ASIHTTPRequest *)http{
    NSError * error = nil;
    if (http.responseData && http.responseData.length > 0) {
        responseDictionary = [NSJSONSerialization JSONObjectWithData:http.responseData options:NSJSONReadingMutableContainers error:&error] ;
//        NSLog(@"error 0=%@",error);
//        responseDictionary = [NSJSONSerialization JSONObjectWithData:http.responseData options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&error];
//        NSLog(@"error 1=%@",error);
        
        if(error){
            responseDictionary = [NSJSONSerialization JSONObjectWithData:http.responseData options:NSJSONReadingAllowFragments error:&error];
        }

        
        if([responseDictionary objectForKey:NOTE]){
            NSString * note = [PublicMethod getNSStringFromCstring:[[responseDictionary objectForKey:NOTE] UTF8String]];
            NSLog(@"dic finished = %@,%@,%@",responseDictionary,self,note);
        }
    }
}

- (UIButton *)createSelectImageButton:(int)i withFrame:(CGRect)frame{
    UIButton * selectImageButton = [[UIButton alloc]initWithFrame:frame];
    selectImageButton.tag = i;
    [selectImageButton setBackgroundImage:[UIImage imageNamed:@"checkBox_default"] forState:UIControlStateNormal];
    [selectImageButton setBackgroundImage:[UIImage imageNamed:@"checkBox_checked"] forState:UIControlStateSelected];
    return selectImageButton;
}

- (UIButton *)createSelectTitleButton:(int)i withFrame:(CGRect)frame title:(NSString *)title{
    UIButton * selectTitleButton = [[UIButton alloc]initWithFrame:frame];
//    [selectTitleButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [selectTitleButton setBackgroundColor:[UIColor clearColor]];
    [selectTitleButton setTitleColor:GrayTipColor_Wu forState:UIControlStateNormal];
    selectTitleButton.tag = i;
    [selectTitleButton setTitle:title forState:UIControlStateNormal];
    selectTitleButton.titleLabel.font = [UIFont systemFontOfSize:10];
    
    return selectTitleButton;
}

- (float)getHeightForHeaderString:(NSString *)text size:(CGSize)size{
    CGFloat height = 2 * 6;
    height += ceilf([text sizeWithFont:TipFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping].height);
    return height;
}

- (void)updateUI{
//    while (!self.isViewLoaded) {
//        NSLog(@"123456");
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
}

- (void)OnTouchDownResign:(UIControl *)control{
    if(bKeyBoardShow ){
        
    }
}

- (void)popToLastPage{
    BaseViewController * baseVC = nil;
//    BaseViewController * removeVC = nil;
    
//    for (int i = 0; i < [SJKHEngine Instance].observeCtrls.count; i++) {
//        baseVC = [[SJKHEngine Instance].observeCtrls objectAtIndex:i];
//        if([baseVC isMemberOfClass:self.class]){
//            removeVC = [[SJKHEngine Instance].observeCtrls objectAtIndex:i];
//            break ;
//        }
//    }
    
//    for (baseVC in [SJKHEngine Instance].observeCtrls) {
//        if([baseVC isMemberOfClass:self.class]){
//            removeVC = baseVC;
//            break ;
//        }
//    }
    
//    [[SJKHEngine Instance].observeCtrls removeObject:self];
//    [self removeFromParentViewController];
//    self = nil;
//    removeVC = nil;
//    baseVC = nil;
    
    NSLog(@"self.navigationController = %@,%@",self.navigationController.childViewControllers,self.navigationController.viewControllers);
    
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToViewController:toPopVC animated:YES];
    
//    int position = [[SJKHEngine Instance].observeCtrls indexOfObject:self];
//    baseVC = [[SJKHEngine Instance].observeCtrls objectAtIndex:position];
    
//    baseVC = [[SJKHEngine Instance].observeCtrls lastObject];
    
    NSLog(@"baseVC =%@,%@",self,[SJKHEngine Instance].observeCtrls);
    
//    baseVC = self;
    [[SJKHEngine Instance].observeCtrls removeObject:self];
//    [baseVC removeFromParentViewController];
//    baseVC = nil;
}

- (void)xwdPopMessage{
    NSLog(@"self.navigationController xwd = %@,%@",self.navigationController.childViewControllers,self.navigationController.viewControllers);
    NSLog(@"baseVC xwd =%@,%@",self,[SJKHEngine Instance].observeCtrls);
    [[SJKHEngine Instance].observeCtrls removeObject:self];
}

- (BOOL)onJudgePreVCExist:(Class)preClass currentVC:(BaseViewController *)currentVC{
    NSArray * ar =currentVC.navigationController.childViewControllers;
    BOOL isExist = NO;
    for (UIViewController * vc in ar) {
        if([vc isMemberOfClass:preClass]){
            isExist = YES;
            break;
        }
    }
    
    return isExist;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [responseDictionary removeAllObjects];
    responseDictionary = nil;
    
    [scrollView removeFromSuperview];
    scrollView = nil;
    [nextStepBtn removeFromSuperview];
    nextStepBtn = nil;
    [rootView removeFromSuperview];
    rootView = nil;
    singleTapRecognizer = nil;
    [flowView removeFromSuperview];
    flowView = nil;
    [hud removeFromSuperview];
    hud = nil;
    
//    NSLog(@"BASE回收");
}

@end