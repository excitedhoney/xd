//
//  ViewController.m
//  TWCX
//
//  Created by mac  on 14-3-15.
//  Copyright (c) 2014年 mac . All rights reserved.
//


#import "ViewController.h"
#import "axim_api.h"
//#import "comm_def.h"
#import "common.h"
#import "message.h"
#import <AVFoundation/AVFoundation.h>
//#import "MyViewController.h"


@interface ViewController (){
    vector<AxIMCaptureCapability> _capabilities;
    AxIMApi * _aximApi;
    UIView *localRenderView;
    UIView *remoteRenderView;
//    MyViewController * myVC;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    localRenderView=[[UIView alloc]initWithFrame:CGRectMake(55, 40,205 ,205)];
    remoteRenderView=[[UIView alloc]initWithFrame:CGRectMake(55, 210 +40 ,205 , 205 )];
    
    [localRenderView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.6]];
    [remoteRenderView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.6]];
    
    
    [self.view addSubview:localRenderView];
    [self.view addSubview:remoteRenderView];
    
//    myVC = [[MyViewController alloc]init];
    _aximApi= AxIMApi::CreateAxIMApi ();

    [self OnUIClickStartAgentButton];

	// Do any additional setup after loading the view, typically from a nib.
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
    NSLog(@"message .type =%i",message.nType);
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
            
            [self BackToUrls:nil];
        }
            break;
            
        case MT_LOGINED:{
            sprintf(userName, "%d",MT_LOGINED);
            msg2 = "登录成功"+(string)userName;
            if(_capabilities.size()==0)
                _capabilities = _aximApi->GetCaptureCapabilities ();
            
            break;
        }
            
        case MT_LOGINFAILED:
        {
            sprintf(userName, "%d",MT_LOGINFAILED);
            msg2 = "登录失败"+(string)userName;
            
            NSLog(@"登录失败  CameraVedioViewController");
            
            [self BackToUrls:nil];
            
            break;
        }
            
        case ON_GET_SERVERS_RESULT:{
            
            sprintf(userName, "%d",ON_GET_SERVERS_RESULT);
            
            msg2 = "获得媒体服务器列表"+(string)userName;
            
            printf("msg  字符串 =%s",message.pParam2);
            
            NSString *clip=[NSString stringWithCString:((char *)message.pParam2) encoding:NSUTF8StringEncoding];
            
            /*
             sbf.append("<url>" + url + "</url>");
             sbf.append("<khfs>2</khfs>");
             sbf.append("<khfsmc>视频见证</khfsmc>");
             sbf.append("</param>");
             */
            

            
            break;
        }
        case ON_GET_SERVERS_RESULT_FAILED:{
            sprintf(userName, "%d",ON_GET_SERVERS_RESULT_FAILED);
            
            msg2 = "获取服务器列表失败"+(string)userName;
            
            NSLog(@"获取服务器列表失败 是么");
            
//            //            string url = cowork_cc_wskh_url + "/wskh/mobile/query/getUserInfoByUUID?uuid=" + (string)(uuid.UTF8String);
//            NSString * url = [NSString stringWithFormat:@"%s/wskh/mobile/query/getUserInfoByUUID?uuid=%@",cowork_cc_wskh_url.c_str(),uuid];
//            string htmlCustom_info = [NSString stringWithFormat:@"<param><url>%@</url><khfs>2</khfs><khfsmc>视频见证</khfsmc></param>",url].UTF8String;
//            //            string htmlCustom_info = (string)"<param>" + "<url>" + url + "</url>" + "<khfs>2</khfs>" + "<khfsmc>视频见证</khfsmc>" + "</param>";
//            
//            NSLog(@"param =%s,%s,%s,%s",htmlCustom_info.c_str(),
//                  cowork_cc_workgroup.c_str(),
//                  startAgentDomain.c_str(),
//                  startAgentYyb.c_str());
            
//            int status= _aximApi->StartAgent("9999" ,
//                                             "abc-1",
//                                             "",
//                                             "",
//                                             "agentaudioserver.apex",
//                                             startAgentDomain ,
//                                             "90");
            
            int status= _aximApi->StartAgent("9999" , "abc-1", "顶点", "openaccount_1@workgroup.apex", "agentaudioserver.apex", "180.168.121.4" , "90");
            
            break;
        }
        case MT_ON_TAGENT_DEPART_QUEUE:
            sprintf(userName, "%d",MT_ON_TAGENT_DEPART_QUEUE);
            
            msg2 = "当前无座席，要求离开请求队列,同时关闭视频"+(string)userName;
            
            break;
            
        case MT_ON_TAGENT_QUEUE_STATUS:
            sprintf(userName, "%d",MT_ON_TAGENT_QUEUE_STATUS);
            
            msg2 = "加入座席请求队列成功，pParam1值高八位表示在队列中的位置，低八位表示所要等待的大概时间（分钟），msg表示提示文本"+(string)userName;
            
            break;
            
        case MT_ON_JOIN_QUEUE_ERROR:
            sprintf(userName, "%d",MT_ON_JOIN_QUEUE_ERROR);
            
            msg2 = "加入座席请求队列失败，可能当前无座席或工作组不存在"+(string)userName;
            
            break;
            
        case MT_ON_AGENTSERVICE_START:
        {
            //见证人和房间号在这里读取。
            
            sprintf(userName, "%d",MT_ON_AGENTSERVICE_START);
            
            msg2 = "视频见证服务开始"+(string)userName;
            
            //            roomID = [message.pMsg intValue];
        }
            break;
        case MT_ON_AGENTSERVICE_FINISH:
            
            sprintf(userName, "%d",MT_ON_AGENTSERVICE_FINISH);
            
            msg2 = "视频见证服务结束（座席房间会话结束，视频连接可能先于会话结束）, msg为房间号"+(string)userName;
            
            break;
            
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
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:((NSString*)(message.pParam2)) delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
            [alert show];
            
            [self BackToUrls:nil];
        }
            break;
            
        case MT_ON_AGENTVIDEO_INIT:
            sprintf(userName, "%d",MT_ON_AGENTVIDEO_INIT);
            
            msg2 = "视频连接初始化"+(string)userName;
            
            break;
        case MT_ON_AGENTVIDEO_INPROGRESS:
        {
            sprintf(userName, "%d",MT_ON_AGENTVIDEO_INPROGRESS);
            
            msg2 = "视频连接完成（session层连接完成，此时音视频数据通讯层存在不通的可能）"+(string)userName;
            
            UInt32 doChangeDefaultRoute =1;
            
            AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute),&doChangeDefaultRoute);
            
            NSLog(@"视频连接完成");
            
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            //默认情况下扬声器播放
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
            
            _aximApi->ShowRemoteRenderer (remoteRenderView, YES);
            
            if(_capabilities.size()==0)
                _capabilities = _aximApi->GetCaptureCapabilities ();
            
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

- (void) OnUIClickStartAgentButton
{
    if (_aximApi->IsInService())
    {
        return;
    }
    
    
    //    NSArray* cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //    NSString* a = ((AVCaptureDevice*)[cameras objectAtIndex:1]).localizedName;
    
    
    // 选择一个摄像头
    vector<AxIMCameraDeviceInfo> arDeviceInfo = _aximApi->GetCameraDeviceList();
    //    if ((int) arDeviceInfo.size() > 1)
    //    {
    //        _aximApi->SetCameraDeviceName (arDeviceInfo[1].deviceUniqueName);
    //    }
    //    else
    //    {
    //        _aximApi->SetCameraDeviceName (arDeviceInfo[0].deviceUniqueName);
    //    }
    
    _aximApi->SetCameraDeviceName (arDeviceInfo[0].deviceUniqueName);
    
    _aximApi->RegisterMessageListener (self);
    
    // 初始化本地视频视图
    [self updateLocalView];
    [self updateRemoteView:YES];
    // 起一个线程开始视频见证
    [NSThread detachNewThreadSelector: @selector(StartAgentOnNewThread) toTarget: self withObject: nil];
}

static int idd=0;
- (void) StartAgentOnNewThread
{
    char userName[64];
    
    sprintf(userName, "abc-%d",idd++);
    
    int sta= _aximApi->GetAgentaudioserverList("180.168.121.4", 5222,"abc-1");
}

-(void)updateLocalView{
    dispatch_async(
                   dispatch_get_main_queue(), ^{
                       _aximApi->InitLocalRenderer(localRenderView);
                   }
                   );
}

-(void)updateRemoteView:(BOOL)isTurnon{
    //    _remoteRendererShowing = !_remoteRendererShowing;
    
    
}

-(void) BackToUrls:(id)sender
{
    _aximApi->setVideoFinish(true);
    
    if(_capabilities.size() > 0){
        NSLog(@"设置帧率为0");
        
        AxIMCaptureCapability capability = _capabilities[0];
        capability.maxFPS = 0;
        _aximApi->SetCaptureCapability (capability, true);
    }
    
    _aximApi->StopAgent();
    
    _aximApi->UnRegisterMessageListener(self);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
