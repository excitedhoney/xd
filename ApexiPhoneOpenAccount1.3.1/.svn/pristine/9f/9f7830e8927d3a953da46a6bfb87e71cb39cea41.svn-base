//
//  CertHandle.h
//  ApexiPhoneOpenAccount
//
//  Created by haoliuyang on 14-5-14.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "framework.h"
#import "SJKHEngine.h"
#import "MBProgressHUD.h"
#import "Data_Structure.h"
#import "UIImage+custom_.h"
#import "CustomAlertView.h"
#import "BaseViewController.h"

@protocol CertHandleDelegate <NSObject>

- (void)certHandleResault:(NSString *)resaultString;

@end

@interface CertHandle : NSObject <InfosecSecurity,NSCopying,NSMutableCopying>{
    NSDictionary *_certJsonDic;
    NSDictionary *_pkcsDic;
    NSMutableDictionary * responseDictionary;
    BOOL bKeyBoardShow;
    BOOL bSaveStepFinish;
    BOOL bSaveStepSuccess;
    NSString *bdid;
    NSString *_warnStr;
}

@property (retain,nonatomic) id<InfosecSecurity> infosec;
@property (strong, nonatomic) id<CertHandleDelegate> delegate;
@property (retain, nonatomic)NSString *snStr;
@property (retain, nonatomic)NSString *dnStr;
@property (retain, nonatomic)NSString *ckhStr;
@property (retain, nonatomic)NSString *pkcsStr;
@property (retain, nonatomic)NSString *certLeixingStr;
@property (retain, nonatomic)NSString *sqmStr;
@property (retain, nonatomic)NSString *bfjgStr;


- (YEorNO)certToHandle;
- (YEorNO)certState;
- (YEorNO)certDownloadState;
- (YEorNO)certUpdateState;
- (YEorNO)sendRequestCert;
- (YEorNO)vailCert;
- (void)createHandleData;
- (YEorNO)vailCertExist;
- (YEorNO)secVailCertWithXYDic:(NSDictionary *)xyDic;
- (BOOL)toSaveProfileStepData;

+ (CertHandle *)defaultCertHandle;
+ (id) allocWithZone:(NSZone *)zone;

@end
