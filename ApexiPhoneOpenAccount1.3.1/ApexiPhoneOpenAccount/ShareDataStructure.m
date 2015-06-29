//
//  ShareDataStructure.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-6-22.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "ShareDataStructure.h"

@implementation serverItem

@synthesize name,ip, port, type;
@synthesize startTime;
@synthesize endTime;
@synthesize bTestSpeedSuccess;

- (id)init{
    self = [super init];
    if(self){
        name = @"";
        ip = @"";
        port = @"";
        startTime = nil;
        endTime = nil;
        bTestSpeedSuccess = YES;
    }
    
    return self;
}

- (void)dealloc {
    
}

@end


@implementation UserSettingObject


@end


@implementation ShareDataStructure

@end
