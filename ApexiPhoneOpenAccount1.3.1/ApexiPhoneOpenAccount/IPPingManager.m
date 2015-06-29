//
//  IPPingManager.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-6-26.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "IPPingManager.h"
#include "SimplePing.h"
#import "Data_Structure.h"
#include <sys/socket.h>
#include <netdb.h>
#import "SJKHEngine.h"

#pragma mark * Utilities

static NSString * DisplayAddressForAddress(NSData * address)
{
    int         err;
    NSString *  result;
    char        hostStr[NI_MAXHOST];
    
    result = nil;
    
    if (address != nil) {
        err = getnameinfo([address bytes], (socklen_t) [address length], hostStr, sizeof(hostStr), NULL, 0, NI_NUMERICHOST);
        if (err == 0) {
            result = [NSString stringWithCString:hostStr encoding:NSASCIIStringEncoding];
        }
    }
    
    return result;
}

@implementation IPPingManager
    
@synthesize pinger    = _pinger;
@synthesize sendTimer = _sendTimer;
@synthesize bCaculateFinished;

- (void)dealloc
{
    [self->_pinger stop];
    [self->_sendTimer invalidate];
}

- (NSString *)shortErrorFromError:(NSError *)error
{
    NSString *      result;
    NSNumber *      failureNum;
    int             failure;
    const char *    failureStr;
    
    result = nil;
    
    if ( [[error domain] isEqual:(NSString *)kCFErrorDomainCFNetwork] && ([error code] == kCFHostErrorUnknown) ) {
        failureNum = [[error userInfo] objectForKey:(id)kCFGetAddrInfoFailureKey];
        if ( [failureNum isKindOfClass:[NSNumber class]] ) {
            failure = [failureNum intValue];
            if (failure != 0) {
                failureStr = gai_strerror(failure);
                if (failureStr != NULL) {
                    result = [NSString stringWithUTF8String:failureStr];
                }
            }
        }
    }
    
    if (result == nil) {
        result = [error localizedFailureReason];
    }
    if (result == nil) {
        result = [error localizedDescription];
    }
    if (result == nil) {
        result = [error description];
    }
    return result;
}

- (void)runWithHostName:(serverItem *)item
{
    self.pinger = [SimplePing simplePingWithHostName:item.ip];
    _item = item;
    
    self.pinger.delegate = self;
    [self.pinger start];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (self.pinger != nil);
}

//static int sendPingCount = 0;
- (void)sendPing
{
    [self.pinger sendPingWithData:nil];
}

- (void)onControlReceivePackageTimeinterval{
    if(_item.endTime == nil){
        [self.pinger stop];
        self.pinger = nil;
        _item.bTestSpeedSuccess = NO;
    }
}

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
// A SimplePing delegate callback method.  We respond to the startup by sending a
// ping immediately and starting a timer to continue sending them every second.
{
#pragma unused(pinger)
    NSLog(@"pinging  %@", DisplayAddressForAddress(address));
    
    [self sendPing];
    
    //    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
// A SimplePing delegate callback method.  We shut down our timer and the
// SimplePing object itself, which causes the runloop code to exit.
{
#pragma unused(error)
    NSLog(@"failed: %@", [self shortErrorFromError:error]);
    
    [self.sendTimer invalidate];
    self.sendTimer = nil;
    
    _item.bTestSpeedSuccess = NO;
    self.pinger = nil;
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet
// A SimplePing delegate callback method.  We just log the send.
{
#pragma unused(pinger)
#pragma unused(packet)
    _item.startTime= [NSDate date];
    
    [self performSelector:@selector(onControlReceivePackageTimeinterval) withObject:nil afterDelay:1];
    NSLog(@"#%u sent", (unsigned int) OSSwapBigToHostInt16(((const ICMPHeader *) [packet bytes])->sequenceNumber) );
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error
// A SimplePing delegate callback method.  We just log the failure.
{
#pragma unused(pinger)
#pragma unused(packet)
#pragma unused(error)
    
    NSLog(@"#%u send failed: %@", (unsigned int) OSSwapBigToHostInt16(((const ICMPHeader *) [packet bytes])->sequenceNumber), [self shortErrorFromError:error]);
    
    self.pinger = nil;
    _item.bTestSpeedSuccess = NO;
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet
// A SimplePing delegate callback method.  We just log the reception of a ping response.
{
#pragma unused(pinger)
#pragma unused(packet)
    NSLog(@"#%u received", (unsigned int) OSSwapBigToHostInt16([SimplePing icmpInPacket:packet]->sequenceNumber) );
    
    _item.endTime = [NSDate date];
    self.pinger = nil;
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    const ICMPHeader *  icmpPtr;
    
#pragma unused(pinger)
#pragma unused(packet)
    
    icmpPtr = [SimplePing icmpInPacket:packet];
    if (icmpPtr != NULL) {
        NSLog(@"#%u unexpected ICMP type=%u, code=%u, identifier=%u", (unsigned int) OSSwapBigToHostInt16(icmpPtr->sequenceNumber), (unsigned int) icmpPtr->type, (unsigned int) icmpPtr->code, (unsigned int) OSSwapBigToHostInt16(icmpPtr->identifier) );
    }
    else {
        NSLog(@"unexpected packet size=%zu", (size_t) [packet length]);
    }
    
    _item.endTime = [NSDate date];
    self.pinger = nil;
}

/*
 深圳的电信地址是 119.145.36.248
 联通地址是      210.21.198.168
 移动地址是      222.139.143.132
 南昌电信地址1   59.55.129.109
 南昌电信地址2   59.52.255.148
 南昌网通地址    58.17.24.179
 */
- (void)onGetFastestIP{
    NSArray * ips = [NSArray arrayWithObjects:
                     @"xwszdx.csco.com.cn",   //电信
                     @"xwszlt.csco.com.cn",   //联通
                     @"xwszyd.csco.com.cn",  //移动
                     
                     @"xwncdx.csco.com.cn",    //电信
                     @"xwnclt.csco.com.cn",     //联通
                     @"xwncyd.csco.com.cn",   //移动
                     
                     @"xwnbdx.csco.com.cn",  //电信
                     @"xwnblt.csco.com.cn",     //联通
                     @"xwnbyd.csco.com.cn",   //移动
                     
                     @"xwbjdx.csco.com.cn",  //电信
                     @"xwbjlt.csco.com.cn",   //联通
                     nil];
//    NSArray * ips = [NSArray arrayWithObjects:
//                     @"119.145.36.248",
//                     nil];
    NSMutableArray * serverItems = [NSMutableArray array];
    
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeStyle:NSDateFormatterFullStyle];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NETTYPE phoneNetType = [PublicMethod getOPeratorType];
    
    for (int i= 0; i<ips.count ;i++) {
        NSString * ip = [ips objectAtIndex:i];
        serverItem * item = [[serverItem alloc]init];
        item.ip = ip;
        
        switch (i) {
            case 0:
            case 3:
            case 6:
            case 9:
                item.name = @"电信地址";
                item.type = NETTYPE_DIANXIN;
                break;
                
            case 1:
            case 4:
            case 7:
            case 10:
                item.name = @"联通地址";
                item.type = NETTYPE_LIANTONG;
                break;
                
            case 2:
            case 5:
            case 8:
                item.name = @"移动地址";
                item.type = NETTYPE_YIDONG;
                break;
        }
        
        if(item.type == phoneNetType){
            [self runWithHostName:item];
            NSLog(@"begintime endtiem =%@,%@,%@",
                  [dateformatter stringFromDate: item.startTime],
                  [dateformatter stringFromDate:item.endTime],
                  ip);
            
            [serverItems addObject:item];
        }
    }
    
    NSTimeInterval  time = 1;
    int itemIndex = 0;
    
    if(serverItems.count > 0 && serverItems){
        for (int index = 0; index < serverItems.count ;index++) {
            serverItem * item = [serverItems objectAtIndex:index];
            if(item.bTestSpeedSuccess && item.endTime){
                NSTimeInterval intv = [item.endTime timeIntervalSinceDate:item.startTime];
                
                NSLog(@"intv =%i,%f,%f",itemIndex,time,intv);
                if(intv < time){
                    time = intv;
                    itemIndex = index;
                }
            }
        }
        [SJKHEngine Instance]->doMain = ((serverItem *)[serverItems objectAtIndex:itemIndex]).ip;
    }
    
    bCaculateFinished = YES;
}

@end


















