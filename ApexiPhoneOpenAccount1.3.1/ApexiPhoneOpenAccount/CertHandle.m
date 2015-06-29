//
//  CertHandle.m
//  ApexiPhoneOpenAccount
//
//  Created by haoliuyang on 14-5-14.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "CertHandle.h"


//static MBProgressHUD *hud;

//NSDictionary *_certJsonDic;
//NSDictionary *_pkcsDic;

@implementation CertHandle

@synthesize infosec = _infosec;
@synthesize snStr,dnStr,ckhStr,pkcsStr,
certLeixingStr,sqmStr,bfjgStr;
@synthesize delegate;

static CertHandle *certHandle = nil;
+ (CertHandle * )defaultCertHandle{
    @synchronized(self)
	{
		if (certHandle == nil)
        {
            //            certHandle = [[CertHandle alloc] init];
            [[self alloc] init];
        }
    }
	return  certHandle;
}

- (id)init
{
    @synchronized(self) {
        if ([super init]) {
            isDirctLoad = nop;
        }
        
        return self;
    }
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (certHandle == nil) {
            certHandle = [super allocWithZone:zone];
            return certHandle;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (YEorNO)setCertJsonDic:(NSMutableDictionary *)certJsonDic{
    return nop;
}

- (YEorNO)setPkcsDic:(NSDictionary *)pksDic{
    return nop;
}

//  证书处理
YEorNO handleState = nop;
YEorNO sureFailed = nop;
YEorNO isDirctLoad = nop;
YEorNO bSureNetWeak = nop;

- (void)createHandleData{
    if ([SJKHEngine Instance]->isKaiHuOVER) {
        NSLog(@"createHandleData [SJKHEngine Instance]->khbd_info_Dic = %@",[SJKHEngine Instance]->khbd_info_Dic);
        _pkcsDic = [NSDictionary dictionaryWithObjects:@[
                                                         [[SJKHEngine Instance]->khbd_info_Dic objectForKey:SN_ZSGL]]
                                               forKeys:@[SN_ZSGL]];
    }
    else{
        _pkcsDic = [[[[SJKHEngine Instance]->khsq_info_Dic objectForKey:StepData_Login] objectForKey:ZSGL_STEP] mutableCopy];
        NSLog(@"_pkcsDic createHandle = %@",_pkcsDic);
        isDirctLoad = nop;
    }
}

- (YEorNO)certToHandle{
    handleState = nop;
    sureFailed = nop;
    YEorNO resault = nop;
    
    int i = 0;
    
    while (i < 2 && !handleState) {
        handleState = nop;
        sureFailed = nop;
        int k = 0;
        
        while (!handleState && !sureFailed && k < 2) {
            if(bSureNetWeak){
                break ;
            }
            
            if ([SJKHEngine Instance]->isKaiHuOVER) {
                // -->reload
                NSLog(@"开户流程已走完，去ReloadCert");
                
                YEorNO r_CertUpdateState = nop;
                r_CertUpdateState = [self certUpdateState];
                k++;
                if (!r_CertUpdateState) {
                    sureFailed = yep;
                    break;
                }
            }
            YEorNO r_CertState = nop;
            
            r_CertState = [self certState];
            
            if (r_CertState) {
                NSLog(@"已申请");
                YEorNO r_CertDownloadState = nop;
                
                r_CertDownloadState = [self certDownloadState];
                
                if (r_CertDownloadState == 3) {
                    break;
                }
                if (r_CertDownloadState) {
                    // -->update
                    NSLog(@"已下过，去更新");
                    YEorNO r_CertUpdateState = nop;
                    r_CertUpdateState = [self certUpdateState];
                    k++;
                    if (!r_CertUpdateState) {
                        sureFailed = yep;
                        break;
                    }
                    [NSThread sleepForTimeInterval:1.0];
                }
                else{
                    // -->download
                    NSLog(@"未下过，去下载");
                    [self downloadOperations];
                }
            }
            else{
                // -->requst
                YEorNO r_CertRequest = nop;
                r_CertRequest = [self sendRequestCert];
                k++;
                
                if (!r_CertRequest) {
                    NSLog(@"未更新成功");
                    sureFailed = yep;
                    break;
                }
                handleState = nop;
                sureFailed = nop;
                [NSThread sleepForTimeInterval:1.0];
            }
        }
        i++;
    }
    if(i == 2){
        sureFailed = YES;
        _warnStr = @"安装证书失败";
        
    }
    if(bSureNetWeak){
        sureFailed = YES;
        _warnStr = @"网络不给力";
        bSureNetWeak = NO;
    }
    
    [self.delegate certHandleResault:_warnStr];
    resault = !sureFailed;
    return resault;
}

// 证书状态
- (YEorNO)certState{
    YEorNO resault = nop;
    YEorNO isOk = nop;
    isOk = [self sendQueryCer];  // 是否请求查询成功
    
    if (isOk) {
        if (!isDirctLoad) {
            _pkcsDic = [[_certJsonDic objectForKey:CertJson_ZSGL] mutableCopy];
        }
        YEorNO isCerJsonExist = nop;
        isCerJsonExist = _pkcsDic ? yep : nop;
        NSLog(@"haoyee_isCerJsonExist:%d",isCerJsonExist);
        if (isCerJsonExist) {
            resault = yep;
            NSLog(@"querycert 已申请");
            return resault;
        }
        else{
            resault = nop;
            return resault;
        }
    }
    else{
        sureFailed = yep;
        return nop;
    }
    _warnStr = @"证书查询失败";
    NSLog(_warnStr);
    return resault;
}

// 证书下载状态
- (YEorNO)certDownloadState{
    YEorNO resault = nop;
    NSString *downloadStatus;
    downloadStatus = [_pkcsDic objectForKey:STATUS_ZSGL];
    resault = downloadStatus.intValue == 1 ? nop : (downloadStatus.intValue == 2 ? yep : 3);
    
    if (resault == 3) {
        sureFailed = yep;
    }
    
    NSLog(@"result stauts =%i,%i",resault,[downloadStatus intValue]);
    
    // 1 未下载;2 已下载要更新
    if (resault) {
        NSLog(@"已下载，需更新");
    }
    else{
        NSLog(@"未下过，去下载 1位置");
    }
    return resault;
}

// 证书更新状态
- (YEorNO)certUpdateState{
    YEorNO resault = nop;
    resault = [self sendUpdateCer];
    if (resault) {
        NSLog(@"已更新");
    }
    else{
        NSLog(@"未更新成功");
    }
    return resault;
}

// 证书申请状态
// 证书申请
- (YEorNO)sendRequestCert{
    YEorNO resault = nop;
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,SZZSSQ];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar objectAtIndex:0]];
    [theRequest setPostValue:[NSString stringWithFormat:@"%i",[SJKHEngine Instance]->bfjg_type]
                      forKey:[ar objectAtIndex:1]];
    
    [theRequest startSynchronous];
    resault = [self parseResponseData:theRequest];
    
    if (!_certJsonDic || !resault) {
        _warnStr = @"证书申请失败";
        NSLog(@"失败原因 =%@,%@" ,_warnStr, [_certJsonDic objectForKey:NOTE]);
    }
    else{
        _warnStr = @"证书申请成功";
    }
    return resault;
}

- (YEorNO)vailCertExist{
    infosec_init();
    Class tmpclass = NSClassFromString(@"InfosecSecurityImpl");
    _infosec = [[tmpclass alloc] init];
    YEorNO resault = nop;
    NSMutableString *tempStr = [NSMutableString string];
    [_infosec getSignerCertInfo:&tempStr ofType:MY_CERT_SERIALNUMBER];
    NSString *tempstring = [NSString stringWithFormat:@"%@",tempStr];
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:[tempstring componentsSeparatedByString:@":"]];
    NSLog(@"temArr = %@",temArr);
    NSMutableString *snNumberLoc = [NSMutableString string];
    if (temArr && temArr.count) {
        for (NSString *str in temArr) {
            [snNumberLoc appendString:str];
        }
    }
    else return nop;
    
    self.snStr = [NSString stringWithFormat:@"%@",snNumberLoc];
    NSLog(@"snStr = %@",self.snStr);
    NSLog(@"_pkcsDic = %@",_pkcsDic);
    
    NSString *snNumber = [_pkcsDic objectForKey:SN_ZSGL];
    if (snNumberLoc && snNumber && [snNumberLoc isEqualToString:snNumber]) {
        resault = yep;
    }
    
    NSLog(@"haoyee_test::snNumberLoc:snNumber\n%@\n%@\n", snNumberLoc, snNumber);
    return resault;
}

- (YEorNO)downloadOperations{
    //p:{"LX":"","CKH":"","AUTHCODE":"","PKCS":""}
    //LX:证书类型  1=软证书  2=硬证书
    //    CKH、AUTHCODE两码，查询接口返回的ckh、sqm
    //PKCS:PCK10码，通过证书控件生成 18926080902
    
    infosec_init();
    Class tmpclass = NSClassFromString(@"InfosecSecurityImpl");
    _infosec = [[tmpclass alloc]init];
    
    NSDictionary * dic = nil;
    NSString * pkcs = [self getPKCS:_pkcsDic];
    NSDictionary * downloadCertDic;
    if(pkcs){
        downloadCertDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",LX_ZSGL,
                           [_pkcsDic objectForKey:CKH_ZSGL],CKH_ZSGL,
                           [_pkcsDic objectForKey:AUTHCODE_ZSGL],AUTHCODE_ZSGL,
                           pkcs,PKCS_ZSGL,
                           [_pkcsDic objectForKey:BFJG_ZSGL],BFJG_ZSGL,
                           nil];
        
        self.ckhStr = [[_pkcsDic objectForKey:CKH_ZSGL] mutableCopy];
        self.sqmStr = [[_pkcsDic objectForKey:AUTHCODE_ZSGL] mutableCopy];
        NSLog(@"ckhStr = %@",self.ckhStr);
        NSLog(@"sqmStr = %@",self.sqmStr);
        YEorNO resault = nop;
        
        BaseViewController * targetVC = (BaseViewController *)self.delegate;
        [targetVC activityIndicate:YES tipContent:@"正在下载证书..." MBProgressHUD:nil target:targetVC.navigationController.view];
        resault = [self downloadCert:downloadCertDic responseDic:&dic];
        int status;
        if(dic && resault){
            status = (int)[_infosec importCert:[dic objectForKey:ZSSJ_ZSGL] keyStorePwd:[SJKHEngine Instance]->sImportPassword];
            
            YEorNO vailCertState = nop;
            vailCertState = [self vailCertExist];
            [SJKHEngine Instance]->zsgl_upload_dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [dic objectForKey:DN_ZSGL],DN_ZSGL,
                                                      self.ckhStr,CKH_ZSGL,
                                                      self.snStr,SN_ZSGL,
                                                      self.sqmStr, @"SQM",
                                                      nil];
            NSLog(@"snstr = %@",self.snStr);
            
            if(status == 0 && vailCertState){
                NSMutableDictionary *jsonDic = [[SJKHEngine Instance]->zsgl_upload_dic mutableCopy];
                if ((!jsonDic) && jsonDic.count < 4) {
                    sureFailed = yep;
                    _warnStr = @"证书导入反馈未成功";
                    return !sureFailed;
                }
                
                handleState = yep;
                _warnStr = @"证书安装成功";
                return handleState;
            }
            else{
                sureFailed = yep;
                _warnStr = @"证书导入失败";
                
                return nop;
            }
        }
        else {
            sureFailed = yep;
            _warnStr = @"证书下载失败";
            
            return nop;
        }
    }
    else{
        sureFailed = yep;
        _warnStr = @"证书安装失败";
        
        return nop;
    }
    sureFailed = yep;
    _warnStr = @"未知错误,再试下吧";
    return nop;
}

- (BOOL)toSaveProfileStepData{
    YEorNO zsglState = nop;
    NSMutableDictionary *stepDic = nil;
    zsglState = [self toSendSaveStepInfo:@"zsgl" dataDictionary:&stepDic arrar:[SJKHEngine Instance]->zsgl_upload_dic];
    
    return zsglState;
}

#import "framework.h"
- (NSString *)getPKCS:(NSDictionary *)dic{
    NSMutableData *p10 = [NSMutableData data];
    NSString *algorithm = @"sha1";
    UInt32 keyLength = 1024;
    NSLog(@"[SJKHEngine Instance]->sImportPassword=%@,%@",[SJKHEngine Instance]->sImportPassword,[SJKHEngine Instance]->sPrePin);
    
    [_infosec changeOldPIN:[SJKHEngine Instance]->sPrePin toNewPIN:[SJKHEngine Instance]->sImportPassword];
    [SJKHEngine Instance]->sPrePin = [SJKHEngine Instance]->sImportPassword;
    
    INFOSEC_RV rv = [_infosec createP10:p10 WithDN:@"CN=test,OU=test,O=test" algorithm:algorithm keyLength:keyLength keyStorePwd:[SJKHEngine Instance]->sImportPassword];
    if(rv!=INFOSEC_E_SUCCESS)
    {
//        NSString *info = 0;
        switch (rv) {
            case INFOSEC_E_PIN:
//                info = @"PIN错误";
                break;
                
            default:
//                info = @"内部错误";
                break;
        }
        return nil;
    }
    
    [PublicMethod saveToUserDefaults:[PublicMethod onGetEncodeString:[SJKHEngine Instance]->sImportPassword] key:SProfilePassword];
    UInt8 ending = 0;
    [p10 appendBytes:&ending length:1];
    NSString *cert = [NSString stringWithUTF8String:p10.bytes];
    return cert;
}

- (YEorNO)sendQueryCer{
    YEorNO isOver = [SJKHEngine Instance]->isKaiHuOVER;
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,isOver ? CHECKDN : XQZSJK];
    
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:URL];
    [theRequest setShouldContinueWhenAppEntersBackground:YES];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    if (isOver) {
        [theRequest setPostValue:[[SJKHEngine Instance]->khbd_info_Dic objectForKey:KHXM_OCR] forKey:@"khxm"];
        [theRequest setPostValue:[[SJKHEngine Instance]->khbd_info_Dic objectForKey:ZJLB_OCR] forKey:@"zjlb"];
        [theRequest setPostValue:[[SJKHEngine Instance]->khbd_info_Dic objectForKey:ZJBH_OCR] forKey:@"zjbh"];
        [theRequest setPostValue:[NSString stringWithFormat:@"%i",[SJKHEngine Instance]->bfjg_type]
                          forKey:@"bfjg"];
        bdid = [_certJsonDic objectForKey:@"ID"];
        NSLog(@"bdid = %@",bdid);
        NSLog(@"_certJsonDic bdid = %@",_certJsonDic);
        [theRequest setPostValue:bdid forKey:@"bdid"];
    }
    else{
        [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                          forKey:@"sj"];
        [theRequest setPostValue:[NSString stringWithFormat:@"%i",[SJKHEngine Instance]->bfjg_type]
                          forKey:@"bfjg"];
    }
    
    [theRequest startSynchronous];
    YEorNO res =nop;
    res =[self parseResponseData:theRequest];
    if (!res) {
        sureFailed = yep;
        _warnStr = @"证书查询失败";
        return !sureFailed;
    }
    NSLog(@"haoyee:证书查询成功");
    return res;
}

- (YEorNO)sendUpdateCer{
    YEorNO resault = nop;
    YEorNO isOver = [SJKHEngine Instance]->isKaiHuOVER;
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@",
                              [SJKHEngine Instance]->isHttps?@"https":@"http",
                              [SJKHEngine Instance]->doMain,
                              [SJKHEngine Instance]->port,
                              isOver ? RELOADCERT : SZZSGX];
    
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:URL];
    [theRequest setShouldContinueWhenAppEntersBackground:YES];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    
    if (isOver) {
        [theRequest setPostValue:[[SJKHEngine Instance]->khbd_info_Dic objectForKey:@"SJ"] forKey:@"sj"];
        [theRequest setPostValue:[[SJKHEngine Instance]->khbd_info_Dic objectForKey:ZJLB_OCR] forKey:@"zjlb"];
        [theRequest setPostValue:[[SJKHEngine Instance]->khbd_info_Dic objectForKey:ZJBH_OCR] forKey:@"zjbh"];
        [theRequest setPostValue:[[SJKHEngine Instance]->khbd_info_Dic objectForKey:KHXM_OCR] forKey:@"khxm"];
        [theRequest setPostValue:[NSString stringWithFormat:@"%i",[SJKHEngine Instance]->bfjg_type]
                          forKey:@"bfjg"];
    }else{
        [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                          forKey:@"sj"];
        [theRequest setPostValue:[NSString stringWithFormat:@"%i",[SJKHEngine Instance]->bfjg_type]
                          forKey:@"bfjg"];
    }
    
    [theRequest startSynchronous];
    
    resault = [self parseResponseData:theRequest];
    if (!resault) {
        sureFailed = yep;
        _warnStr = @"证书更新失败";
        return !sureFailed;
    }
    _warnStr = @"haoyee:证书更新成功";
    return resault;
}

- (YEorNO)downloadCert:(NSDictionary *)stepResponseDic responseDic:(NSDictionary **)responseDic{
    //p:{"LX":"","CKH":"","AUTHCODE":"","PKCS":""}
    //LX:证书类型  1=软证书  2=硬证书
    //    CKH、AUTHCODE两码，查询接口返回的ckh、sqm
    //PKCS:PCK10码，通过证书控件生成
    
    YEorNO resault = nop;
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,XZZSJK];
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:URL];
    [theRequest setShouldContinueWhenAppEntersBackground:YES];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    
    if ([NSJSONSerialization isValidJSONObject:stepResponseDic]) // 判断是否可以构建成为json对象
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:stepResponseDic options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString *jsonString = [[NSString alloc]initWithData:tempJsonData encoding:NSUTF8StringEncoding];
        [theRequest setPostValue:jsonString forKey:P_ZSGL];
        
        [theRequest startSynchronous];
        resault = [self parseResponseData:theRequest dic:responseDic];
        if (!resault) {
            sureFailed = yep;
            _warnStr = @"证书下载失败";
        }
        NSLog(@"证书下载成功");
        return resault;
    }
    sureFailed = yep;
    _warnStr = @"证书下载失败";
    return resault;
}

- (YEorNO)parseResponseData:(ASIFormDataRequest *)theRequest{
    if(theRequest.responseData){
        _certJsonDic = [NSJSONSerialization JSONObjectWithData:theRequest.responseData options:NSJSONReadingMutableContainers error:Nil];
//        NSString * tip = nil;
//        NSString *testSTR = [_certJsonDic objectForKey:NOTE];
        NSLog(@"_certJsonDic =%@,%@,%@",_certJsonDic,[_certJsonDic objectForKey:NOTE],theRequest.url);
        if([_certJsonDic objectForKey:NOTE]){
//            tip = [PublicMethod getNSStringFromCstring:[[_certJsonDic objectForKey:NOTE] UTF8String]];
        }
        if(_certJsonDic && [[_certJsonDic objectForKey:SUCCESS] intValue] == 1){
            return yep;
        }
        else{
            return nop;
        }
    }
    
    bSureNetWeak = yep;
    return nop;
}

- (YEorNO)vailCert{
    NSString *snStr = nil;
    NSString *dnStr = nil;
    NSString *valueStr = nil;
    NSString *bfjgStr = @"1";
    NSString *signStr = nil;
    NSMutableData *signData = [NSMutableData data];
//    NSLog(@"%@",[SJKHEngine Instance]->zqzh_step_Dic);
    
//    valueStr = [NSString stringWithFormat:(@"%@(ID=%@,版本号=%@);%@(ID=%@,版本号=%@)",
//                                           [[[SJKHEngine Instance]->zqzh_step_Dic objectAtIndex:0] objectForKey:@"XYBT"],
//                                           [[[SJKHEngine Instance]->zqzh_step_Dic objectAtIndex:0] objectForKey:@"ID"],
//                                           [[[SJKHEngine Instance]->zqzh_step_Dic objectAtIndex:0] objectForKey:@"XYBB"],
//                                           [[[SJKHEngine Instance]->zqzh_step_Dic objectAtIndex:1] objectForKey:@"XYBT"],
//                                           [[[SJKHEngine Instance]->zqzh_step_Dic objectAtIndex:1] objectForKey:@"ID"],
//                                           [[[SJKHEngine Instance]->zqzh_step_Dic objectAtIndex:1] objectForKey:@"XYBB"])];
    
    valueStr = [NSMutableString string];
    
    if([SJKHEngine Instance]->zqzh_step_Dic && [SJKHEngine Instance]->zqzh_step_Dic.count > 0){
        for (NSDictionary * dic in [SJKHEngine Instance]->zqzh_step_Dic) {
            //        NSLog(@"kaolu =%@,%@,%@",[dic objectForKey:@"XYBT"],[dic objectForKey:@"ID"],[dic objectForKey:@"XYBB"]);
            valueStr = [valueStr stringByAppendingFormat:@"%@(ID=%@,版本号=%@);",[dic objectForKey:@"XYBT"],[dic objectForKey:@"ID"],[dic objectForKey:@"XYBB"]];
        }
    }
    else{
        valueStr = @"原文";
    }
    
    NSLog(@"valueStr =%@",valueStr);
    
    snStr = [self certContentWithType:MY_CERT_SERIALNUMBER];
    dnStr = [self certContentWithType:MY_CERT_SUBJECT];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSMutableData *valueData = [valueStr dataUsingEncoding:enc];
    int state = (int)[_infosec detachedSignData:valueData keyStorePwd:[SJKHEngine Instance]->sImportPassword signature:signData];
    if (!state && signData) {
        NSMutableData * base64 = [NSMutableData data];
        [_infosec encodeData:signData toBase64:base64];
        signStr = [NSString stringWithUTF8String:base64.bytes];
    }
    else{
        if(state == INFOSEC_E_PIN){
            [self.delegate certHandleResault:@"密码不正确,请重新输入"];
            
            return 0;
        }
        
        [self.delegate certHandleResault:@"证书签名失败,请输入证书密码"];
        
        return 0;
    }
    NSLog(@"haoyee_test:signStr:%@,%i",signStr,state);
    
    NSDictionary *vailJson = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              snStr,        @"sn",
                              dnStr,        @"dn",
                              valueStr,     @"value",
                              bfjgStr,      @"bfjg",
                              signStr,      @"sign",
                              nil];
    NSDictionary *responDic = nil;
    [self detachSign:vailJson responseDic:&responDic];
    if([[responDic objectForKey:SUCCESS] intValue] == 1){
        _warnStr = @"证书验签成功";
        [SJKHEngine Instance]->qmlsh = [responDic objectForKey:RecordId];
        [self.delegate certHandleResault:_warnStr];
        return yep;
    }
    else{
        NSLog(@"responseDic =%@,%@",responDic,[responDic objectForKey:NOTE]);
        _warnStr = @"签名失败";
        if([responDic objectForKey:@"note"]){
            _warnStr = [_warnStr stringByAppendingFormat:@",%@",[responDic objectForKey:@"note"]];
        }
        
        [self.delegate certHandleResault:_warnStr];
        return nop;
    }
}

- (YEorNO)secVailCertWithXYDic:(NSDictionary *)xyDic{
    NSString *snStr = nil;
    NSString *dnStr = nil;
    NSString *valueStr = nil;
    NSString *bfjgStr = @"1";
    NSString *signStr = [NSString string];
    NSMutableData *signData = [NSMutableData data];
    
    valueStr = [NSString stringWithFormat:(@"%@(ID=%@,版本号=%@)",
                                           [xyDic objectForKey:@"XYBT"],
                                           [xyDic objectForKey:@"ID"],
                                           [xyDic objectForKey:@"XYBB"])];
    snStr = [self certContentWithType:MY_CERT_SERIALNUMBER];
    dnStr = [self certContentWithType:MY_CERT_SUBJECT];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSMutableData *valueData = [valueStr dataUsingEncoding:enc];
    int state = (int)[_infosec detachedSignData:valueData keyStorePwd:[SJKHEngine Instance]->sImportPassword signature:signData];
    if (!state && signData) {
        NSLog(@"signData = %@",signData);
        NSMutableData * base64 = [NSMutableData data];
        NSMutableData * temp = [NSMutableData dataWithData:signData];
        NSLog(@"temp.bytes = %@",[NSString stringWithUTF8String:temp.bytes]);
        [_infosec encodeData:signData toBase64:base64];
        NSLog(@"base64.bytes =%@",[NSString stringWithUTF8String:base64.bytes]);
        signStr = [NSString stringWithUTF8String:base64.bytes];
    }
    NSLog(@"haoyee_test:signStr:%@",signStr);
    
    NSDictionary *vailJson = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              snStr,        @"sn",
                              dnStr,        @"dn",
                              valueStr,     @"value",
                              bfjgStr,      @"bfjg",
                              signStr,      @"sign",
                              nil];
    NSLog(@"vailJson =%@",vailJson);
    NSDictionary *responDic = nil;
    [self detachSign:vailJson responseDic:&responDic];
    NSLog(@"detachsign responDic note =%@",[responDic objectForKey:@"note"]);
    
    if([[responDic objectForKey:SUCCESS] intValue] == 1){
        [SJKHEngine Instance]->qmlsh = [responDic objectForKey:RecordId];
        _warnStr = @"证书验签成功";
        [self.delegate certHandleResault:_warnStr];
        return yep;
    }
    else{
        _warnStr = @"证书签名失败";
        [self.delegate certHandleResault:_warnStr];
        return nop;
    }
}

- (NSString *)certContentWithType:(eInfosecCertInfoType)type{
    NSMutableString *tempStr = [NSMutableString string];
    [_infosec getSignerCertInfo:&tempStr ofType:type];
    NSMutableArray *temArr = nil;
    NSString *tempstring = [NSString stringWithFormat:@"%@",tempStr];
    temArr = [NSMutableArray arrayWithArray:[tempstring componentsSeparatedByString:@":"]];
    NSMutableString *snNumberLoc = [NSMutableString string];
    for (NSString *str in temArr) {
        [snNumberLoc appendString:str];
    }
    return (type == MY_CERT_SERIALNUMBER ? snNumberLoc : tempstring);
}

- (YEorNO)detachSign:(NSDictionary *)stepResponseDic responseDic:(NSDictionary **)responseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,SZZSQM];
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:URL];
    [theRequest setShouldContinueWhenAppEntersBackground:YES];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    
    for (NSString * key in stepResponseDic) {
        [theRequest setPostValue:[stepResponseDic objectForKey:key] forKey:key];
    }
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:responseDic];
}

- (ASIFormDataRequest *)createASIRequest:(NSString *)urlComponent{
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:[PublicMethod suburlString:URL]];
    [theRequest setShouldContinueWhenAppEntersBackground:YES];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    
    return theRequest;
}

- (YEorNO)parseResponseData:(ASIFormDataRequest *)theRequest dic:(NSDictionary **)stepResponseDic{
    if(theRequest.responseData){
        *stepResponseDic = [NSJSONSerialization JSONObjectWithData:theRequest.responseData options:NSJSONReadingMutableContainers error:Nil];
        NSString * tip = nil;
        
//        NSString *testSTR = [*stepResponseDic objectForKey:NOTE];
        
        if([*stepResponseDic objectForKey:NOTE]){
//            tip = [PublicMethod getNSStringFromCstring:[[*stepResponseDic objectForKey:NOTE] UTF8String]];
        }
        
        if(*stepResponseDic && [[*stepResponseDic objectForKey:SUCCESS] intValue] == 1){
            return yep;
        }
        else{
            
            return nop;
        }
    }
    
    bSureNetWeak = yep;
    return nop;
}

- (void)sendAsychronizeSaveCurrentStep:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,BCDQBZKEY];
    
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                      forKey:[ar firstObject]];
    [theRequest setPostValue:stepName
                      forKey:[ar objectAtIndex:1]];
    [theRequest setDelegate:self];
    [theRequest setDidFailSelector:@selector(httpFailed:)];
    [theRequest setDidFinishSelector:@selector(httpFinished:)];
    
    [theRequest startAsynchronous];
}

- (void) httpFailed:(ASIHTTPRequest *)http{
    NSError * error = nil;
    if (http.responseData && http.responseData.length > 0) {
        responseDictionary = [NSJSONSerialization JSONObjectWithData:http.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"dic fail error= %@,%@,%@",responseDictionary,self,error);
    }
}

- (void) httpFinished:(ASIHTTPRequest *)http{
    NSError * error = nil;
    if (http.responseData && http.responseData.length > 0) {
        responseDictionary = [NSJSONSerialization JSONObjectWithData:http.responseData options:NSJSONReadingMutableContainers error:&error] ;
        //        NSLog(@"error 0=%@",error);
        //        responseDictionary = [NSJSONSerialization JSONObjectWithData:http.responseData options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&error];
        //        NSLog(@"error 1=%@",error);
        if(error){
            responseDictionary = [NSJSONSerialization JSONObjectWithData:http.responseData options:NSJSONReadingAllowFragments error:&error];
        }
        NSLog(@"error 2=%@",error);
        
        if([responseDictionary objectForKey:NOTE]){
            NSString * note = [PublicMethod getNSStringFromCstring:[[responseDictionary objectForKey:NOTE] UTF8String]];
            NSLog(@"dic finished = %@,%@,%@",responseDictionary,self,note);
        }
    }
}

- (YEorNO)toSendSaveStepInfo:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic arrar:(NSMutableDictionary *)jsonDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,BCBZSJXX];
    
    if ([NSJSONSerialization isValidJSONObject:jsonDic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString *jsonString = [[NSString alloc]initWithData:tempJsonData encoding:NSUTF8StringEncoding];
        
        ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
        
        NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
        [theRequest setPostValue:jsonString forKey:[ar firstObject]];
        [theRequest setPostValue:[SJKHEngine Instance]->SJHM forKey:[ar objectAtIndex:1]];
        [theRequest setPostValue:stepName
                          forKey:[ar objectAtIndex:2]];
        
        [theRequest startSynchronous];
        return [self parseResponseData:theRequest dic:stepResponseDic];
    }
    return nop;
}

@end

