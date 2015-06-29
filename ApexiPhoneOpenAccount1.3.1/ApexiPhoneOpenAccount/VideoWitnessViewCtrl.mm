//
//  VideoWitnessViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-10.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "VideoWitnessViewCtrl.h"
#import "axim_api.h"
#include "common.h"
#include "message.h"
#include "messagelistener.h"
#import <AVFoundation/AVFoundation.h>
#import "InstallProfileViewCtrl.h"
#import "CertHandle.h"
#import "ClientInfoViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"


#define CONNECTVIDEO @"发起视频"
#define CANCELVIDEO @"停止视频"
#define LOCALVIEWTAG 2013


@interface VideoWitnessViewCtrl (){
    AxIMApi *_aximApi;
    
    string startAgentYyb;           //startagent时连接的营业部ID
    string startAgentDomain;        //startagent时连接的ip
    string cowork_cc_workgroup;     //工作组
    string cowork_cc_wskh_url;      //startagent时要传入的url
    string media_server;            //媒体服务器
    int loginPort;                  //GetAgentaudioserverList获取媒体服务器列表，即登陆。
    
    vector<AxIMCaptureCapability> _capabilities;
    int currentForwardOrBack;
    
    NSString * agentID;
    NSString * roomID;
    BOOL isStartVideo;              //是否已经开始视频
    
    NSString * sWaitTip;
}

@property (nonatomic,strong)NSTimer * activateTimer;

@end

@implementation VideoWitnessViewCtrl

@synthesize activateTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        centerView.tag = LOCALVIEWTAG;
    }
    return self;
}

- (void)viewDidLoad
{
    [self InitConfig];
    [self InitWidgets];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [SJKHEngine Instance]->bVideoAccess = NO;
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    [super viewWillDisappear:animated];
}

- (void)backOperation{
    [self BackToUrls:nil];
}

- (void)setActivateTimer:(NSTimer *)_activateTimer{
    if(activateTimer){
        [activateTimer invalidate];
        activateTimer = nil;
    }
    activateTimer = _activateTimer;
}

- (void) InitConfig{
//    self.view.bounds = CGRectMake(0, 0, screenWidth, self.view.bounds.size.height);
    
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(currentOrien:) userInfo:nil repeats:YES];
    
    currentForwardOrBack = 0;
    _aximApi = AxIMApi::CreateAxIMApi ();
    
    [self.navigationItem setHidesBackButton:YES];
    
    //先这样设置，跳过视频见证阶段。(待调试)
    agentID = @"-1";
    roomID = @"-1";
    media_server = "agentaudioserver.apex";
    activateTimer = nil;
    sWaitTip = @"";
    
#ifdef SelectTest
    NSDictionary * stepDictionary = nil;
    BOOL ok = [self sendGetUUID:&stepDictionary];
    if(ok){
        uuid = [stepDictionary objectForKey:UUID];
    }
#endif
    
    [super InitConfig];
}

- (void) InitWidgets{
    //座席端id 00000 和 房间号；开户视频，见证人
    scrollView.delegate=self;
    [scrollView setContentSize:CGSizeMake(screenWidth, screenHeight - UpHeight)];

    [headerFlowButton setBackgroundImage:[[UIImage imageNamed:@"flow_1"] imageByResizingToSize:CGSizeMake(screenWidth, headerFlowButton.frame.size.height)]
                      forState:UIControlStateNormal];
    [centerImageView setImage:[[UIImage imageNamed:@"icon_video_default"] imageByResizingToSize:centerImageView.frame.size]];
    centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [PublicMethod publicCornerBorderStyle:centerImageView];
    
	[tipLabel setFont: [UIFont systemFontOfSize:16]];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel setBackgroundColor:[UIColor clearColor]];
	[tipLabel setTextColor: [UIColor whiteColor]];
//    tipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [loginOrNextStepButton addTarget:self action:@selector(onVideoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self changeFieldBorderColor:YES targetView:loginOrNextStepButton bJustChangeLayer:NO];
    [loginOrNextStepButton setBackgroundColor:[UIColor colorWithRed:255.0/255 green:71.0/255 blue:96.0/255 alpha:1]];
    [loginOrNextStepButton setTitle:CONNECTVIDEO forState:UIControlStateNormal];
    loginOrNextStepButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [loginOrNextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [scrollView setContentSize:CGSizeMake(screenWidth, loginOrNextStepButton.frame.origin.y + ButtonHeight + verticalHeight)];
    [tipLabel setText:nil];
    
    waitLabe.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
	[waitLabe setFont: [UIFont boldSystemFontOfSize:15]];
    waitLabe.textAlignment = NSTextAlignmentCenter;
	[waitLabe setTextColor: [UIColor blackColor]];
    waitLabe.numberOfLines = 0;
    [waitLabe setText:@"咨询电话:4008323000"];
    waitLabe.lineBreakMode = NSLineBreakByTruncatingTail;
    [waitLabe setAlpha:0];
//    [waitLabe setHidden:YES];
    
    [super InitWidgets];
    
    NSLog(@"views 1=%@,%@,%@,%@",self.view,scrollView,headerFlowButton,loginOrNextStepButton);
}

- (void)onButtonClick:(UIButton *)btn{
    //待调试
    if([roomID isEqualToString:@"-1"] || [agentID isEqualToString:@"-1"]){
        agentID = @"00000288",roomID = @"2013050215442700172";
    }
    
    if([roomID isEqualToString:@"-1"] || [agentID isEqualToString:@"-1"]){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先完成视频验证" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    
#ifdef SelectTest
//    bVideoAccess = YES;
#endif

    if([SJKHEngine Instance]->bVideoAccess){
        NSDictionary * dic =nil;
        NSMutableDictionary * saveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     roomID,KHSP_SPJZ,
                                     agentID,JZR_SPJZ,nil];
        
        [self sendSaveStepInfo:SPJZ_STEP dataDictionary:&dic arrar:saveDic];
        
        while (!bSaveStepFinish) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        bSaveStepFinish = NO;
        
        if(bSaveStepSuccess){
            [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
            
            InstallProfileViewCtrl * installVC = [[InstallProfileViewCtrl alloc]init];
            [self activityIndicate:YES tipContent:@"加载证书信息..." MBProgressHUD:nil target:self.navigationController.view];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [SJKHEngine Instance]->zsgl_step_Dic = nil;
                [self dispatchInstallProfileVC:installVC];
                if ([SJKHEngine Instance]->zsgl_step_Dic &&
                    [SJKHEngine Instance]->zsgl_step_Dic.count > 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                        [self.navigationController pushViewController:installVC animated:YES];
//                        [installVC updateUI];
                    });
                }
                else {
                    [self activityIndicate:NO tipContent:@"加载证书信息失败" MBProgressHUD:nil target:self.navigationController.view];
                    [self goToNextStepFailOperation:loginOrNextStepButton];
                }
            });
        }
        else {
            [self activityIndicate:NO tipContent:@"保存失败" MBProgressHUD:nil target:self.navigationController.view];
            [self goToNextStepFailOperation:loginOrNextStepButton];
        }
    }
}

- (void)goToNextStepFailOperation:(UIButton *)btn{
    dispatch_async(dispatch_get_main_queue(), ^{
        [loginOrNextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    });
    [loginOrNextStepButton removeTarget:self action:@selector(onVideoClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginOrNextStepButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) dispatchInstallProfileVC:(InstallProfileViewCtrl *)installVC{
    NSDictionary * stepDictionary = nil;
    
    //发起证书申请
    if([self sendSaveCurrentStepKey:ZSGL_STEP dataDictionary:&stepDictionary]){
        BOOL ok = [self sendGoToStep:ZSGL_STEP dataDictionary:&stepDictionary];
        if(ok){
            [SJKHEngine Instance]->zsgl_step_Dic = [stepDictionary mutableCopy];
        }
        else {
//            [loginOrNextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
//            [[SJKHEngine Instance] dispatchMessage:POP_MESSAGE];
        }
    }
    else {
//        [loginOrNextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
}

- (void)setTipHUD:(NSString *)text{
    if([SJKHEngine Instance]->spzj_step_Dic == nil || [SJKHEngine Instance]->spzj_step_Dic.count == 0){
        [self activityIndicate:NO tipContent:@"获取视频配置信息失败" MBProgressHUD:nil target:self.navigationController.view];
    }
    else {
        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void)changeTipLabelStatus:(BOOL)bShow{
    if(bShow){
        [centerView bringSubviewToFront:tipLabel];
    }
    else {
        [centerView sendSubviewToBack:tipLabel];
    }
}

- (void)onVideoClick:(UIButton *)button{
#ifdef SelectTest
//   [self changeTipLabelStatus:!isStartVideo];
//   [SJKHEngine Instance]->bVideoAccess = YES;
//   [self onButtonClick:nil];
//   return ;
#endif
    
    [tipLabel setText:Nil];
    
    if (isStartVideo)
    {
        [self BackToUrls:nil];
        isStartVideo = FALSE;
        return;
    }
    
    [self changeCancelBtnTitle:CANCELVIDEO];
    isStartVideo = true;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.20];
    [waitLabe setAlpha:1.0f];
    [loginOrNextStepButton setAlpha:0];
    [UIView commitAnimations];
    
//    [loginOrNextStepButton setHidden:YES];
//    [waitLabe setHidden:NO];
    
    if ([SJKHEngine Instance]->spzj_step_Dic && [SJKHEngine Instance]->spzj_step_Dic.count > 0) {
        NSDictionary * params = [[SJKHEngine Instance]->spzj_step_Dic objectForKey:SPJZPARAMS_SPJZ];
        startAgentYyb = [[params objectForKey:YYB_SPJZ] UTF8String];
        startAgentDomain = [[params objectForKey:COWORK_CC_SERVER_SPJZ] UTF8String];
        loginPort = [[params objectForKey:COWORK_CC_PORT_SPJZ] intValue];
        cowork_cc_workgroup = [[params objectForKey:COWORK_CC_WORKGROUP_SPJZ] UTF8String];
        cowork_cc_wskh_url = [[params objectForKey:COWORK_CC_WSKH_URL_SPJZ] UTF8String];
        
        NSLog(@"params = %@",params);
    }
    
    {//14.03.03 9:57 为东吴演示暂时这么做。这是公司环境
//        startAgentDomain = "218.66.59.175";
//        loginPort = 5222;
//        cowork_cc_workgroup = "openaccount_1@workgroup.apex";
//        startAgentYyb = "1001";
//        startAgentYyb = "2012";
//        cowork_cc_wskh_url = "http://218.66.59.169:1168";
    }
    
//    {//14.03.03 9:57 为东吴演示暂时这么做。这是上海证券环境
//        startAgentDomain = "180.168.121.4";
//        loginPort = 5222;
//        cowork_cc_workgroup = "openaccount_1@workgroup.apex";
//        startAgentYyb = "1001";
//        cowork_cc_wskh_url = "http://180.168.121.15:8088";
//    }
    
    {//14.03.03 13:23 东吴环境
//        startAgentDomain = "222.92.187.156";
//        loginPort = 5222;
//        cowork_cc_workgroup = "openaccount_1@workgroup.apex";
//        startAgentYyb = "1001";
//        startAgentYyb = "10";
//        cowork_cc_wskh_url = "http://222.92.187.156:8080";
    }
    
    {
        //14.05.23 13:23 世纪证券
//        startAgentDomain = "192.168.50.115";
//        loginPort = 5222;
//        cowork_cc_workgroup = "openaccount_1@workgroup.apex";
//        startAgentYyb = "1001";
//        startAgentYyb = "2051";
//        cowork_cc_wskh_url = [[NSString stringWithFormat:@"%@://%@:%d", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port] UTF8String];
    }
    
    vector<AxIMCameraDeviceInfo> arDeviceInfo = _aximApi->GetCameraDeviceList();
    
    _aximApi->SetCameraDeviceName (arDeviceInfo[1].deviceUniqueName);
    
    _aximApi->RegisterMessageListener (self);
    
    // 初始化本地视频视图
    [self updateLocalView];
    // 起一个线程开始视频见证
    [NSThread detachNewThreadSelector: @selector(StartAgentOnNewThread) toTarget: self withObject: nil];
}

static int idd=0;
- (void) StartAgentOnNewThread
{
    char userName[64];
    
//    sprintf(userName, "abc-%d",1);
    
#ifdef SelectTest
#ifdef HAOYTEST
//    startAgentDomain = "180.168.121.4";
////    startAgentDomain = "172.26.64.229";
//    startAgentDomain = "218.66.59.175";
//    startAgentDomain = "192.168.50.115";
//    loginPort = 5222;
//    cowork_cc_workgroup = "openaccount_1@workgroup.apex";
//    startAgentYyb = "1001";
//    startAgentYyb = "2012";
//    startAgentYyb = "2051";
#endif
#endif
    
    int value = (arc4random() % 10000000) + 1;
    sprintf(userName, "%s%s-%d",[[[UIDevice currentDevice] model] UTF8String],[[[UIDevice currentDevice] systemVersion] UTF8String],value);
    dispatch_async(dispatch_get_main_queue(), ^{
        [tipLabel setText:@"正在登录..."];
    });
    
    int sta= _aximApi->GetAgentaudioserverList(startAgentDomain, loginPort,userName);
    
    if(sta == LOGINING_NETDISCONNECT ||
       sta == LOGINED_NETDISCONNECT ||
       sta == ISINSERVICE ||
       sta == NETDISCONNECT)
    {
        [self activityIndicate:NO tipContent:@"已开启视频见证,或当前网络不通,请重试" MBProgressHUD:nil target:self.navigationController.view];
        [self BackToUrls:nil];
    }
}

-(void)updateLocalView{
    _aximApi->InitLocalRenderer(centerImageView);
}

static int pointCount = 0;
- (void)onChangeTipLabel{
    switch (pointCount++ % 3) {
        case 0:
            [tipLabel setText:[NSString stringWithFormat:@"%@.  ",sWaitTip]];
            break;
            
        case 1:
            [tipLabel setText:[NSString stringWithFormat:@"%@.. ",sWaitTip]];
            break;
            
        case 2:
            [tipLabel setText:[NSString stringWithFormat:@"%@...",sWaitTip]];
            break;
            
        default:
            break;
    }
    
}

- (void) HandleMessage: (NSAxIMMessage*) message
{
    [self performSelectorOnMainThread: @selector(HandleMessageOnMainThread:) withObject:message waitUntilDone: NO];
}

static bool firstDemo=false;
//====================================================================================//
- (void) HandleMessageOnMainThread: (NSAxIMMessage*) message
{
    // 消息提示文本
    NSLog(@"message .type =%i,%@",message.nType,message.pMsg);
    std::string msg2 = "";
    
    char userName[64];
    
    switch (message.nType)
    {
        case MT_ON_REQUEST_STOPAGENT:
        {
            
        }
            break;
        case MT_CONNECTCLOSED:
        {
            _capabilities.clear();
            
            [self activityIndicate:NO tipContent:@"网络连接关闭" MBProgressHUD:nil target:self.navigationController.view];
            
            [self BackToUrls:nil];
        }
            break;
            
        case MT_LOGINED:{
            sprintf(userName, "%d",MT_LOGINED);
            msg2 = "登录成功"+(string)userName;
            if(_capabilities.size()==0)
                _capabilities = _aximApi->GetCaptureCapabilities ();
//            [self activityIndicate:YES tipContent:@"连接视频..." MBProgressHUD:nil target:self.navigationController.view];
            [tipLabel setText:@"您已成功登陆,正在连接视频..."];
            
            break;
        }
            
        case MT_LOGINFAILED:
        {
            sprintf(userName, "%d",MT_LOGINFAILED);
            msg2 = "登录失败"+(string)userName;
            
            NSLog(@"登录失败  CameraVedioViewController");
            
            [self BackToUrls:nil];
            
            [self activityIndicate:NO tipContent:@"登录失败" MBProgressHUD:nil target:self.navigationController.view];
//            [tipLabel setText:@"登录失败"];
            
            [self changeCancelBtnTitle:CONNECTVIDEO];
            
            break;
        }
            
        case ON_GET_SERVERS_RESULT:{
            sprintf(userName, "%d",ON_GET_SERVERS_RESULT);
            
            msg2 = "获得媒体服务器列表"+(string)userName;
           [tipLabel setText:@"获得媒体服务器列表"];
            
            printf("msg  字符串 =%@",message.pParam1);
            NSMutableArray * serversArray =(NSMutableArray *) message.pParam2;
            if(serversArray.count > 0 && serversArray){
                int random = arc4random() % serversArray.count;
                media_server = [[serversArray objectAtIndex:random] UTF8String];
                NSLog(@"随机取的random =%i,%s",random,media_server.c_str());
            }
            
            int state = [self toStartAgent];
            if(state == STARTAGENT_ISINSERVICE ||
               state == STARTAGENT_NETDISCONNECT)
            {
                [self activityIndicate:NO tipContent:@"已开始见证服务或网络已断开,请稍候再试" MBProgressHUD:nil target:self.navigationController.view];
                [self BackToUrls:nil];
            }
            
            break;
        }
        case ON_GET_SERVERS_RESULT_FAILED:{
            sprintf(userName, "%d",ON_GET_SERVERS_RESULT_FAILED);
            
            msg2 = "获取服务器列表失败"+(string)userName;
            [self activityIndicate:NO tipContent:@"获取服务器列表失败" MBProgressHUD:nil target:self.navigationController.view];
            [tipLabel setText:@"获取服务器列表失败"];
            
            int state = [self toStartAgent];
            if(state == STARTAGENT_ISINSERVICE ||
               state == STARTAGENT_NETDISCONNECT)
            {
                [self BackToUrls:nil];
            }
            
            break;
        }
        case MT_ON_TAGENT_DEPART_QUEUE:
            sprintf(userName, "%d",MT_ON_TAGENT_DEPART_QUEUE);
            
            msg2 = "当前无座席，要求离开请求队列,同时关闭视频"+(string)userName;
            
            [self BackToUrls:nil];
            [self changeCancelBtnTitle:CONNECTVIDEO];
            
            self.activateTimer = nil;
            [self activityIndicate:NO tipContent:@"当前无座席，要求离开请求队列,同时关闭视频" MBProgressHUD:nil target:self.navigationController.view];
//            [tipLabel setText:@"连接失败,当前无座席"];
            break;
            
        case MT_ON_TAGENT_QUEUE_STATUS:
            sprintf(userName, "%d",MT_ON_TAGENT_QUEUE_STATUS);
            sWaitTip = [NSString stringWithFormat:@"您当前排在队列中第%@位，预计等待时间%@分钟以内，请稍侯",message.pMsg,message.pMsg];
            NSLog(@"message =%@",message.pMsg);
            [tipLabel setText:sWaitTip];
            
            self.activateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onChangeTipLabel) userInfo:nil repeats:YES];
            
            break;
            
        case MT_ON_JOIN_QUEUE_AGENTRECEIVE:
            self.activateTimer = nil;
            break;
            
        case MT_ON_JOIN_QUEUE_ERROR:
            self.activateTimer = nil;
            sprintf(userName, "%d",MT_ON_JOIN_QUEUE_ERROR);
            
            msg2 = "加入座席请求队列失败，可能当前无座席或工作组不存在"+(string)userName;
            [self BackToUrls:nil];
            [self activityIndicate:NO tipContent:@"加入座席请求队列失败，可能当前无座席或工作组不存在" MBProgressHUD:nil target:self.navigationController.view];
            
            [self changeCancelBtnTitle:CONNECTVIDEO];
            break;
            
        case MT_ON_AGENTSERVICE_START:
        {
            self.activateTimer = nil;
            //见证人和房间号在这里读取。
            int location =[message.pMsg rangeOfString:@"&"].location;
            roomID = [message.pMsg substringToIndex:location];
            agentID = [message.pMsg substringFromIndex:location+1];
            
            sprintf(userName, "%d",MT_ON_AGENTSERVICE_START);
            
            msg2 = "视频见证服务开始"+(string)userName;
            [tipLabel setText:@"视频见证服务开始"];
            
//            NSLog(@"param1 param2 =%@",message.pParam1);
//            NSLog(@"ram2 =%@",message.pParam2);
        }
            break;
        case MT_ON_AGENTSERVICE_FINISH:
            
            sprintf(userName, "%d",MT_ON_AGENTSERVICE_FINISH);
            
            msg2 = "视频见证服务结束（座席房间会话结束，视频连接可能先于会话结束）, msg为房间号"+(string)userName;
            
            break;
            
        case MT_ON_QUERY_AGENTAUDIOCHATROOM_RESULT:{
            if([message.pMsg isEqualToString:@"error"]){
                [self activityIndicate:NO tipContent:@"查询视频房间失败" MBProgressHUD:nil target:self.navigationController.view];
                
                [self BackToUrls:nil];
//                [self activityIndicate:NO tipContent:@"连接失败,媒体服务器可能已关闭" MBProgressHUD:nil target:nil];
//                [tipLabel setText:@"连接失败,媒体服务器可能已关闭"];
            }
            break;
        }
            
        case MT_ON_AGENTVIDEOWITNESS_RESULT:
        {
            if(_capabilities.size()>0){
                AxIMCaptureCapability capability = _capabilities[0];
                capability.maxFPS = 0;
                _aximApi->SetCaptureCapability (capability, true);
            }
            
            sprintf(userName, "%d",MT_ON_AGENTVIDEOWITNESS_RESULT);
            
            msg2 = "视频见证结果（XML格式结果，可能在视频连接时、也可能在视频连接结束后发送）, 由应用层自身解析XML内容"+(string)userName;
            
            printf("result code number = [%d]\n",(int *)message.pParam1);
            printf("test string = [%s]\n",((char *)message.pParam2));
            
            [self changeCancelBtnTitle:CONNECTVIDEO];
            [self BackToUrls:nil];
            
            if((int)message.pParam1 == 1){
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"审核通过" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
                [self activityIndicate:YES tipContent:@"审核通过,正在跳转证书页面" MBProgressHUD:nil target:self.navigationController.view];
                
                [SJKHEngine Instance]->bVideoAccess = YES;
                [self.navigationItem.leftBarButtonItem.customView setHidden:YES];
                
                [self onButtonClick:nil];
                
            }
            else{
                //在这可加入提示信息，由开发者自定
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:((NSString*)(message.pParam2)) delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
        }
            break;
            
        case MT_ON_AGENTVIDEO_INIT:
            sprintf(userName, "%d",MT_ON_AGENTVIDEO_INIT);
            
            msg2 = "视频连接初始化"+(string)userName;
            [tipLabel setText:@"视频见证初始化"];
            
            break;
            
        case MT_ON_AGENTVIDEO_INPROGRESS:
        {
            [self changeUIStatus:YES];
            
//            [self.benchmarkButton setTranslatesAutoresizingMaskIntoConstraints:YES];
//            [centerImageView setAutoresizingMask:UIViewAutoresizingNone];
//            centerImageView.translatesAutoresizingMaskIntoConstraints=NO;
            sprintf(userName, "%d",MT_ON_AGENTVIDEO_INPROGRESS);
            
            msg2 = "视频连接完成（session层连接完成，此时音视频数据通讯层存在不通的可能）"+(string)userName;
            
            UInt32 doChangeDefaultRoute =1;
            
            AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute),&doChangeDefaultRoute);
            
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            //默认情况下扬声器播放
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
            
            if(_capabilities.size() == 0)
                _capabilities = _aximApi->GetCaptureCapabilities ();
            
            [remoteView setHidden:NO];
            _aximApi->ShowRemoteRenderer (remoteView, YES);
            [tipLabel setText:@"视频连接成功,请不要随意挂断或切换其他界面"];
            
//            [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:nil];
        }
            break;
            
        case MT_ON_AGENTVIDEO_TERMINATE:
        {
            msg2 = "视频连接结束";
            
            NSLog(@"视频连接结束");
            
            [self BackToUrls:nil];
        }
            break;
    }
}

- (void)changeUIStatus:(BOOL)bChange{
    if(bChange){
        centerImageView.transform =CGAffineTransformMakeRotation( M_PI/2 );
//        tipLabel.transform = CGAffineTransformMakeRotation( -M_PI/2 );
        remoteView.transform = CGAffineTransformMakeRotation( M_PI );
        [remoteView setHidden:NO];
    }
    else {
        centerImageView.transform =CGAffineTransformIdentity;
//        tipLabel.transform = CGAffineTransformIdentity;
        remoteView.transform = CGAffineTransformIdentity;
        [remoteView setHidden:YES];
    }
}

- (void)changeCancelBtnTitle:(NSString *)title{
    [loginOrNextStepButton setTitle:title forState:UIControlStateNormal];
    if([title isEqualToString:CONNECTVIDEO]){
        isStartVideo = false;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.20];
        [waitLabe setAlpha:0];
        [loginOrNextStepButton setAlpha:1];
        [UIView commitAnimations];
        
//        [loginOrNextStepButton setHidden:NO];
//        [waitLabe setHidden:YES];
        
//        [loginOrNextStepButton.layer addAnimation:[SJKHEngine Instance]->topTransition forKey:nil];
//        [UIView animateWithDuration:.2f
//                            delay:0
//                         options:UIViewAnimationOptionCurveEaseOut
//                        animations:^{
//                            loginOrNextStepButton.alpha = 0;
//                            [waitLabe setAlpha:1];
//                        }
//                          completion:^(BOOL bl){
//       
//                       }];
    }
}

- (int) toStartAgent{
    //            string url = cowork_cc_wskh_url + "/wskh/mobile/query/getUserInfoByUUID?uuid=" + (string)(uuid.UTF8String);
    NSString * url = [NSString stringWithFormat:@"%s/wskh/mobile/query/getUserInfoByUUID?uuid=%@",cowork_cc_wskh_url.c_str(),uuid];
    string htmlCustom_info = [[NSString stringWithFormat:@"<param><url>%@</url><khfs>2</khfs><khfsmc>视频见证</khfsmc></param>",url] UTF8String];
//    char userName[64];
//    int value = (arc4random() % 10000000) + 1;
//    sprintf(userName, "%s%d",[[[UIDevice currentDevice] model] UTF8String],value);

    char * userName = const_cast<char *>([[[SJKHEngine Instance]->jbzl_cache_dic objectForKey:KHXM_OCR] UTF8String]);
//    [SJKHEngine Instance]->khjbzl = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"刘以浩",KHXM_OCR, nil];
    
//#ifndef SelectTest
//    if([SJKHEngine Instance]->khjbzl.count > 0){
//        userName = (string)[[[SJKHEngine Instance]->khjbzl objectForKey:KHXM_OCR] UTF8String];
//    }
//    else {
//        userName = "abc";
//    }
//#endif
    
    string address = [[NSString stringWithFormat:@"%@://%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port] UTF8String];
    NSLog(@"address uuid username =%s,%s,%s,%s",address.c_str(),uuid.UTF8String,userName,string(userName).c_str());
    //如果uuid是为nil的，则跑不下去了。
    
    htmlCustom_info = "<param><khjlid>0</khjlid>	<khjlmc>网上开户</khjlmc>	<khxm>"+string(userName)+"</khxm><khfs>3</khfs>	<khfsmc>见证开户2</khfsmc>	<url>"+ address +"/wskh/mobile/cowork/getUserInfoByUUID?uuid="+string(uuid.UTF8String)+"</url></param>";
    //	<reviewurl>"+ address +"/wskh/mobile/cowork/showUserCertReviewByUUID?uuid="+string(uuid.UTF8String)+"&amp;khsp=$SessionID$&amp;jzr=$AgentID$</reviewurl>
    
    return _aximApi->StartAgent(startAgentYyb ,
                                string(userName),
                                htmlCustom_info,
                                cowork_cc_workgroup,
                                media_server,
                                startAgentDomain ,
                                "90");
}

-(void) BackToUrls:(id)sender
{
    self.activateTimer = nil;
    _aximApi->setVideoFinish(true);
    [self changeUIStatus:NO];
    
    if(_capabilities.size() > 0){
        NSLog(@"设置帧率为0");
        
        AxIMCaptureCapability capability = _capabilities[0];
        capability.maxFPS = 0;
        _aximApi->SetCaptureCapability (capability, true);
    }
    
    _aximApi->StopAgent();
    
    [tipLabel setText:nil];
    [self changeCancelBtnTitle:CONNECTVIDEO];
    _aximApi->UnRegisterMessageListener(self);
}

- (void)viewDidLayoutSubviews{
    scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight - UpHeight);
    [scrollView setContentSize:CGSizeMake(screenWidth, loginOrNextStepButton.frame.origin.y + loginOrNextStepButton.frame.size.height + verticalHeight)];
    
//    CGRect rect = loginOrNextStepButton.frame;
//  loginOrNextStepButton.frame = CGRectMake(rect.origin.x,
//                                             rect.origin.y + 20,
//                                             rect.size.width,
//                                             rect.size.height);
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"views =%@,%@,%@,%@,%@",self.view,scrollView,headerFlowButton,loginOrNextStepButton,[CertHandle defaultCertHandle]);
    NSLog(@"handle =%@",[CertHandle defaultCertHandle]);
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)popToLastPage{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self activityIndicate:YES tipContent:@"加载失败" MBProgressHUD:nil target:self.navigationController.view];
//        hud.mode = MBProgressHUDModeText;
//        sleep(2);
//        [hud hide:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//    });
    [self backOperation];
    
    NSArray * ar = self.navigationController.viewControllers;
    BaseViewController * preVC = [ar objectAtIndex:ar.count - 2];
    preVC->bReEnter = YES;
    
    if([SJKHEngine Instance]->jbzl_step_Dic.count == 0 || [SJKHEngine Instance]->jbzl_step_Dic == nil){
//        [self performSelectorInBackground:@selector(popMessageSelect:) withObject:preVC];
        [self popMessageSelect:preVC];
    }
    else{
        [self.navigationController popViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
    }
    
    [super popToLastPage];
}

- (void)popMessageSelect:(BaseViewController *)preVC{
    [[SJKHEngine Instance]->rootVC popToZDPage:JBZL_STEP preVC:preVC];
}

- (void) updateUI{
    [super updateUI];
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
//    [UIView animateWithDuration:0.2 animations:^{
//        [cancelVideoBtn setAlpha:1];
//    }completion:^(BOOL finish){
//        
//    }];
}

- (void)dealloc{
    _aximApi = nil;
    _capabilities.clear();
    self.activateTimer = nil;
    
    [headerFlowButton removeFromSuperview];
    headerFlowButton = nil;
    [centerView removeFromSuperview];
    centerView = nil;
    [remoteView removeFromSuperview];
    remoteView = nil;
    [centerImageView removeFromSuperview];
    centerImageView = nil;
    [tipLabel removeFromSuperview];
    tipLabel = nil;
    [loginOrNextStepButton removeFromSuperview];
    loginOrNextStepButton = nil;
    [waitLabe removeFromSuperview];
    waitLabe = nil;
    
    NSLog(@"视频见证回收");
}

@end

















