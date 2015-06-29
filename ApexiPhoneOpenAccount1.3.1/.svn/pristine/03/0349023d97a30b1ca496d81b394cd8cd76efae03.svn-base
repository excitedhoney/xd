/*
 *  @filename	: UIMessage.h
 *  @description: Apexsoft IM UIMessage
 *	@createdate	: 2013-02-20
 *	@author		: guojin
 *
 *  CopyRight (c) 2011 Apexsoft. All right reserved.
 *
 */

#ifndef WIN32
#ifndef __AXIMAPI_UIMESSAGE_HANDLER_H__
#define __AXIMAPI_UIMESSAGE_HANDLER_H__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "common.h"



struct AxIMMessage
{
    int             nType;
    std::string     msg;
    void*           pParam1;
    void*           pParam2;
    
    
    AxIMMessage (int nType, const std::string& msg, 
                 void* pParam1 = NULL, void* pParam2 = NULL)
        : nType (nType)
        , msg (msg)
        , pParam1 (pParam1)
        , pParam2 (pParam2) 
    {}
    
    
    AxIMMessage ()
        : nType (MT_INVALID)
        , pParam1 (NULL)
        , pParam2 (NULL)
    {}
};

@interface NSAxIMMessage : NSObject
{
	int				nType;
	NSString*		pMsg;
	void*			pParam1;
	void*			pParam2;
}

@property(nonatomic, assign) NSString* pMsg;
@property(nonatomic, assign) int nType;
@property(nonatomic, assign) void* pParam1;
@property(nonatomic, assign) void* pParam2;

@end

//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#pragma mark -
#pragma mark Delegate Protocol
//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

@protocol NSAxIMMessageListenerDelegate <NSObject>

- (void) HandleMessage: (NSAxIMMessage*) message;

@end

#endif
#endif