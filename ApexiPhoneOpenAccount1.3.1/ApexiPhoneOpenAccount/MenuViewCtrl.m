//
//  MenuViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-6-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "MenuViewCtrl.h"
#import "LoginViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"

@interface MenuViewCtrl (){
    CustomIntroductionView *introductionView;
}

@end

@implementation MenuViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self InitConfig];
    [self InitWidgets];
}

- (void)viewWillLayoutSubviews{
    if([SJKHEngine Instance]->systemVersion == 6){
        self.navigationController.view.frame = CGRectMake(0, 20, screenWidth, screenHeight - 20);
    }
    if([SJKHEngine Instance]->systemVersion >= 7){
        self.navigationController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    }
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)InitConfig{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage
                                                                 imageWithColor:NAV_BG_COLOR
                                                                 size:CGSizeMake(screenWidth, NAV_HEIGHT)]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [caculateButton addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [borrowButton addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [kaihuButton addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [caculateButton setBackgroundColor:[UIColor blackColor]];
//    [borrowButton setBackgroundColor:[UIColor yellowColor]];
//    [kaihuButton setBackgroundColor:[UIColor redColor]];
    
    [caculateButton setBackgroundImage:[UIImage imageNamed:@"jisuanqi"] forState:UIControlStateNormal];
    [borrowButton setBackgroundImage:[UIImage imageNamed:@"jieqian"] forState:UIControlStateNormal];
    [kaihuButton setImage:[UIImage imageNamed:@"mashangkaihu"] forState:UIControlStateNormal];
    
//    [backImageView setImage:[UIImage imageNamed:@"SampleBackground"]];
//    [self.view setBackgroundColor:PAGE_BG_COLOR];
//    self.view.layer.contents = (__bridge id)([UIImage imageNamed:@""].CGImage);
    
    [self onSmallScreenResetAutoLayout];
}

//改变3.5寸屏下autolayout的constrain对象的值。系统生成的自动布局并不完善
- (void)onSmallScreenResetAutoLayout{
    if(screenHeight == 480){
        if([SJKHEngine Instance]->systemVersion > 5){
            for (NSLayoutConstraint * constrant in self.view.constraints) {
                if(constrant.firstItem == centerView
                   && constrant.firstAttribute == NSLayoutAttributeTop)
                {
                    [constrant setConstant:constrant.constant - 40];
                }
                if(constrant.secondItem == centerView
                   && constrant.firstAttribute == NSLayoutAttributeBottom)
                {
                    [constrant setConstant:constrant.constant - 70];
                }
            }
        }
    }
    if(screenHeight == 568){
        if([SJKHEngine Instance]->systemVersion > 5){
            for (NSLayoutConstraint * constrant in self.view.constraints) {
                if(constrant.firstItem == centerView
                   && constrant.firstAttribute == NSLayoutAttributeTop)
                {
                    [constrant setConstant:constrant.constant - 30];
                }
                if(constrant.secondItem == centerView
                   && constrant.firstAttribute == NSLayoutAttributeBottom)
                {
//                    [constrant setConstant:constrant.constant - 20];
                }
            }
        }
    }
    
    //在开启了autoautolayout的情况下，在didlayout中调用，是会引发崩溃的
    if([SJKHEngine Instance]->systemVersion == 5){
        NSLog(@"FRAME =%@,%@",NSStringFromCGRect(self.navigationController.view.frame),NSStringFromCGRect(self.view.frame));
        
        self.navigationController.view.frame = CGRectMake(0, 20, screenWidth, screenHeight - 20);
        //        self.view.superview.frame = CGRectMake(0, 64, screenWidth, screenHeight - 20 - 44);
        self.view.frame = CGRectMake(0, -20, screenWidth, screenHeight - 20 -44);
    }
}

- (void)InitWidgets{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    if (bFirstShow) {
//        for (UIView * vi in self.view.subviews) {
//            vi.frame = CGRectMake(vi.frame.origin.x/320.0 * self.view.frame.size.width,
//                                  vi.frame.origin.y/416.0 * self.view.frame.size.height,
//                                  vi.frame.size.width,
//                                  vi.frame.size.height);
//        }
//        
//        bFirstShow = NO;
//    }
    
    [self onShowIntroductionView];
    [super viewWillAppear:animated];
}

- (void)onShowIntroductionView{
//    [SJKHEngine Instance]->bShowIntroduction
    if([SJKHEngine Instance]->bShowIntroduction){
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"App-nav-3-1"] description:@"您好,我是顶点开发组的成员,您正在使用我们公司开发的产品,左右滑动可切换页面。"];
        
        MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"App-nav-3-2"] description:@"您有什么建议,请联系***"];
        
        MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"App-nav-3-3"]
                                                                           title:@"欢迎使用"
                                                                     description:@"开始您的体验之旅吧"];
        
        CGRect introductionRect = CGRectMake(0, 0, screenWidth, screenHeight - 20);
        if([SJKHEngine Instance]->systemVersion == 5){
            introductionRect = CGRectMake(0, 20, screenWidth, screenHeight - 20);
        }
        if([SJKHEngine Instance]->systemVersion == 6){
            introductionRect = CGRectMake(0, 20, screenWidth, screenHeight - 20);
        }
        if([SJKHEngine Instance]->systemVersion >= 7){
            introductionRect = CGRectMake(0, 0, screenWidth, screenHeight);
        }
        
        introductionView = [[CustomIntroductionView alloc] initWithFrame:
                                                              introductionRect
                                                              headerText:@"介绍文本"
                                                                  panels:@[panel,panel2,panel3]];
        introductionView.delegate = self;
        
        NSLog(@"naviframe =%@",[UIApplication sharedApplication].keyWindow);
        [introductionView showInView:[UIApplication sharedApplication].keyWindow];
        
        [SJKHEngine Instance]->bShowIntroduction = NO;
        [PublicMethod saveToUserDefaults:@"0" key:SHOWINTRODUCTIONVIEW];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"navi view buttons 5 =%@,%@,%@,%@,%@,%@,%@",NSStringFromCGRect(self.navigationController.view.frame),
          NSStringFromCGRect(self.view.frame),
          NSStringFromCGRect(caculateButton.frame),
          NSStringFromCGRect(borrowButton.frame),
          NSStringFromCGRect(kaihuButton.frame),
          NSStringFromCGRect(self.navigationController.view.bounds),
          self.view.superview);
    
//    NSLog(@"self.view menu =%@,%@,%@,%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds),
//          NSStringFromCGRect(self.navigationController.view.frame), NSStringFromCGRect(self.navigationController.view.bounds));
    
    [super viewDidAppear:animated];
}

- (void)dispatchCheckVersion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * stepResponseDic = nil;
        if([self sendCheckVersion: &stepResponseDic]){
            NSLog(@"版本获取成功 ＝ %@",stepResponseDic);
            //            [self activityIndicate:NO tipContent:nil MBProgressHUD:Nil target:self.navigationController.view];
            if([[stepResponseDic objectForKey:@"allowUse"] boolValue] == true){
                if([[stepResponseDic objectForKey:@"hasNewVersion"] boolValue] == true){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"有新的版本更新,是否前往更新？"
                                                                       delegate:self
                                                              cancelButtonTitle:@"关闭"
                                                              otherButtonTitles:@"更新", nil];
                        alert.tag = 1193;
                        alert.delegate = self;
                        [alert show];
                    });
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"您好,应用有新版本,您必须更新升级才能使用"
                                                                   delegate:self
                                                          cancelButtonTitle:@"更新"
                                                          otherButtonTitles:nil, nil];
                    alert.tag = 1194;
                    alert.delegate = self;
                    [alert show];
                });
            }
        }
        else{
            NSLog(@"版本检测失败 =%@",[stepResponseDic objectForKey:NOTE]);
            //            [self activityIndicate:NO tipContent:nil MBProgressHUD:Nil target:self.navigationController.view];
        }
    });
}

- (void)dispatchUploadConsoleLog{
//    NSLog(@"dispatchUploadConsoleLo =%i,%i",[[PublicMethod userDefaultsValueForKey:BUploadLog] isEqualToString:@"1"],
//          [[NSFileManager defaultManager] fileExistsAtPath:[SJKHEngine Instance]->consoleLogPath]);
    
    if([[PublicMethod userDefaultsValueForKey:BUploadLog] isEqualToString:@"1"])
    {
        __block NSMutableArray * ar = [[NSMutableArray alloc]init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i =0 ;i< [SJKHEngine Instance]->logFileNames.count ;i++) {
                NSString * path = [[SJKHEngine Instance]->logFileNames objectAtIndex:i];
                if([[NSFileManager defaultManager]fileExistsAtPath:path]){
                    NSDictionary * stepResponseDic = nil;
                    if([self sendUploadConsoleLog: &stepResponseDic path:path]){
                        NSLog(@"console上传成功 ＝ %@,%@",stepResponseDic,path);
                        
                        [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
                        [PublicMethod saveToUserDefaults:@"0" key:BUploadLog];
                        [ar addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    else{
                        NSLog(@"console上传失败 =%@,%@",[stepResponseDic objectForKey:NOTE],path);
                    }
                }
            }
        });
        
        for (NSString * removeItem in ar) {
            [[SJKHEngine Instance]->logFileNames removeObjectAtIndex:[removeItem intValue]];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(alertView.tag == 1193){
            //这里写对应的inhouse或appstore分发的地址。
#ifdef ShengChanMode
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://ryb.csco.com.cn/wskh/mobile/xw"]];
#endif
        
#ifdef CeShiMode
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://rybcs.csco.com.cn/wskh/mobile/xw"]];
#endif
            
#ifdef UATMode
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://rybuat.csco.com.cn/wskh/mobile/xw"]];
#endif
            
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://61.141.193.120:8080/wskh/mobile/android"]];
        }
    }
    
    if(buttonIndex == 0){
        if(alertView.tag == 1194){
#ifdef ShengChanMode
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https:ryb.csco.com.cn/wskh/mobile/xw"]];
#endif
            
#ifdef CeShiMode
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https:rybcs.csco.com.cn/wskh/mobile/xw"]];
#endif
            
#ifdef UATMode
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https:rybuat.csco.com.cn/wskh/mobile/xw"]];
#endif
            
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://10.1.11.135:8443/wskh/mobile/android"]];
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://61.141.193.120:8080/wskh/mobile/android"]];
        }
    }
}

- (void)onItemClick:(UIButton *)btn{
    if(btn == caculateButton){
//        freopen([ConsoleLogPath fileSystemRepresentation],"a+",stderr);
    }
    
    if(btn == borrowButton){
        if ([SJKHEngine Instance]->loanMainVC && [SJKHEngine Instance]->loginVC) {
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            NSArray * ar = self.navigationController.viewControllers;
            [self.navigationController setViewControllers:[ar arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:[SJKHEngine Instance]->loginVC,[SJKHEngine Instance]->loanMainVC,nil]]
                                                 animated:YES];
        }
        else{
            LoginViewCtrl * loginVC = [[LoginViewCtrl alloc]initWithNibName:@"LoginView" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
    
    if(btn == kaihuButton) {
//        [[SJKHEngine Instance] deallocLoginVCAndLoanMainVC];
        KHRequestOrSearchViewCtrl * khRequestVC = [[KHRequestOrSearchViewCtrl alloc]init];
        [self.navigationController pushViewController:khRequestVC animated:YES];
    }
}

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton) {
        NSLog(@"Did Finish Introduction By Skipping It");
    }
    else if (finishType == MYFinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
    }
}

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    switch (panelIndex) {
        case 0:
            //            [introductionView setBackgroundImage:[UIImage imageNamed:@"guild_1"]];
            break;
            
        case 1:
            //            [introductionView setBackgroundImage:[UIImage imageNamed:@"guild_2"]];
            break;
            
        case 2:
            //            [introductionView setBackgroundImage:[UIImage imageNamed:@"guild_3"]];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end











