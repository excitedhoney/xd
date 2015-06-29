//
//  SJKHEngine.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "SJKHEngine.h"
#include <sys/sysctl.h>
#import "UploadImageViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "ClientInfoViewCtrl.h"
#import "RootModelViewCtrl.h"
#import "DepositBankViewCtrl.h"
#import "FilterDataClass.h"
#import "LoanBaseViewCtrl.h"
#import "LoginViewCtrl.h"
#import "VideoWitnessViewCtrl.h"
//#import "../../NetWork/NetWork/NetReachability.h"
//#import "../../aximApi_IOS_XMPP_12_19/axim/webconnect/Reachability.h"
#import "Reachability.h"
#import "axAes.h"

@interface SJKHEngine (){
    FilterDataClass * filterClass;
    NetworkStatus  status;
    Reachability * hostReach;
}
@end

@implementation SJKHEngine

@synthesize observeCtrls;
//@synthesize jbzl_step_OCR_Dic;


static SJKHEngine * sjkhEngine = nil;
+ (SJKHEngine * )Instance{
    @synchronized(self)
	{
		if  (sjkhEngine  ==  nil)
		{
			sjkhEngine = [[SJKHEngine alloc] init];
            
            [sjkhEngine InitConfig];
//            [sjkhEngine initColor_datas];
        }
    }
	return  sjkhEngine;
}

- (void)InitConfig{
    /*
     上海证券网上开户测试环境
     内网地址：http://172.26.64.112:8088/
     外网地址：http://180.168.121.15:8088/
     例如调用手机验证码接口
     http://172.26.64.112:8088/wskh/mobile/login/getSjyzm?sj=13800000000
     */
    
//    filterClass = new FilterDataClass();
    
    isHttps = YES;
//    isKaiHuOVER = NO;
//    isHttps = NO;
//    doMain = @"192.168.1.123";
    doMain = @"180.168.121.15";
//    doMain = @"192.168.1.124";
//    doMain = @"172.17.60.246";
//    doMain = @"192.168.1.109";
//    doMain = @"218.66.59.169";   //公司环境
//    doMain = @"222.92.187.118";  //东吴环境
//    doMain = @"222.92.187.156";  //新的东吴环境
//    doMain = @"172.17.57.251";
//    doMain = @"wskh.crm.apexsoft.com.cn";   // 顶点服务器
    doMain = @"192.168.50.73";    // 世纪内网环境
//    doMain = @"172.27.35.1";
//      doMain = @"10.1.11.135";
//    doMain = @"172.27.35.1";
//    doMain = @"61.141.193.120";
    doMain = @"ryb.csco.com.cn";
//    doMain = @"rybcs.csco.com.cn";
    
//    port = 8081;              //http端口
//    port = 1168;              //公司环境接口
//    port = 8080;              //东吴端口
//    port = 5222;
//    port = 8080;
//    port = 8443;            //https端口
//    doMain = @"192.168.1.108";
//    port = 8443;
    
//    port = 80;  // 顶点端口
//    port = 8081;
//    port =  8080;   // 世纪内网端口
//    port = @":8080";
    port = @"";
//    port = @":8443";
    
#ifdef ShengChanMode
    doMain = @"ryb.csco.com.cn";
#endif
    
#ifdef CeShiMode
    doMain = @"rybcs.csco.com.cn";
//    doMain = @"rybuat.csco.com.cn";
//    doMain = @"rybwcs.csco.com.cn";
//    doMain = @"172.27.35.1";
#endif
    
#ifdef UATMode
    doMain = @"rybuat.csco.com.cn";
#endif
    
    customerName = @"123456";
    NSString * sProfilePassword = [PublicMethod userDefaultsValueForKey:SProfilePassword];
    if(sProfilePassword.length > 0 && sProfilePassword){
        sPrePin = [AxAES Decode:[PublicMethod userDefaultsValueForKey:SProfilePassword]];
    }
    if(sPrePin == nil || sPrePin.length == 0){
        sPrePin = @"123456";
    }
    sImportPassword = [PublicMethod userDefaultsValueForKey:SIMPORTPASSWORD];
    if (sImportPassword == nil || sImportPassword.length == 0) {
        sImportPassword = @"";
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString * nameComponent = [NSString stringWithFormat:@"%@_%@", [PublicMethod GetMacAddress],[dateFormatter stringFromDate:[NSDate date]]];
    consoleLogPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:nameComponent];
    logFileNames = [NSMutableArray arrayWithContentsOfFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:LogFilesArray]];
    if(logFileNames == nil || logFileNames.count == 0){
        logFileNames = [[NSMutableArray alloc]init];
    }
    [logFileNames addObject:consoleLogPath];
    
    userConfigDic = [NSMutableDictionary dictionaryWithContentsOfFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:USERCONFIGDIC]];
    if(userConfigDic == nil || userConfigDic.count == 0){
        userConfigDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1",BREMEMBERACCOUNT, nil];
    }
    
    stringEncode = NSUTF8StringEncoding;
    
    SJHM = [PublicMethod userDefaultsValueForKey:SJHMNUMBER];
    xwdAccount = [PublicMethod userDefaultsValueForKey:KHHNUMBER];
    
    [SJKHEngine Instance]->qmlsh = @"";
    bVideoAccess = NO;
    bPopAnimate = NO;
    bLastCommitSuccess = NO;
    bReUploadImage = NO;
    NSString * sShowIntroduction = [PublicMethod userDefaultsValueForKey:SHOWINTRODUCTIONVIEW];
    
    if(sShowIntroduction && sShowIntroduction.length > 0){
        bShowIntroduction = [sShowIntroduction boolValue];
    }
    else{
        bShowIntroduction = YES;
    }
    
    SecTrustRef trust = NULL;
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"custom" ofType:@"p12"]];
    [[SJKHEngine Instance] extractIdentity:&identify andTrust:&trust fromPKCS12Data:PKCS12Data];
    
    currentTipZhiYeIndex = -1;
    currentTipXueLiIndex = -1;
    
    jbzl_user_datas = [NSMutableArray array];
    observeCtrls = [NSMutableArray array];
    color_datas = [NSMutableArray array];
    
    systemVersion = [[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    
    rightTransition = [CATransition animation];
    rightTransition.duration = .25f;
    rightTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rightTransition.type = kCATransitionMoveIn;
    rightTransition.subtype = kCATransitionFromRight;
//    transition.delegate = self;
    
    leftTransition = [CATransition animation];
    leftTransition.duration = 0.25f;
    leftTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    leftTransition.type = kCATransitionPush;
    leftTransition.subtype = kCATransitionFromLeft;
    
    topTransition = [CATransition animation];
    topTransition.duration = 3.0f;
    topTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    topTransition.type = kCATransitionMoveIn;
    topTransition.subtype = kCATransitionFromTop;
    
    initNavigationBar = YES;
    mainWindow = [[UIApplication sharedApplication].windows firstObject];
    
    bfjg_type = ZHONGDENG_CERT;
}

- (void)startNotificatioin{
    if([[UIDevice currentDevice].systemVersion intValue] > 5){
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(reachabilityChange:)
//                                                     name: kReachabilityChangedNotification
//                                                   object: nil];
        hostReach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        [hostReach setPostNotification:self select:@selector(reachabilityChange:)];
        [hostReach startNotifier];
        
        status = [hostReach currentReachabilityStatus];
//        [hostReach addObserver:self forKeyPath:@"currentReachabilityStatus" options:0 context:nil];
    }
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"居延塔拉听 ");
//    if([keyPath isEqualToString:@"currentReachabilityStatus"] && object == hostReach) {
//         
//    }
//}

- (void)onClearKaihuData{
    [_customAlertView removeFromSuperview];
    _customAlertView = nil;
    
    [yxData removeAllObjects];
    yxData = nil;
    [yxcj_step_Dic removeAllObjects];
    yxcj_step_Dic = nil;
    [jbzl_cache_dic removeAllObjects];
    jbzl_cache_dic = nil;
    [jbzl_step_Dic removeAllObjects];
    jbzl_step_Dic = nil;
    [spzj_step_Dic removeAllObjects];
    spzj_step_Dic = nil;
    [zsgl_step_Dic removeAllObjects];
    zsgl_step_Dic = nil;
    [mmsz_step_Dic removeAllObjects];
    mmsz_step_Dic = nil;
    [cgzd_step_Dic removeAllObjects];
    cgzd_step_Dic = nil;
    [fxpc_step_Dic removeAllObjects];
    fxpc_step_Dic = nil;
    [hfwj_step_Dic removeAllObjects];
    hfwj_step_Dic = nil;
    
    currentTipZhiYeIndex = -1;
    currentTipXueLiIndex = -1;
}

- (void)reachabilityChange:(NSNotification *)note{
    NetworkStatus currentStatus = [hostReach currentReachabilityStatus];
    
    if(status != currentStatus && currentStatus == NotReachable)
    {
        status = NotReachable;
        UINavigationController * naviVC = ((UINavigationController *)[loanMainVC.viewControllers firstObject]);
        [[naviVC.viewControllers firstObject] activityIndicate:NO tipContent:@"网络已断开,请检查您的网络连接" MBProgressHUD:nil target:naviVC.view];
        
        return ;
    }
    if(status != NotReachable &&  currentStatus!= NotReachable && status != currentStatus)
    {
        //网络切换.3g与wifi互切
        status = currentStatus;
    }
    if(status == NotReachable && currentStatus != NotReachable){
        status = currentStatus;
//        [[SJKHEngine Instance] dispatchMessage:NETWORK_COMSUME];
    }
}

//暂时放弃
//- (void)initColor_datas{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"color" ofType:@"txt"];
//    NSFileManager * fm = [NSFileManager defaultManager];
//    if ([fm fileExistsAtPath: filePath] == YES)
//	{
//		NSData *fileData = [fm contentsAtPath: filePath];
//		if (fileData != nil)
//		{
//			NSString *nsContent = [[NSString alloc] initWithData: fileData encoding: stringEncode];
//            nsContent = [nsContent stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//            NSMutableArray * ar = [NSMutableArray arrayWithArray:[nsContent componentsSeparatedByString:@"#"]];
//            for (int i=1;i<ar.count; i = i+2) {
//                NSString* str = [NSString stringWithFormat:@"0X%@", [ar objectAtIndex:i]];
//                [PublicMethod filterString:&str];
//                NSData* data = [NSData dataWithBytes:[str UTF8String] length:strlen([str UTF8String])];
//                NSLog(@"data = %@,%i,%@",data,[str integerValue],str);
//                
//                NSLog(@"rgb =%@", UIColorFromRGB([str integerValue]));
//            }
//        }
//    }
//}

- (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data
{
	OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("123456"); //证书密码
    
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { password };
	
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
    //	NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"" forKey:(id)kSecImportExportPassphrase];
	
	CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
	securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
    BOOL bSuccess = YES;
    
	if (securityError == 0) {
		CFDictionaryRef myIdentityAndTrust = (CFDictionaryRef)CFArrayGetValueAtIndex (items, 0);
		const void *tempIdentity = NULL;
		tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
		*outIdentity = (SecIdentityRef)tempIdentity;
		const void *tempTrust = NULL;
		tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
		*outTrust = (SecTrustRef)tempTrust;
        bSuccess = YES;
	}
    else {
	 	bSuccess = NO;
	}
    
//    CFRelease(optionsDictionary);
//    CFRelease(items);
	return bSuccess;
}

- (void) setWindowHeaderView:(BOOL)isShow{
    [[mainWindow viewWithTag:FigureButtonTag] setHidden:!isShow];
}

- (void) JBZLCustomAlertViewSelect:(BOOL)isShow DataType:(SELECT_DATA_TYPE) data_type{
    if(isShow){
        [_customAlertView setHidden:NO];
        [_customAlertView->selectView setHidden:NO];
        [_customAlertView->okButton setHidden:NO];
        [_customAlertView setAlpha:1];
        
//        [self.layer addAnimation:animation forKey:@"popup"];
        [_customAlertView.layer addAnimation:[self getAlertViewAnimation] forKey:nil];
        
        _customAlertView->data_type = data_type;
        [_customAlertView setOKHidden:YES];
        
        NSString * data_Key = nil;
        switch (data_type) {
            case ZHIYE_DATA_TYPE:
                data_Key = ZYDM;
                break;
                
            case XUELI_DATA_TYPE:
                data_Key = XLDM;
                break;
                
            case ZJYXQ_DATA_TYPE:
                data_Key = ZJYXQ_OCR;
                break;
            default:
                break;
        }
        
        NSDictionary * xldmDic = [jbzl_step_Dic objectForKey:data_Key];
        if(xldmDic){
            NSMutableArray * recordsDic = [xldmDic objectForKey:RECORDS];
            if(recordsDic){
                _customAlertView->filterArray = [recordsDic mutableCopy];
                for (int i = 0; i < recordsDic.count; i++) {
                    [_customAlertView->selectData addObject:[NSNumber numberWithInt:0]];
                }
                [_customAlertView setSelfTipIndex];
                
                [_customAlertView->selectView reloadData];
            }
        }
    }
    else{
        [UIView animateWithDuration:.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [_customAlertView setAlpha:0];
                             [[mainWindow viewWithTag:BacKViewTag] setAlpha:0];
                         }
                         completion:^(BOOL bl){
                             [_customAlertView setHidden:YES];
                         }];
    }
}

//请求责任书
- (void) JBZLCustomAlertViewXYZRS:(BOOL)isShow htmlString:(NSString *)htmlString{
    if(isShow){
        [_customAlertView setAlpha:1];
        [_customAlertView setHidden:NO];
        [_customAlertView->webView setHidden:NO];
        [_customAlertView->okButton setHidden:NO];
        
        if(!htmlString && htmlString.length == 0){
            [_customAlertView createMBProgress];
            [_customAlertView->alertHUD setHidden:NO];
            [_customAlertView bringSubviewToFront:_customAlertView->alertHUD];
        }
        
        [_customAlertView.layer addAnimation:[self getAlertViewAnimation] forKey:nil];
        
//        [_customAlertView->webView loadHTMLString: baseURL:nil];
//        [_customAlertView->webView setSuppressesIncrementalRendering:YES];
        _customAlertView->webView.scalesPageToFit = YES;
        
        if (htmlString && htmlString.length > 0) {
//            NSLog(@"htmlString = %@",htmlString);
            
//            htmlString = [NSString stringWithFormat:@"<html> \n"
//                          "<head> \n"
//                          "<style type=\"text/css\"> \n"
//                          "body {font-size: %ipx!important}\n"
//                          "</style> \n"
//                          "</head> \n"
//                          "<body>%@</body> \n"
//                          "</html>", 60,htmlString];
            /*
             <!DOCTYPE html>
             <html>
             <head><meta http-equiv="Content-Type" content="textml;charset=UTF-8" />
             <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
             <meta http-equiv="Cache-Control" content="no-cache"/>
             </head>
             <body>
             
             
             </body>
             <ml>
             */
            
            htmlString = [NSString stringWithFormat:@"<!DOCTYPE html> \n"
                                "<html>"
                                "<head><meta http-equiv=Content-Type content=textml;charset=UTF-8 /> \n"
                                "<meta name=viewport content=width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no/> \n"
                                "<meta http-equiv=Cache-Control content=no-cache/>"
                                "</head>"
                                "<body>%@</body> \n"
                                "</html>",htmlString];
            
            [_customAlertView->webView loadHTMLString:htmlString baseURL:nil];
        }
        
//        [_customAlertView->webView scalesPageToFit];
//        _customAlertView->webView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else{
        [UIView animateWithDuration:.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [_customAlertView setAlpha:0];
                             [[mainWindow viewWithTag:BacKViewTag] setAlpha:0];
                         }
                         completion:^(BOOL bl){
                             [_customAlertView setHidden:YES];
                         }];
    }
}

- (void)updateAlertViewUI:(BOOL)isSuccess{
    [_customAlertView updateUIThread:isSuccess];
    if(!isSuccess){
        [self performSelector:@selector(dismissAlertHUD) withObject:nil afterDelay:1.5];
    }
}

- (void)dismissAlertHUD{
    [_customAlertView dismissHUD];
    
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_customAlertView setAlpha:0];
                         [[mainWindow viewWithTag:BacKViewTag] setAlpha:0];
                     }
                     completion:^(BOOL bl){
                         [_customAlertView setHidden:YES];
                         _customAlertView = nil;
                     }];
}

- (CAKeyframeAnimation *) getAlertViewAnimation{
    CAKeyframeAnimation *animation;
    animation=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration=0.3;
    animation.delegate=self;
    animation.removedOnCompletion=YES;
    animation.fillMode=kCAFillModeForwards;
    
    NSMutableArray *value=[NSMutableArray array];
    [value addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)]];
    [value addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
//    [value addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1)]];
//    [value addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    
    animation.values=value;
    
    //模仿的uialertview的弹出效果
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation
//                                      animationWithKeyPath:@"transform"];
//    
//    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
//    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
//    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
//    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
//    
//    NSArray *frameValues = [NSArray arrayWithObjects:
//                            [NSValue valueWithCATransform3D:scale1],
//                            [NSValue valueWithCATransform3D:scale2],
//                            [NSValue valueWithCATransform3D:scale3],
//                            [NSValue valueWithCATransform3D:scale4],
//                            nil];
//    [animation setValues:frameValues];
//    
//    NSArray *frameTimes = [NSArray arrayWithObjects:
//                           [NSNumber numberWithFloat:0.0],
//                           [NSNumber numberWithFloat:0.5],
//                           [NSNumber numberWithFloat:0.9],
//                           [NSNumber numberWithFloat:1.0],
//                           nil];
//    [animation setKeyTimes:frameTimes];
//    
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
//    animation.duration = .2;
    
    return animation;
}

- (void)createCustomAlertView{
    if (_customAlertView) {
        _customAlertView->webView.delegate = nil;
        [_customAlertView->webView stopLoading];
        [_customAlertView removeFromSuperview];
        _customAlertView = nil;
    }
    _customAlertView = [[CustomAlertView alloc]initWithFrame:CGRectMake(levelSpace, verticalHeight + 20, screenWidth - 2 * levelSpace, screenHeight - 2* verticalHeight - 20)];
    
    UIView *backView = [mainWindow viewWithTag:BacKViewTag];
    if(backView == nil){
        backView = [PublicMethod CreateView:CGRectMake(0, 0, screenWidth, screenHeight) tag:BacKViewTag target:mainWindow];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6f;
    }
    else {
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6f;
    }
    
    [mainWindow addSubview:_customAlertView];
    [mainWindow bringSubviewToFront:_customAlertView];
}

//消息派发
- (BOOL)dispatchMessage:(MESSAGE_TYPE)message_type{
//    return NO;
    
    switch (message_type) {
        case POP_MESSAGE:{
            id<DataEngineOberver> observer;
//            observer = [observeCtrls lastObject];
            
            NSArray * ar = loanMainVC.viewControllers;
            UINavigationController * firstNaviVC = [ar firstObject];
            BaseViewController * baseVC = [firstNaviVC.viewControllers lastObject];
            NSLog(@"lastVC =%@,%@",firstNaviVC,ar);
            
            if([baseVC respondsToSelector:@selector(popToLastPage)]){
                [baseVC popToLastPage];
            }
        }
            break;
            
        case XWD_POP_MESSAGE:{
//            for(UINavigationController * vc in loanMainVC.viewControllers){
//                LoanBaseViewCtrl * loanVC = [vc.viewControllers firstObject];
//                if([loanVC isKindOfClass:[LoanBaseViewCtrl class]]){
//                    [((LoanBaseViewCtrl *)loanVC) xwdPopMessage];
//                    [observeCtrls removeObject:loanVC];
//                }
//            }
            
            UINavigationController * naviVC = [loanMainVC.viewControllers lastObject];
            LoanBaseViewCtrl * loanBaseVC = [naviVC.viewControllers firstObject];
            [loanMainVC onLoadLoginVC:loanBaseVC naviVC:naviVC];
            
//            [loanMainVC onPopMessageOperation:nil popToRoot:NO];
//            loanMainVC = nil;
        }
            break;
            
        case XWD_JUSTPOP_MESSAGE:{
            NSArray * ar = ((UINavigationController *)(mainWindow.rootViewController)).viewControllers;
            for(BaseViewController * vc in ar){
                if([vc isKindOfClass:[LoginViewCtrl class]]){
                    [SJKHEngine Instance]->loginVC = vc;
                    break ;
                }
            }
            
            [loanMainVC onPopMessageOperation:nil popToRoot:YES];
        }
            break;
            
        case GET_OCR_FAIL_POP_MESSAGE:{
            NSArray * ar = [rootVC.navigationController childViewControllers];
            for (UIViewController * vc in ar) {
                if([vc isMemberOfClass:[ClientInfoViewCtrl class]]){
                    [((ClientInfoViewCtrl *)vc) failGetOcrData];
                }
            }
            
            break;
        }
            
        case RELEASE_PRE_VIEWCTRL:{
            NSArray * ar = [SJKHEngine Instance]->rootVC.navigationController.childViewControllers;
//            [SJKHEngine Instance]->rootVC = nil;
            __strong BaseViewController * _vc;
            for (int i=2;i<ar.count-1;i++) {
                _vc = [ar objectAtIndex:i];
                
                if((![_vc isMemberOfClass:[RootModelViewCtrl class]]) && _vc){
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
                    
                    NSLog(@"执行_vc =%@,%@",_vc,ar);
                    [[SJKHEngine Instance].observeCtrls removeObject:_vc];
                    [_vc removeFromParentViewController];
                    _vc = nil;
                }
                else{
                    break ;
                }
            }
        }
            break;
            
        case NETWORK_COMSUME:
        {
            for (BaseViewController * vc in [SJKHEngine Instance].observeCtrls) {
                if ([vc isKindOfClass:[LoanBaseViewCtrl class]]) {
                    ((LoanBaseViewCtrl *)vc).urlConnection = nil;
                    [((LoanBaseViewCtrl *)vc)->webView stopLoading];
                    ((LoanBaseViewCtrl *)vc).cancelTimer = nil;
                    
                    [((LoanBaseViewCtrl *)vc) toLoadWebPage:YES];
                }
            }
        }
            
        default:
            break;
    }
    return YES;
}

//14.6.22 暂被停止使用
- (void)deallocLoginVCAndLoanMainVC{
    if(loanMainVC){
        UINavigationController * naviVC = [loanMainVC.viewControllers firstObject];
        for(BaseViewController * vc in naviVC.viewControllers){
            if([vc isKindOfClass:[LoanBaseViewCtrl class]]){
                [((LoanBaseViewCtrl *)vc) xwdPopMessage];
                [observeCtrls removeObject:vc];
            }
        }
        
        loanMainVC = nil;
    }
    
    if(loginVC){
        [observeCtrls removeObject:loginVC];
        loginVC = nil;
    }
}

- (void)backToKaiHuLoginVCAndDealloc{
    [self onClearKaihuData];
    
    NSArray * ar = [rootVC.navigationController childViewControllers];
    NSLog(@"vcs =%@",rootVC.navigationController.viewControllers);
    
    if([[ar lastObject] isMemberOfClass:[KHRequestOrSearchViewCtrl class]] ||
       [[ar lastObject] isMemberOfClass:[VideoWitnessViewCtrl class]])
    {
        [[ar lastObject] backOperation];
    }
    
    [rootVC.navigationController popToViewController:rootVC animated:YES];
//    [rootVC.navigationController popToViewController:rootVC animated:NO];
    [rootVC.navigationController setViewControllers:[NSArray arrayWithObjects:[ar firstObject],rootVC,nil]];
    
    __strong BaseViewController * _vc;
    for (int i = 1;i < ar.count; i++) {
        _vc = [ar objectAtIndex:i];
        if(![_vc isMemberOfClass:[KHRequestOrSearchViewCtrl class]]){
            
            NSLog(@"khrequest _vc =%@",_vc);
            [[SJKHEngine Instance].observeCtrls removeObject:_vc];
            [_vc removeFromParentViewController];
//            [_vc.view removeFromSuperview];
//            [viewCtrl.view removeFromSuperview];
            
            _vc = nil;
        }
    }
}

- (NSString *)getKhzdString{
    NSString * platform = [self devicePlatform];
    if([platform rangeOfString:@"iPhone"].length > 0){
        return @"4";
    }
    if([platform rangeOfString:@"iPad"].length > 0){
        return @"3";
    }
    
    return nil;
}

- (NSString *)devicePlatform{
    char * typeSpecifier = "hw.machine";
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = (char *)malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

- (NSMutableArray *)getFilterData:(NSMutableArray *)sourceArray originString:(NSString *)sOriginString{
    filterClass->filterArray = sourceArray;
    filterClass->FilterRoster([sOriginString UTF8String], 0);
    return filterClass->filterResultArray;
}


@end












