//
//  Header.h
//  aximApi
//
//  Created by mac on 13-2-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#ifndef __INCLUDE_AXIM_API_H__
#define __INCLUDE_AXIM_API_H__

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include "common.h"
#include "messagelistener.h"

class AxIMApi
{
protected:
    AxIMApi () {}
    virtual ~AxIMApi () {}
    
public:
    static AxIMApi* CreateAxIMApi ();
    static int DestroyAxIMApi (AxIMApi* aximApi);
    static AxIMApi* axApiImpl;
    
    
private:
    
    
public:
    /*
	 * InitLocalRenderer
	 * Description:
	 *   1、初始化本地视频试图，必须在ui线程调用
     *   2、在调用StartAgent前必须调用本函数。
	 *
	 * @params
	 *   local_renderer_holder  用于装载本地视频视图
	 */
    virtual int InitLocalRenderer (UIView* local_renderer_holder) = 0;
    
    
    
    /*
	 * StartAgent
	 * Description:
	 *   1、发起视频见证服务
     *   2、必须新建一个子线程调用
	 *
	 * @params
	 *   server                 IM服务器地址
	 *   port                   IM服务器端口
     *   yyb                    见证营业部ID
     *   username               顾客姓名
     *   custom_info            顾客信息
	 *   work_group             视频见证座席工作组JID号 默认为“”
     *   audio_server_domain    视频录制服务器域 默认为“”
	 */
    
//	virtual int StartAgent (const std::string& server, int port, const std::string& yyb,const std::string& mRotate , const std::string& username, const std::string& custom_info, const std::string& work_group, const std::string& audio_server_domain) = 0;
	
    
    /*
	 * onLogin
	 * Description:
	 *   登录痤席方法
	 *
	 * @params
	 *   server                 IM服务器地址
	 *   port                   IM服务器端口
	 */
//    virtual int onLogin(const std::string& server, int port) = 0;
    
    
    /*
     获得媒体服务器列表
     server                 IM服务器地址
     port                   IM服务器端口
     userID                 用户名
     */
    virtual int GetAgentaudioserverList(const std::string& server, int port,const std::string& userID)=0;
    
    
    /*
     获得当前登录状态
     */
    
//    virtual int GetCurrentLoginStatus()=0;
    
    
    /*
	 * StartAgent
     
	 * @params
     
        yyb                     见证营业部ID
        username                顾客姓名
        custom_info             顾客信息
        work_group              视频见证座席工作组JID号
        audio_server_domain     视频录制服务器
        audio_server_ip         视频录制服务器ip
        mRotate                 旋转角度
	 */
	virtual int StartAgent (const std::string& yyb ,
                            const std::string& username,
                            const std::string& custom_info,
                            const std::string& work_group,
                            const std::string& audio_server_domain,
                            const std::string& audio_server_ip,
                            const std::string& mRotate ) = 0;

   
    
    
	/*
	 * StopAgent
	 * Description:
	 *   1、结束视频见证服务
	 */
	virtual int StopAgent () = 0;
	
	/*
	 * ShowRemoteRenderer
	 * Description:
	 *   1、显示／隐藏对方视频，必须在UI线程调用
	 *   2、remote_renderer_holder用于装载对方视频视图
	 */
	virtual int ShowRemoteRenderer (UIView* remote_renderer_holder, bool show) = 0;
	
	/*
	 * IsInService
	 * Description:
	 *   1、判断当前是否正在视频见证服务
	 *   2、从座席接受请求后、座席服务房间会话建立起，就认为正在服务中(此时可能还没发起视频连接)。
	 */
	virtual bool IsInService () const = 0;
    
    /*
	 * IsInWaiting
	 * Description:
	 *   1、判断当前是否正在请求视频见证服务
	 */
	virtual bool IsInWaiting () const = 0;
    /*
     * 获得视频登录、发起连接的状态。
     */
    virtual AGENT_STATUS getAgent_Status() const;
	
	/*
	 * GetCameraDeviceList
	 * Description:
	 *   1、获取视频设备列表
	 *   2、用AxIMCameraDeviceInfo对象中的deviceUniqueName来设置所选的摄像头名称。
	 */
	virtual vector<AxIMCameraDeviceInfo> GetCameraDeviceList () const = 0;
	
	/*
	 * SetCameraDeviceName
	 * Description:
	 *   1、设置服务所使用的视频设备
	 *   2、默认camera_name_为空，取设备列表中第一个视频设备。
	 */
	virtual void SetCameraDeviceName (const std::string& camera_name) = 0;
	
	/*
	 * SetCaptureCapability
	 * Description:
	 *   1、设置当前会话中视频设备的捕捉参数，含宽度、高度、帧频(设置1~29）。
	 *   2、参数capability应选自GetCaptureCapabilities所获取到的参数列表，其中帧频可以不一样。
	 *   3、应用层在收到视频连接完成的消息（MT_ON_AGENTVIDEO_INPROGRESS)后，才能调用该函数
	 */
	virtual int SetCaptureCapability (
                                      const AxIMCaptureCapability& capability, bool fixed_capability) = 0;
    
    
    /*
     在执行RenderFrame时改变当前分辨率
     */
//	virtual void ChangeViewCapture();
    
	/*
	 * GetCaptureCapabilities
	 * Description:
	 *   1、获取当前会话中视频设备的捕捉参数列表，含宽度、高度、帧频。
	 *   2、应用层在收到视频连接完成的消息（MT_ON_AGENTVIDEO_INPROGRESS)后，才能调用该函数
	 */
	virtual vector<AxIMCaptureCapability> GetCaptureCapabilities () const = 0;
	
	/*
	 * Reset
	 * Description:
	 *   1、调用该函数前，必须结束座席服务。
	 * 	 2、这个函数结束与IM服务器的连接，释放音视频设备等。
	 * 	 3、在完全退出视频见证服务或视频设备无法启动时，可尝试调用。
	 */
	virtual bool Reset () = 0;
	
	/*
	 * RegisterMessageListener
	 * Description:
	 *   1、注册消息监听器，用于监听函数OnStateMessage中派发的相关状态信息.
	 *   2、具体状态消息类型见AxIMConstants中的定义
	 */
	virtual bool RegisterMessageListener (AxIMMessageListener* listener) = 0;
    
    /*
	 * RegisterMessageListener
	 * Description:
	 *   1、注册消息监听器，用于监听函数OnStateMessage中派发的相关状态信息.
	 *   2、具体状态消息类型见AxIMConstants中的定义
     *   3、listener为NSObject派生类，且必须实现protocol MessageListenerDelegate，详见message.h
	 */
	virtual bool RegisterMessageListener (id listener) = 0;
	
    
	/*
	 * UnRegisterMessageListener
	 */
	virtual bool UnRegisterMessageListener (AxIMMessageListener* listener) = 0;
    
    /*
	 * UnRegisterMessageListener
	 */
	virtual bool UnRegisterMessageListener (id listener) = 0;
    
    
    /*
     * 发送顾客信息
     */
    virtual int SetCustomerInfo (const std::string& customer_info) = 0;
    
    
    virtual void setVideoFinish(bool _videoFinish)=0;
    
};



#endif





