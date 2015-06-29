//
//  AppDelegate.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-2.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "SJKHAppDelegate.h"
#import "RootModelViewCtrl.h"
#include "SJKHEngine.h"
#include "func_def.h"
#include "type_def.h"
#import "VideoWitnessViewCtrl.h"
#import "framework.h"
#import "LoginViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "KKNavigationController.h"
#import "PublicMethod.h"
#import "MenuViewCtrl.h"
#import "CrashHandler.h"
#import "aes.h"
#import <Parse/Parse.h>
#import "ShareHeader.h"
#import "LoanMainViewCtrl.h"
#import "IPPingManager.h"
#import "SimplePing.h"
//#import "../../NetWork/NetWork/NetReachability.h"
//#import "../../aximApi_IOS_XMPP_12_19/axim/webconnect/Reachability.h"
#import "Reachability.h"

@interface SJKHAppDelegate (){
    BOOL bWindowShow;
    MenuViewCtrl * vc;
    LoanMainViewCtrl *loadMainVC ;
}
@end

@implementation SJKHAppDelegate

- (id)init{
    self = [super init];
    if(self){
        bWindowShow = NO;
    }
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     推送证书生成过程：
     http://zxs19861202.iteye.com/blog/1532460
     http://blog.csdn.net/kepoon/article/details/22672133
     
     加快提交到appstore速度的解决方案
     http://stackoverflow.com/questions/19953161/xcode-stuck-at-your-application-is-being-uploaded
     
     _valueLabel.text = [NSString stringWithFormat:@"Speed\n%.1f", _shimmeringView.shimmeringSpeed];
     一位小数的写法
     */
    
//    height += ceilf([text sizeWithFont:[UIFont systemFontOfSize:kSummaryTextFontSize] constrainedToSize:CGSizeMake(270.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
/*haoyee alert downsite*/
    
    // 信安工具构造
    
//    [self loadReveal];
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString*appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    int ret = setLicense(appName);
    if (ret != 0) {
        NSString* error;
        getLastErrInfo(&error);
        NSLog(@"setLicense error=%@", error);
    }
    
//    NSLog(@"uuid = %@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
//    4406DC6E-41E2-48C8-913C-C90C953776B2
//    4406DC6E-41E2-48C8-913C-C90C953776B2
    [Parse setApplicationId:@"小薇"
				  clientKey:@"client key"];
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	[CrashHandler setupLogging:YES];
    
//    #ifdef ShengChanMode
//        //ip测速相关
//        IPPingManager * mainObj = [[IPPingManager alloc] init];
//        mainObj.bCaculateFinished = NO;
////        [mainObj performSelectorInBackground:@selector(onGetFastestIP) withObject:nil];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [mainObj onGetFastestIP];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self onShowKeyWindow];
//            });
//        });
//    #else
//        [self onShowKeyWindow];
//    #endif
    
    [self onShowKeyWindow];
    
    while (!bWindowShow) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return YES;
}

- (void)onShowKeyWindow{
    [self openUM];
    
//    [PublicMethod redirectConsoleLogToDocumentFolder];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.layer.contents = (__bridge id)([[UIImage imageNamed:@"SmallLoanBundle.bundle/images/bg_menu"] clipImagefromRect:CGRectMake(0, 8, screenWidth, 20)].CGImage);
    [self.window setHidden:NO];
    
    //    RootModelViewCtrl * vc =[[RootModelViewCtrl alloc] init];
    //    LoginViewCtrl * vc = [[LoginViewCtrl alloc]initWithNibName:@"LoginView" bundle:nil];
    vc = [[MenuViewCtrl alloc]initWithNibName:@"MenuViewCtrl" bundle:nil];
    
    //    KHRequestOrSearchViewCtrl * vc = [[KHRequestOrSearchViewCtrl alloc]init];
    //    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    
    
    UIStoryboard *storyBoard = nil;
    NSString * nibName = @"LoanMainStoryBoard";
    
    if([SJKHEngine Instance]->systemVersion < 6){
        nibName = [nibName stringByAppendingString:FORIOS5XIB];
    }
    
//    NSLog(@"type = %i,%@",[PublicMethod getOPeratorType],[PublicMethod getOperationName]);
    
    storyBoard = [UIStoryboard storyboardWithName:nibName bundle:nil];
    loadMainVC = [storyBoard instantiateInitialViewController];
    
    //    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:loadMainVC];
    self.window.rootViewController = loadMainVC;
    [self.window makeKeyAndVisible];
    [SJKHEngine Instance]->mainWindow = self.window;
    
    //    [PublicMethod setStatusBarStyle];
    
    /*
     sysbols输出为:
     [exception callStackSymbols] = (
     0   CoreFoundation                      0x355682bb <redacted> + 186
     1   libobjc.A.dylib                     0x37f6e97f objc_exception_throw + 30
     2   CoreFoundation                      0x354b2e8d <redacted> + 164
     3   ApexiPhoneOpenAccount               0x000612b1 ApexiPhoneOpenAccount + 135857
     4   UIKit                               0x3b084ad1 <redacted> + 252
     5   UIKit                               0x3b08465b <redacted> + 1190
     6   UIKit                               0x3b07c843 <redacted> + 698
     7   UIKit                               0x3b024c39 <redacted> + 1004
     8   UIKit                               0x3b0246cd <redacted> + 72
     9   UIKit                               0x3b02411b <redacted> + 6154
     10  GraphicsServices                    0x36f085a3 <redacted> + 590
     11  GraphicsServices                    0x36f081d3 <redacted> + 34
     12  CoreFoundation                      0x3553d173 <redacted> + 34
     13  CoreFoundation                      0x3553d117 <redacted> + 138
     14  CoreFoundation                      0x3553bf99 <redacted> + 1384
     15  CoreFoundation                      0x354aeebd CFRunLoopRunSpecific + 356
     16  CoreFoundation                      0x354aed49 CFRunLoopRunInMode + 104
     17  UIKit                               0x3b07b47d <redacted> + 668
     18  UIKit                               0x3b0782f9 UIApplicationMain + 1120
     19  ApexiPhoneOpenAccount               0x000bdf61 ApexiPhoneOpenAccount + 515937
     20  ApexiPhoneOpenAccount               0x00045c28 ApexiPhoneOpenAccount + 23592
     
     先将135857转成16进制数,0x000212b1再加上4000,即为正确的将要搜索的地址
     对应终端命令 atos -arch armv7 -o ApexiPhoneOpenAccount.app/ApexiPhoneOpenAccount 0x000252b1
     终端打印出来的位置信息为:
     -[SJKHAppDelegate application:didFinishLaunchingWithOptions:] (in ApexiPhoneOpenAccount) (SJKHAppDelegate.m:76)
     刚好对应objectAtIndex方法
     */
    //    NSArray * ar =[NSArray array];
    //    [ar objectAtIndex:4];
    
    /*
     更新pod的命令: sudo gem install cocoapods
     */
    
    //   self.view.layer.contents = (id)[UIImage imageNamed:@"lc_detail_main_back.png"].CGImage;
    
    {
        //版本检测、崩溃日记、欢迎界面、网络监听
       // [vc dispatchCheckVersion];
        [vc dispatchUploadConsoleLog];
        [vc onShowIntroductionView];
        [[SJKHEngine Instance]startNotificatioin];
    }
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    bWindowShow = YES;
}

- (void)openUM{
//    [UMSocialData openLog:YES];
    [UMSocialData setAppKey:UmengAppkey];
    
    //    [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" url:@"http://www.umeng.com/social"];
    [UMSocialWechatHandler setWXAppId:@"wx740d4bca4f963310" url:shijiAddress];
    /*
     wechat开放平台：
     AppID：wx740d4bca4f963310
     AppSecret：e310db87f2ec7b0b496f83ae602a03b9
     */
    
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES appRedirectUrl:shijiAddress];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:shijiAddress];
    [UMSocialQQHandler setSupportQzoneSSO:YES];
    
    //设置易信Appkey和分享url地址
    //    [UMSocialYixinHandler setYixinAppKey:@"yx35664bdff4db42c2b7be1e29390c1a06" url:@"http://www.umeng.com/social"];
    
    //设置来往AppId，appscret，显示来源名称和url地址
    //    [UMSocialLaiwangHandler setLaiwangAppId:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" appDescription:@"友盟社会化组件" urlStirng:@"http://www.umeng.com/social"];
    
    //使用友盟统计
    [MobClick startWithAppkey:UmengAppkey];
    
    
    //设置facebook应用ID，和分享纯文字用到的url地址
    //    [UMSocialFacebookHandler setFacebookAppID:@"91136964205" shareFacebookWithURL:@"http://www.umeng.com/social"];
    
    //下面打开Instagram的开关
    //    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
    
    //    [UMSocialTwitterHandler openTwitter];
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [PublicMethod saveToUserDefaults:[SJKHEngine Instance]->SJHM key:SJHMNUMBER];
    [PublicMethod saveToUserDefaults:[SJKHEngine Instance]->xwdAccount key:KHHNUMBER];
    [[SJKHEngine Instance]->userConfigDic writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:USERCONFIGDIC] atomically:YES];
    
//    [PublicMethod saveToUserDefaults:@"1" key:BUploadLog];
    
    for(UIViewController * vc in [SJKHEngine Instance].observeCtrls){
        if([vc isMemberOfClass:[VideoWitnessViewCtrl class]]){
            [((VideoWitnessViewCtrl *)vc) BackToUrls:Nil];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [vc dispatchUploadConsoleLog];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Reveal
//#import <dlfcn.h>
//- (void)loadReveal
//{
//    NSString *revealLibName = @"libReveal";
//    NSString *revealLibExtension = @"dylib";
//    NSString *dyLibPath = [[NSBundle mainBundle] pathForResource:revealLibName ofType:revealLibExtension];
//    NSLog(@"Loading dynamic library: %@", dyLibPath);
//    
//    void *revealLib = NULL;
//    revealLib = dlopen([dyLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
//    
//    if (revealLib == NULL)
//    {
//        char *error = dlerror();
//        NSLog(@"dlopen error: %s", error);
//        NSString *message = [NSString stringWithFormat:@"%@.%@ failed to load with error: %s", revealLibName, revealLibExtension, error];
//        [[[UIAlertView alloc] initWithTitle:@"Reveal library could not be loaded" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }
//}


@end
