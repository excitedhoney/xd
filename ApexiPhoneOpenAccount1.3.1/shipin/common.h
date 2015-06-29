//
//  axim_api_common.h
//  aximApi
//
//  Created by mac on 13-2-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#ifndef __INCLUDE_AXIM_API_COMMON_H__
#define __INCLUDE_AXIM_API_COMMON_H__

#include <vector>
#include <string>


using namespace std;

/*
 * AXIMAPI_STATEMESSAGE
 * 视频见证相关状态消息定义
 */
enum AXIMAPI_STATEMESSAGE
{
    MT_INVALID                      = 0x0000,   //
    
	MT_LOGINED                      = 0x0002,   // 登录成功
	MT_LOGINFAILED                  = 0x0003,   // 登录失败
    MT_LOGINING                     = 0X0004,
    MT_CONNECTCLOSED                = 0x0008,   // 连接关闭
    
	MT_ON_TAGENT_DEPART_QUEUE       = 0x0296,   // 要求离开请求队列（当前无座席）      662
	MT_ON_TAGENT_QUEUE_STATUS       = 0x0297,   // 加入座席请求队列成功，param1值高八位表示在队列中的位置       663
    // 低八位表示所要等待的大概时间（分钟），msg表示提示文本
	MT_ON_JOIN_QUEUE_ERROR          = 0x0298,   // 加入座席请求队列失败，可能当前无座席或工作组不存在        664
    MT_ON_JOIN_QUEUE_AGENTRECEIVE   = 0x0299,   // 座席点接受                                         665
	MT_ON_REQUEST_STOPAGENT         = 0x029D,   // 请求关闭座席服务，如连接关闭、服务结束等         669
	MT_ON_AGENTSERVICE_START        = 0x029E,   // 视频见证服务开始（从座席房间会话建立起，此时视频可能尚未连接）  670
	MT_ON_AGENTSERVICE_FINISH       = 0x029F,   // 视频见证服务结束（座席房间会话结束，视频连接可能先于会话结束）  671
	MT_ON_AGENTVIDEOWITNESS_RESULT  = 0x02A0,   // 视频见证结果（XML格式，可能在视频连接时、或视频连接结束后发送） 672
    
	MT_ON_AGENTVIDEO_INIT           = 0x02B1,   // 视频连接初始化                                  689
	MT_ON_AGENTVIDEO_INPROGRESS     = 0x02B2,   // 视频连接完成（session层连接完成，此时音视频数据通讯层可能还不通） 690
	MT_ON_AGENTVIDEO_TERMINATE      = 0x02B3,   // 视频连接结束           691
    
    MT_ON_QUERY_AGENTAUDIOCHATROOM_RESULT	= 0x02F1,//媒体服务器房间查询结果 753
    
    ON_GET_SERVERS_RESULT           = 0x02F3,       // 获取服务器列表      755
    ON_GET_SERVERS_RESULT_FAILED    = 0x02F4,       // 获取服务器列表失败   756
    
    LOGINEXCEPTION                  = 0x000C,       // 登录异常     12
    
    //    LOGOUT							= 0x02f5,		// 退出程序
};

enum GETAGENTAUDIOSERVERLIST_MESSAGE
{
    LOGINING_NETDISCONNECT = -11,                   //前一次连接处于登录状态，再次连接时网络断开的消息(此时未开始登录状态)
    LOGINED_NETDISCONNECT = -5,                     //上一次连接处于登录状态，再次连接时网络断开的消息
    ISINSERVICE = -1,                               //是否处于"视频见证状态"
    NETDISCONNECT = -2                              //将要执行登录时，网络断开
};

enum AGENT_STATUS
{
    ISLOGING                =0,                       //正在登录
    LOGINED_NOTTO_JOIN_AGENT  =1,                     //登录了，但还没加入座席队列成功
    JOIN_AGENT_SUCCESS = 2,                           //已经加入了请求队列，等待座席答应
    JOIN_PRESENCE_SUCCESS = 3,                        //GroupMemberPresencePush。成员出席。
    INVALID_STATUS = -1                                //不可用状态
};

enum STARTAGENT_MESSAGE
{
    STARTAGENT_ISINSERVICE = -3,                      //startagent时，如果正在视频见证，则不允许再次进行
    STARTAGENT_NETDISCONNECT = -4                     //startagent时，如果没有网络，则不允许进行
};

/*
 * AxIMCameraDeviceInfo
 * 摄像头设备相关信息
 */
struct AxIMCameraDeviceInfo
{
    std::string     deviceUniqueName;           // 摄像头设备名称
    std::string     deviceUniqueId;             // 摄像头的唯一设备id
    int             position;                   // 摄像头的位置，1=后摄像头,2-前摄像头
    
    AxIMCameraDeviceInfo ()
    : position (0)
    {}
};


/*
 * AxIMCameraDeviceInfo
 * 摄像头设备视频捕捉参数信息
 */
struct AxIMCaptureCapability
{
    int         width;
    int         height;
    int         maxFPS;
    
    AxIMCaptureCapability ()
    : width (0)
    , height (0)
    , maxFPS (0)
    {}
};




/*
 * AgentResult
 * 传递报文信息
 */
struct AgentResult
{
    int nErrorCode;
    string sMsg;
    AgentResult()
    {
        
    }
};

/*
 服务器返回的ip队列
 
 audio_server_domain	录制服务器ID
 AgentaudioserverName	录制服务器名称
 IP	录制服务器IP
 OnLine	繁忙值
 
 */
struct ServersResult
{
    string audio_server_domain;
    string agentAudioServerName;
    vector<string> serverIPs;
    string onLine;
    
    ServersResult ()
    : audio_server_domain("")
    , agentAudioServerName("")
    , onLine("")
    {
        
    }
};



#endif







