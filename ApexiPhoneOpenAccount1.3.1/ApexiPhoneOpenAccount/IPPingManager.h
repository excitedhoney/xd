//
//  IPPingManager.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-6-26.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"
#import "ShareDataStructure.h"

@interface IPPingManager : NSObject<SimplePingDelegate>{
    @public
}

- (void)runWithHostName:(serverItem *)item;

- (void)onGetFastestIP;

@property (nonatomic, strong, readwrite) SimplePing *   pinger;
@property (nonatomic, strong, readwrite) NSTimer *      sendTimer;
@property (nonatomic, strong, readwrite) serverItem *   item;
@property (atomic)BOOL bCaculateFinished;


@end
