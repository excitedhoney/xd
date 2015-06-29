//
//  ShareDataStructure.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-6-22.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface serverItem : NSObject {
@public
	NSString * ip;
	NSString * port;
	NSInteger  type;
	NSDate * startTime;
	NSDate * endTime;
}

@property (nonatomic, retain) NSString *ip, *port,*name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, assign) int velocityRank;
@property (nonatomic, assign) int bTestSpeedSuccess;

@end

@interface UserSettingObject : NSObject{
@public
	BOOL bRememberAccount;
    BOOL bForgetSecret;
	
}

@end

@interface ShareDataStructure : NSObject

@end
