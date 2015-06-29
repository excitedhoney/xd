//
//  LoginViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-21.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "LoginViewCtrl.h"
//#import "LoanMainViewCtrl.h"
#import "RootModelViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "SettingViewController.h"
//#include "../shipin/aes2.h"
#import "axAes.h"
#include <string>
#import "CreditViewCtrl.h"
#import "RepayMentViewCtrl.h"
#import "MemberMessageViewCtrl.h"
//#import "Header.h"
#import "MiniViewController.h"

using namespace std;

//#import "CustomIntroductionView.h"


@interface LoginViewCtrl (){
    CGRect khButtonRect;
    int bLocalFirstShow;
    BOOL bFirstLayoutView;
    UIButton * cancelButton;
//    MYIntroductionView *introductionView;
}

@end

@implementation LoginViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self InitConfig];
    [self InitWidgets];
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 450, 220, 40)];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)InitConfig{
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self.navigationController.navigationItem setHidesBackButton:YES];
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage
//                                                                 imageWithColor:NAV_BG_COLOR
//                                                                 size:CGSizeMake(screenWidth, NAV_HEIGHT)]
//                                                  forBarMetrics:UIBarMetricsDefault];
    
//    if([SJKHEngine Instance]->systemVersion >= 6){
//        self.view.bounds = CGRectMake(0, -20, screenWidth, self.view.frame.size.height);
//    }
    
    kaihuNumberField.delegate = self;
    kaihuPasswordField.delegate = self;
    [kaihuPasswordField setSecureTextEntry:YES];
    kaihuNumberField.keyboardType = UIKeyboardTypeNumberPad;
    kaihuNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    kaihuPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [loginButton addTarget:self action:@selector(onLoginHandle) forControlEvents:UIControlEventTouchUpInside];
    [kaihuButton addTarget:self action:@selector(onToKaihuHandle) forControlEvents:UIControlEventTouchUpInside];
    
//    [kaihuButton setHidden:YES];
    
    bLocalFirstShow = YES;
    bFirstLayoutView = YES;
    
    [self addGesture:self.view];
    
    if([SJKHEngine Instance]->systemVersion < 6){
        singleTapRecognizer.delegate = self;
    }
    
//    [self.view setBackgroundColor:PAGE_BG_COLOR];
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"login"].CGImage;
    
    [self onSmallScreenResetAutoLayout];
    
}

- (void)fieldTextChanged:(NSNotification *)noti{
    UITextField * textField = noti.object;
    NSString * fieldText = textField.text;
    
    if(!textField.markedTextRange){
        if(fieldText.length > 18 && textField == kaihuNumberField){
            [textField setText:[fieldText substringToIndex:18]];
        }
        if(fieldText.length > 20 && textField == kaihuPasswordField){
            [textField setText:[fieldText substringToIndex:20]];
        }
    }
}

//改变3.5寸屏下autolayout的constrain对象的值。系统生成的自动布局并不完善
- (void)onSmallScreenResetAutoLayout{
//    self.view.bounds = CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height);
    
//    if(screenHeight == 480){
//        if([SJKHEngine Instance]->systemVersion > 5){
//            for (NSLayoutConstraint * constrant in self.view.constraints) {
//                if(constrant.firstItem == headerImageView && constrant.firstAttribute == NSLayoutAttributeTop)
//                {
//                    [constrant setConstant:constrant.constant - 50];
//                }
//            }
//        }
//    }
}

//- (IBAction)testButton:(id)sender{
//    NSLog(@"testButton");
//}

- (void)showSettingVC:(UIGestureRecognizer *)getture{
    SettingViewController * settingVC = [[SettingViewController alloc]init];
    UINavigationController * naviVC = [[UINavigationController alloc]initWithRootViewController:settingVC];
    [self presentModalViewController:naviVC animated:YES];
}

- (void)InitWidgets{
    {
        //初始化导航
        int yInset = 0;
        if([SJKHEngine Instance]->systemVersion == 7){
            yInset = 20;
        }
        naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, yInset, screenWidth, 44)];
        
        cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ButtonHeight, ButtonHeight)];
        [cancelButton setImage:[UIImage imageNamed:@"button_back_default"] forState:UIControlStateNormal];
        [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 14)];
        [cancelButton addTarget:self action:@selector(popToLastPage) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        UINavigationItem * item = [[UINavigationItem alloc] initWithTitle:@"小薇"];
        item.leftBarButtonItem = left;
        [naviBar pushNavigationItem:item animated:NO];
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],UITextAttributeTextColor,
                                                   [UIColor blackColor], UITextAttributeTextShadowColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset,
                                                   [UIFont boldSystemFontOfSize:22],UITextAttributeFont, nil];
        [naviBar setTitleTextAttributes:navbarTitleTextAttributes];
        
        naviBar.translucent = NO;
       // naviBar.delegate = self;
        [naviBar setBackgroundImage:[UIImage
                                        imageWithColor:NAV_BG_COLOR
                                        size:CGSizeMake(screenWidth, NAV_HEIGHT)]
                                        forBarMetrics:UIBarMetricsDefault];
        [self.view addSubview:naviBar];
    }
    
    [headerImageView setImage:[UIImage imageNamed:@"icon_user_photo"]];
    
    [headerImageView setUserInteractionEnabled:YES];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showSettingVC:)];
//    longPress.allowableMovement = YES;
//    longPress.minimumPressDuration = 10;
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettingVC:)];
    doubleTapRecognizer.numberOfTapsRequired = 8;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [headerImageView addGestureRecognizer:doubleTapRecognizer];
    
    UIImage * headerImage = [UIImage imageNamed:@"SmallLoanBundle.bundle/images/txt_login_number"];
//    [kaihuNumberHeaderImageView setBackgroundColor:[UIColor whiteColor]];
//    kaihuNumberHeaderImageView.layer.cornerRadius = 4;
//    kaihuNumberHeaderImageView.layer.masksToBounds = YES;
    [kaihuNumberHeaderImageView setImage:headerImage];
//    [kaihuNumberHeaderImageView setContentMode:UIViewContentModeScaleToFill];
    headerImage = nil;
    headerImage = [UIImage imageNamed:@"SmallLoanBundle.bundle/images/txt_login_password"];
//    [kaihuPassHeaderImageView setBackgroundColor:[UIColor whiteColor]];
//    kaihuPassHeaderImageView.layer.cornerRadius = 4;
//    kaihuPassHeaderImageView.layer.masksToBounds = YES;
    [kaihuPassHeaderImageView setImage: headerImage];
    
    [self changeFieldBorderColor:NO targetView:kaihuNumberView bJustChangeLayer:YES];
    [self changeFieldBorderColor:NO targetView:kaihuPasswordView bJustChangeLayer:YES];
    kaihuNumberView.layer.borderColor = [UIColor whiteColor].CGColor;
    kaihuPasswordView.layer.borderColor = [UIColor whiteColor].CGColor;
    [kaihuNumberView setBackgroundColor:[UIColor whiteColor]];
    [kaihuPasswordView setBackgroundColor:[UIColor whiteColor]];
//    [self changeFieldBorderColor:NO targetView:loginButton bJustChangeLayer:YES];
    
    [kaihuNumberField setPlaceholder:@"客户号"];
    [kaihuPasswordField setPlaceholder:@"交易密码"];
    [kaihuNumberField setBackgroundColor:[UIColor clearColor]];
    [kaihuPasswordField setBackgroundColor:[UIColor clearColor]];
    kaihuNumberField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    kaihuPasswordField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    kaihuPasswordField.layer.cornerRadius = 4;
    kaihuPasswordField.layer.masksToBounds = YES;
    kaihuNumberField.layer.cornerRadius = 4;
    kaihuNumberField.layer.masksToBounds = YES;
    
//    UIColor * loginButtonColor = [UIColor colorWithRed:239.0/255 green:65.0/255 blue:86.0/255 alpha:1];
//    [loginButton setBackgroundColor:loginButtonColor];
//    loginButton.layer.borderColor = loginButtonColor.CGColor;
    
//    [btnBGPressed stretchableImageWithLeftCapWidth:25 topCapHeight:0];
    
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"button_orange_default"]stretchableImageWithLeftCapWidth: 8 topCapHeight: 8] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"button_orange_active"]stretchableImageWithLeftCapWidth: 8 topCapHeight: 8] forState:UIControlStateHighlighted];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    loginButton.titleLabel.shadowColor = [UIColor grayColor];
    loginButton.titleLabel.shadowOffset = CGSizeMake(-1, 0);
    
//    UIImage * kaihuImage = [UIImage imageNamed: [NSString stringWithFormat:@"button_gray_default"]];
//    kaihuImage = [kaihuImage stretchableImageWithLeftCapWidth: 8 topCapHeight: 8];
//    kaihuImage = [kaihuImage imageByResizingToSize:kaihuButton.frame.size];
    //    kaihuImage = [kaihuImage imageByResizingToSize:loginButton.frame.size];
//    [kaihuButton setBackgroundImage:kaihuImage forState:UIControlStateNormal];
    
    [self changeFieldBorderColor:NO targetView:kaihuButton bJustChangeLayer:YES];
    kaihuButton.layer.borderColor = [UIColor whiteColor].CGColor;
    kaihuButton.layer.borderWidth = 0.7;
    [kaihuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [kaihuButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:199.0/255 blue:29.0/255 alpha:1] size:kaihuButton.frame.size] forState:UIControlStateHighlighted];
//    [kaihuButton setBackgroundImage:[[UIImage imageNamed:@"button_orange_active"]stretchableImageWithLeftCapWidth: 8 topCapHeight: 8] forState:UIControlStateHighlighted];
    
    {
        //帐号设置相关
        [rememberAccountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        int bRemember = [[[SJKHEngine Instance]->userConfigDic objectForKey:BREMEMBERACCOUNT] intValue];
        UIImage * img = nil;
        if(bRemember){
            if([SJKHEngine Instance]->systemVersion >= 7){
                img = [[UIImage imageNamed:@"checkbox_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            else {
                img = [UIImage imageNamed:@"checkbox_checked"];
            }
        }
        else {
            if([SJKHEngine Instance]->systemVersion >= 7){
                img = [[UIImage imageNamed:@"checkbox_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            else{
                img = [UIImage imageNamed:@"checkbox_default"];
            }
        }
        
        [rememberAccountButton setImage:img forState:UIControlStateNormal];
        [rememberAccountButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, rememberAccountButton.frame.size.width - 25)];
        rememberAccountButton.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
        rememberAccountButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [rememberAccountButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [rememberAccountButton addTarget:self action:@selector(onAccountSetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [forgetSecretButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        forgetSecretButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [forgetSecretButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [forgetSecretButton addTarget:self action:@selector(onAccountSetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [kaihuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    kaihuButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
//    [kaihuButton setContentMode:UIViewContentModeScaleAspectFit];
    
    [super InitWidgets];
}

- (void)onAccountSetButtonClick:(UIButton *)btn{
    if(btn == rememberAccountButton){
        int bRemember = [[[SJKHEngine Instance]->userConfigDic objectForKey:BREMEMBERACCOUNT] intValue];
        [[SJKHEngine Instance]->userConfigDic setObject:[NSString stringWithFormat:@"%i",1 - bRemember] forKey:BREMEMBERACCOUNT];
        UIImage * img = nil;
        if(1 - bRemember){
            [[SJKHEngine Instance]->userConfigDic setObject:[kaihuNumberField.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:SSTOREACCOUNT];
            [[SJKHEngine Instance]->userConfigDic setObject:@"1" forKey:BREMEMBERACCOUNT];
            
            if([SJKHEngine Instance]->systemVersion >= 7){
                img = [[UIImage imageNamed:@"checkbox_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            else {
                img = [UIImage imageNamed:@"checkbox_checked"];
            }
        }
        else {
            [[SJKHEngine Instance]->userConfigDic setObject:@"" forKey:SSTOREACCOUNT];
            [[SJKHEngine Instance]->userConfigDic setObject:@"0" forKey:BREMEMBERACCOUNT];
            if([SJKHEngine Instance]->systemVersion >= 7){
                img = [[UIImage imageNamed:@"checkbox_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            else{
                img = [UIImage imageNamed:@"checkbox_default"];
            }
        }
        
        [rememberAccountButton setImage:img forState:UIControlStateNormal];
//        [PublicMethod saveToUserDefaults:[SJKHEngine Instance]->userConfigDic key:USERCONFIGDIC];
        [[SJKHEngine Instance]->userConfigDic writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:USERCONFIGDIC] atomically:YES];
    }
    if(btn == forgetSecretButton){
        
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

//对ios5的系统进行区别处理，如果点击loginbutton或kaihuButton的位置，gesture事件将被注销。
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    CGPoint point = [gestureRecognizer locationInView:self.view];
////    NSLog(@"point =%@,%i,%i",NSStringFromCGPoint(point),CGRectContainsPoint(loginButton.frame, point),CGRectContainsPoint(kaihuButton.frame, point));
//    if(CGRectContainsPoint(loginButton.frame, point) || CGRectContainsPoint(kaihuButton.frame, point)){
//        return NO;
//    }
//    
//    return YES;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view == [kaihuNumberField valueForKey:@"_clearButton"] ||
       touch.view == [kaihuPasswordField valueForKey:@"_clearButton"] ||
       touch.view == loginButton ||
       touch.view == kaihuButton ||
       touch.view == rememberAccountButton ||
       touch.view == cancelButton)
    {
        return NO;
    }
    else{
        return YES;
    }
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)onLoginHandle{
    [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:kaihuNumberField,kaihuPasswordField, nil]];
    
    NSString * kaihuNumberText = [kaihuNumberField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * kaihuPassText = [kaihuPasswordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(kaihuNumberText.length == 0 || kaihuNumberText == nil){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请先输入客户号" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    if(kaihuPassText.length == 0 || kaihuPassText == nil){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请先输入密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    
    [self activityIndicate:YES tipContent:@"正在获取加密数据..." MBProgressHUD:nil target:self.view];
    
    //加入aes加密版块
//    unsigned char * output = nil ;
//    unsigned char output[1024] ;
//    AES_KEY key ;
//    int ar[] = {1,334,1};
//    for (int i = 0; i < 60; i++) {
//        key.rd_key[i] = i;
//    }
//    
//    key.rd_key = ar;
//    key.rd_key = {1,334,1};
//    
//    key.rounds = 60;
//    const char * inPut = [kaihuPassText UTF8String];
//    AES_encrypt(inPut, output , &key);
//    NSLog(@"output miwen =%s,%s,%@",inPut, output,[NSString stringWithFormat:@"%s",output] );
    
//    unsigned char twoput[1024] ;
//    AES_decrypt(output,twoput,&key);
//    NSLog(@"output miwen 2=%s,%s,%@",output, twoput,[NSString stringWithFormat:@"%s",output] );
    
//    AES_KEY enkey;
    
    unsigned char output[1024];
    NSString * keyString = @"em300059370626";
    
    NSString * pass = [AxAES Encode:kaihuPassText];
//    NSLog(@"output miwen =%@,%@",pass,kaihuPassText);
//    NSString * minwen = [AxAES Decode:pass];
//    NSLog(@"output miwen 2 =%@,%@",pass,minwen);
    
////    NSData * keydata = [NSData dataWithBytes:[key UTF8String] length:strlen([key UTF8String])];
//    AES_set_encrypt_key([keyString UTF8String],128,&enkey);
//
//    [self AES_Encrypt_Block:inPut inlen:sizeof(inPut) outStr:output enkey:&enkey];
//    
//    NSLog(@"output miwen =%s,%s,%@",inPut, output,[NSString stringWithFormat:@"%s",output] );
////
//    unsigned char twoput[1024] ;
//    [self AES_Decrypt_Block:output inlen:sizeof(output) outStr:twoput dekey:&enkey];
//    NSLog(@"output miwen 2=%s,%s,%@",output, twoput,[NSString stringWithFormat:@"%s",output] );
    
    [self dispatchXWDPage:[NSMutableArray arrayWithObjects:
                           kaihuNumberText,
                           pass ,
                           nil]];
}

//- (void) AES_Encrypt_Block:(unsigned char*)inStr inlen:(int)inlen outStr:(unsigned char*)outStr enkey:(AES_KEY*)enkey
//{
////	int i;
////	for(i=0;i<inlen/16;i++)
////	{
//		AES_encrypt(inStr,outStr,enkey);
////	}
//}
//
//- (void) AES_Decrypt_Block:(unsigned char*)inStr inlen:(int)inlen outStr:(unsigned char*)outStr dekey:(AES_KEY*)dekey
//{
//	int i;
//	for(i=0;i<inlen/16;i++)
//	{
//		AES_decrypt(inStr+i*16,outStr+i*16,dekey);
//	}
//}

//跳到我要开户的起始界面
- (void)onToKaihuHandle{
    [self popToLastPage];
    KHRequestOrSearchViewCtrl * rootVC = [[KHRequestOrSearchViewCtrl alloc]init];
    [[handleLoanBaseVC.tabBarController.viewControllers firstObject] pushViewController:rootVC animated:YES];
}

//跳到股东账户界面
- (void)push{
    [self popToLastPage];
    MiniViewController * rootVC = [[MiniViewController alloc]init];
    rootVC.hidesBottomBarWhenPushed = YES;
    [[handleLoanBaseVC.tabBarController.viewControllers firstObject] pushViewController:rootVC animated:YES];
    
    
   // [self.navigationController setViewControllers:@[[handleLoanBaseVC.tabBarController.viewControllers firstObject],rootVC]];
}





//进入小微贷页面所作操作
- (void)dispatchXWDPage:(NSMutableArray *)postValues{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * dic = nil;
        BOOL bLoadSuccess = NO;
        [self sendGetRSAPublicKey:nil dataDictionary:&dic];
//        NSLog(@"diccccc =%@",dic);
        
        /*
         modules = 9a7dae708933ee3b805abbfac9e0bd0e427632045a354ab284b8abfa18aa32567d8a62edce42cd3fb8b74b9e7d3e3c61362359bd59e8d147f44eaf624a464582dcfb3ad219e02ff2389b3bcef02f028e19a3430bb25d4ffe2438c26b8132e51035cce09a7640ff429ef588ed3a36fc7f3c0b10c7a31c11ebf663f80f78dea161;
         publicExponent = 10001;
         success = 1;
         */
        if (dic && dic.count > 0) {
            dic = nil;
            [self activityIndicate:YES tipContent:@"正在登录..." MBProgressHUD:nil target:self.view];
            bLoadSuccess = [self sendLoginXWDPage:&dic postValues:postValues];
            NSLog(@"dic blaodSucces =%@",dic);
            
            if(bLoadSuccess && dic){
                [SJKHEngine Instance]->xwdAccount = [postValues firstObject];
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                    LoanMainViewCtrl *loadMainVC = nil;
//                    UIStoryboard *storyBoard = nil;
//                    NSString * nibName = @"LoanMainStoryBoard";
//                    if([SJKHEngine Instance]->systemVersion < 6){
//                        nibName = [nibName stringByAppendingString:FORIOS5XIB];
//                    }
//                    
//                    storyBoard = [UIStoryboard storyboardWithName:nibName bundle:nil];
//                    loadMainVC = [storyBoard instantiateInitialViewController];
                    
                    [SJKHEngine Instance]->uuid = [[dic objectForKey:UUID] mutableCopy];
                    NSString *weburl = nil;
                    
                    if([[dic objectForKey:bczy_tx_XWDLogin] intValue] == 1 ||
                       [[dic objectForKey:bczy_tx_XWDLogin] boolValue] == true)
                    {
//                        hk  wdhk me
                        NSString * pageName = @"jk";
                        if ([handleLoanBaseVC isMemberOfClass:[CreditViewCtrl class]]) {
                            pageName = @"jk";
                        }
                        if ([handleLoanBaseVC isMemberOfClass:[RepayMentViewCtrl class]]) {
                            pageName = @"wdhk";
                        }
                        if ([handleLoanBaseVC isMemberOfClass:[MemberMessageViewCtrl class]]) {
                            pageName = @"me";
                        }
                        
                        weburl = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/user/bczy_tx?uuid=%@&pageName=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid,pageName];
                    }
                    else {
                        if ([handleLoanBaseVC isMemberOfClass:[CreditViewCtrl class]]) {
                            weburl = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/jk/xzcp_uat?uuid=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid];
                        }
                        if ([handleLoanBaseVC isMemberOfClass:[RepayMentViewCtrl class]]) {
                            weburl = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/hk/wdjk?uuid=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid];
                        }
                        if ([handleLoanBaseVC isMemberOfClass:[MemberMessageViewCtrl class]]) {
                            weburl = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/user/me?uuid=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid];
                        }
                    }
                    
                    [self activityIndicate:NO tipContent:nil MBProgressHUD:hud target:self.view];
                    
                    [[SJKHEngine Instance]->userConfigDic setObject:[kaihuNumberField.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:SSTOREACCOUNT];
                    
                    int bRemember = [[[SJKHEngine Instance]->userConfigDic objectForKey:BREMEMBERACCOUNT] intValue];
                    if(bRemember){
                        [[SJKHEngine Instance]->userConfigDic setObject:[kaihuNumberField.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:SSTOREACCOUNT];
                        [[SJKHEngine Instance]->userConfigDic setObject:@"1" forKey:BREMEMBERACCOUNT];
                    }
                    else {
                        [[SJKHEngine Instance]->userConfigDic setObject:@"" forKey:SSTOREACCOUNT];
                        [[SJKHEngine Instance]->userConfigDic setObject:@"0" forKey:BREMEMBERACCOUNT];
                    }
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        handleLoanBaseVC.urlConnection = nil;
                        [handleLoanBaseVC->webView stopLoading];
                        handleLoanBaseVC.cancelTimer = nil;
                        
                        [handleLoanBaseVC toLoadWebPageWithUrl:weburl];
                    }];
                });
            }
            else{
                NSString * tip = @"登录失败";
                if([dic objectForKey:NOTE]){
                    tip = [dic objectForKey:NOTE];
                }
                [self activityIndicate:NO tipContent:tip MBProgressHUD:hud target:self.view];
            }
        }
        else{
            NSString * note = @"加载加密数据失败";
            [self activityIndicate:NO tipContent:@"网络不给力,登录失败" MBProgressHUD:hud target:self.view];
        }
    });
}

- (void)viewWillLayoutSubviews{
    //将以屏幕最左上角的点为参考系，改为以状态栏的底部线条和左边框的交点为参考点。
    
//    if([SJKHEngine Instance]->systemVersion <= 6){
//        self.navigationController.view.frame = CGRectMake(0, 20, screenWidth, screenHeight - 20);
//    }
//    else{
//        self.navigationController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
//    }
    
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews{
//    [self changeFieldCursorPosition:[NSMutableArray arrayWithObjects:kaihuNumberField,kaihuPasswordField,nil]];
//    [kaihuNumberField setSelectedTextRange:[kaihuNumberField textRangeFromPosition:0 toPosition:uitext]];
    
//        CGRect rect = kaihuNumberView.frame;
//        headerImageView.frame = CGRectMake(screenWidth/2 - 75/2.0,
//                                           kaihuNumberView.frame.origin.y / 2 - 75/2.0,
//                                           75,
//                                           75);
    
//    if([SJKHEngine Instance]->systemVersion > 5){
//        int space = 4;
//        kaihuNumberField.frame = CGRectMake(kaihuNumberField.frame.origin.x - space,
//                                            kaihuNumberField.frame.origin.y,
//                                            kaihuNumberField.frame.size.width + space,
//                                            kaihuNumberField.frame.size.height);
//        kaihuPasswordField.frame = CGRectMake(kaihuPasswordField.frame.origin.x - space,
//                                              kaihuPasswordField.frame.origin.y,
//                                              kaihuPasswordField.frame.size.width + space,
//                                              kaihuPasswordField.frame.size.height);
//    }
//    if([SJKHEngine Instance]->systemVersion == 5){
//        if(bFirstLayoutView){
//            bFirstLayoutView = NO;
//            int space = 4;
//            kaihuNumberField.frame = CGRectMake(kaihuNumberField.frame.origin.x - space,
//                                                kaihuNumberField.frame.origin.y,
//                                                kaihuNumberField.frame.size.width + space,
//                                                kaihuNumberField.frame.size.height);
//            kaihuPasswordField.frame = CGRectMake(kaihuPasswordField.frame.origin.x - space,
//                                                  kaihuPasswordField.frame.origin.y,
//                                                  kaihuPasswordField.frame.size.width + space,
//                                                  kaihuPasswordField.frame.size.height);
//        }
//    }
    
    [kaihuButton setFrame:CGRectMake(kaihuButton.frame.origin.x,
                                        self.view.frame.size.height - kaihuButton.frame.size.height - 30 ,
                                        kaihuButton.frame.size.width,
                                         kaihuButton.frame.size.height)];
    [headerImageView setFrame:CGRectMake(headerImageView.frame.origin.x,
                                         screenHeight == 480 ? (ButtonHeight + 7):(ButtonHeight + 20 + 7) ,
                                         headerImageView.frame.size.width,
                                         headerImageView.frame.size.height)];
    
    [super viewDidLayoutSubviews];
}

- (void)changeFieldCursorPosition:(NSMutableArray *)ar{
    for(UITextField * field in ar){
        
//        [field.inputView setBackgroundColor:[UIColor redColor]];
        
        for (UIView * vi in field.subviews) {
            if([vi isKindOfClass:[UILabel class]]){
                vi.frame = CGRectMake(vi.frame.origin.x + 10,
                                      vi.frame.origin.y,
                                      vi.frame.size.width,
                                      vi.frame.size.height);
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
//    [self.view setNeedsDisplay];
    
//    [self.navigationController.view layoutSubviews];
    
//    [kaihuNumberHeaderImageView setNeedsLayout];
    
//    [kaihuButton setNeedsLayout];
//    [kaihuButton setNeedsDisplay];
    
//    self.view.frame = CGRectMake(0, 20, screenWidth, screenHeight - 20);
//    self.view.bounds = CGRectMake(0, -20, screenWidth, screenHeight - 20);
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    if([[SJKHEngine Instance]->userConfigDic objectForKey:SSTOREACCOUNT])
    {
        [kaihuNumberField setText:[[SJKHEngine Instance]->userConfigDic objectForKey:SSTOREACCOUNT]];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//}

- (void)OnTouchDownResign:(UIGestureRecognizer *)gesture{
//    NSLog(@"gesture.view =%@",gesture.view);
    
//    if(gesture.view == loginButton){
//        [self onLoginHandle];
//        return ;
//    }
//    if(gesture.view == kaihuButton){
//        [self onToKaihuHandle];
//        return;
//    }
    
    if(bKeyBoardShow ){
        [[UIApplication sharedApplication]setStatusBarHidden:NO animated:YES];
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:kaihuNumberField,kaihuPasswordField, nil]];
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bKeyBoardShow = YES;
    
    UITextPosition *beginning = [textField beginningOfDocument];
    [textField setSelectedTextRange:[textField textRangeFromPosition:beginning
                                                          toPosition:beginning]];
    
//    [self performSelector:@selector(changeFieldCursorPosition:) withObject:[NSMutableArray arrayWithObjects:kaihuNumberField,kaihuPasswordField,nil] afterDelay:0.1];
    
    keyboardOffset = (textField == kaihuNumberField ? kaihuNumberView : kaihuPasswordView).frame.origin.y + textField.frame.size.height - (self.view.frame.size.height - KeyBoardHeight);
    
//    textField.layer.borderColor = [UIColor colorWithRed:255.0/255 green:71.0/255 blue:96.0/255 alpha:1].CGColor;
//    if(textField == kaihuNumberField){
//        [self changeFieldBorderColor:YES targetView:kaihuNumberView bJustChangeLayer:NO];
//    }
//    if(textField == kaihuPasswordField){
//        [self changeFieldBorderColor:YES targetView:kaihuPasswordView bJustChangeLayer:NO];
//    }
    
    if(keyboardOffset > 0){
        [[UIApplication sharedApplication]setStatusBarHidden:YES animated:YES];
        [self beginEdit:YES textFieldArrar:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if(textField == kaihuNumberField){
//        [self changeFieldBorderColor:NO targetView:kaihuNumberView bJustChangeLayer:NO];
//    }
//    if(textField == kaihuPasswordField){
//        [self changeFieldBorderColor:NO targetView:kaihuPasswordView bJustChangeLayer:NO];
//    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString * fieldText = [NSString stringWithFormat:@"%@%@", textField.text , string];
    
    //移动光标位置的尝试
//    UITextPosition *start = [textField positionFromPosition:[textField beginningOfDocument]
//                                                 offset:range.location];
//    UITextPosition *end = [textField positionFromPosition:start
//                                               offset:range.length];
//    [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:end]];
    
//    UITextRange *selRange = textField.selectedTextRange;
//    UITextPosition *selStartPos = selRange.start;
//    NSInteger idx = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selStartPos];
//    [textField setSelectedTextRange:[textField textRangeFromPosition:0 toPosition:idx]];
    
//    if(fieldText.length > 18 && textField == kaihuNumberField){
//        return NO;
//    }
//    if(fieldText.length > 6 && textField == kaihuPasswordField){
//        return NO;
//    }
    
//    if ([string isEqualToString:@"'"] || [string isEqualToString:@"\""]) {
//        return NO;
//    }
    
    return  YES;
}

- (void)reposControl{
    int offset = 20;
    
    if([SJKHEngine Instance]->systemVersion >= 7){
        offset = 0;
    }
    
	if (bKeyBoardShow)
	{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, offset-(keyboardOffset + verticalHeight), screenWidth, self.view.frame.size.height);
        }completion:^(BOOL finish){
            
        }];
	}
	else
	{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, offset, screenWidth, self.view.frame.size.height);
        }completion:^(BOOL finish){
            
        }];
	}
}

- (BOOL)sendGetRSAPublicKey:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,@"/xwd/mobile/user/getRSAPublic"];
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:URL];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL)sendLoginXWDPage:(NSDictionary **)stepResponseDic postValues:(NSMutableArray *)postValues{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,@"/xwd/mobile/user/loginByMobile?khh&password"];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:[postValues objectAtIndex:0]
                      forKey:[ar firstObject]];
    [theRequest setPostValue:[postValues objectAtIndex:1]
                      forKey:[ar objectAtIndex:1]];
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (void)popToLastPage{
//    [self.navigationController popToRootViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
    
//    [super popToLastPage];
    [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:kaihuNumberField,kaihuPasswordField, nil]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[SJKHEngine Instance].observeCtrls removeObject:self];
    
    [handleLoanBaseVC.tabBarController setSelectedIndex:0];
    [self dismissModalViewControllerAnimated:YES];
    
    [kaihuNumberField resignFirstResponder];
    [kaihuPasswordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"小微贷登录回收");
    
    [headerImageView removeFromSuperview];
    headerImageView = nil;
    [kaihuNumberView removeFromSuperview];
    kaihuNumberView = nil;
    [kaihuPasswordView removeFromSuperview];
    kaihuPasswordView = nil;
    [kaihuNumberField removeFromSuperview];
    kaihuNumberField = nil;
    [kaihuPasswordField removeFromSuperview];
    kaihuPasswordField = nil;
    [loginButton removeFromSuperview];
    loginButton = nil;
    [kaihuButton removeFromSuperview];
    kaihuButton = nil;
    [kaihuNumberHeaderImageView removeFromSuperview];
    kaihuNumberHeaderImageView = nil;
    [kaihuPassHeaderImageView removeFromSuperview];
    kaihuPassHeaderImageView = nil;
    [naviBar removeFromSuperview];
    naviBar = nil;
    [rememberAccountButton removeFromSuperview];
    rememberAccountButton = nil;
    [forgetSecretButton removeFromSuperview];
    forgetSecretButton = nil;
    [cancelButton removeFromSuperview];
    cancelButton = nil;
}

@end
