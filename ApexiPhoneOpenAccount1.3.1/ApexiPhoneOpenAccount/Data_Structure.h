//
//  Data_Structure.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

//此类放define、enum、struct等的定义。

#ifndef ApexiPhoneOpenAccount_Data_Structure_h
#define ApexiPhoneOpenAccount_Data_Structure_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define shijiAddress @"https://ryb.csco.com.cn/wskh/mobile/xw"
#define APP_URL @"http://itunes.apple.com/lookup?id=579231151"
#define  alertTitleString @"请设置数字证书密码\n请您妥善保管证书密码,使用该密码进行的任何操作视为本人操作"


#define USERCONFIGDIC @"userConfigDic"
#define BREMEMBERACCOUNT @"BREMEMBERACCOUNT"
#define SSTOREACCOUNT @"SSTOREACCOUNT"
#define SIMPORTPASSWORD @"sImportPassword"

//小微贷登录
#define bczy_tx_XWDLogin @"bczy_tx"


//是否需要上传console.log文件
#define BUploadLog @"BUploadLog"
#define LogFilesArray @"logFiles"
#define SProfilePassword @"SProfilePassword"

#define DEVICEMODEL @"model"
#define DEVICENAME @"name"
#define DEVICEVERSION @"deviceVersion"
#define DEVICEID @"deviceID"
#define DEVICEXH @"deviceXH"
#define APPNAME @"appName"
#define OSVERSION @"osVersion"
#define DOMAIN @"domain"

#define SJHMNUMBER @"SJHM"
#define KHHNUMBER @"KHH"
#define SHOWINTRODUCTIONVIEW @"SHOWINTRODUCTIONVIEW"
#define REPORTCRASHPROPERTY @"REPORTCRASHPROPERTY"

#define topNavigationColor [UIColor blueColor]
#define buttonColor [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0]

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#define FONT [UIFont systemFontOfSize:14]
#define TipFont [UIFont systemFontOfSize:16]
#define FieldFont [UIFont systemFontOfSize:16]
#define FieldFontColor [UIColor blackColor]
#define PublicBoldFont [UIFont boldSystemFontOfSize:15]

#define KeyBoardHeight 216
#define UpHeight 64
#define UpHeightInset UpHeight - 20.0
#define FigureButtonTag 213
#define verticalHeight 15
#define levelSpace  10
#define SeperateLineTag 250
#define MarkBtnTag 192
#define SelectBtnTag 298
#define ButtonHeight 44
#define Padding 3
#define BacKViewTag 921 
#define NormalSpace 5
#define TTTLabelTag 911

#define ButtonColorNormal_Wu [UIColor colorWithRed:33.0/255 green:163.0/255 blue:246.0/255 alpha:1]
#define ButtonColorActive_Wu [UIColor colorWithRed:.0/255 green:140.0/255 blue:229.0/255 alpha:1]
#define ButtonColorDisable_Wu [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]
#define RedColorNormal_Wu [UIColor colorWithRed:220.0/255 green:72.0/255 blue:14.0/255 alpha:1]
#define RedColorActive_Wu [UIColor colorWithRed:191.0/255 green:51.0/255 blue:2.0/255 alpha:1]
#define BGColor_Wu [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1]
#define GrayTipColor_Wu [UIColor colorWithRed:137.0/255 green:137.0/255 blue:137.0/255 alpha:1]
#define ContentBGColor [UIColor colorWithRed:62.0/255 green:75.0/255 blue:247.0/255 alpha:1]
#define FiledHighlightColor [UIColor colorWithRed:255.0/255 green:71.0/255 blue:.96.0/255 alpha:1]
#define FieldNormalColor [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1]
#define LightGrayTipColor [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1]
#define LikeWhiteColor [UIColor colorWithWhite:0.95 alpha:1]

#define autoHeight(rgbValue) (rgbValue/568.0)*screenHeight
#define autoWidth(rgbValue) (rgbValue/320.0)*screenWidth

#define FORIOS5XIB @"IOS5"

//影像数组
#define YXSZ @"yxArr"
//影像数组里的字段值
#define YXLXMC_KEY @"YXLXMC"
#define YXLX_KEY   @"YXLX"
#define FILEPATH_YXCJ @"FILEPATH"

//步骤名称
#define YXCJ_STEP @"yxcj"//影像采集(上传证件照或扫描件)OCR解析生产开户记录信息
#define JBZL_STEP @"jbzl"//基本资料
#define SPJZ_STEP @"spjz"//视频见证
#define ZSGL_STEP @"zsgl"//证书管理
#define KHXY_STEP @"khxy"//开户协议
#define FXPC_STEP @"fxpc"//风险评测
#define MMSZ_STEP @"mmsz"//密码设置
#define CGZD_STEP @"cgzd"//存管指定银行
#define ZQZH_STEP @"zqzh"//证券账户
#define HFWJ_STEP @"hfwj"//回访问卷

#define LOADINGDATA @"正在加载..."

//登录页数据
#define StepData_Login @"stepData"

//开户协议
#define KhxyArr_ZQZH @"KhxyArr"
#define XYBT_ZQZH @"XYBT"
#define XYLX_ZQZH @"XYLX"
#define XYNR_ZQZH @"XYNR"

//获取的response字典字段的define
#define YZM @"yzm"
#define SUCCESS @"success"
#define NOTE @"note"
#define UPNOTE @"NOTE"
#define SZZRSARR @"szzrsArr"
#define ID @"ID"
#define IBM @"IBM"
#define XYNR @"XYNR"     //协议内容
#define XLDM @"xldm"     //学历代码
#define ZYDM @"zydm"     //职业代码
#define RECORDS @"records"  //职业代码、学历代码中的records
#define KhbdInfo @"khbdinfo"

//登录
#define CurrentStep_Login @"currentStep"
#define StepData_Login @"stepData"

//视频见证params
#define SPJZPARAMS_SPJZ @"spjzParams"
#define COWORK_CC_PORT_SPJZ @"COWORK_CC_PORT"
#define COWORK_CC_SERVER_SPJZ @"COWORK_CC_SERVER"
#define COWORK_CC_WORKGROUP_SPJZ @"COWORK_CC_WORKGROUP"
#define COWORK_CC_WSKH_URL_SPJZ @"COWORK_CC_WSKH_URL"
#define FXCKH_WSKH_ZDZH_UID_SPJZ @"FXCKH_WSKH_ZDZH_UID"
#define YYB_SPJZ @"YYB"


//证书安装
#define CertJson_ZSGL @"certJson"
#define LX_ZSGL @"LX"
#define CKH_ZSGL @"CKH"
#define AUTHCODE_ZSGL @"AUTHCODE"
#define SQM_ZSGL @"SQM"
#define PKCS_ZSGL @"PKCS"
#define BFJG_ZSGL @"BFJG"
#define P_ZSGL @"p"
#define ZSSJ_ZSGL @"ZSSJ"
#define STATUS_ZSGL @"STATUS"
#define SN_ZSGL @"SN"
#define DN_ZSGL @"DN"
#define RecordId @"recordid"

//OCR数据字段名
#define CSRQ_OCR @"CSRQ"           //出生日期
#define KHXM_OCR @"KHXM"           //开户姓名
#define MZDM_OCR @"MZDM"           //名族代码
#define MZMC_OCR @"MZMC"           //名族名称
#define XB_OCR @"XB"               //性别
#define XBMC_OCR @"XBMC"           //性别名称
#define YZBM_OCR @"YZBM"           //邮政编码
#define ZJBH_OCR @"ZJBH"           //证件编号
#define ZJDZ_OCR @"ZJDZ"           //证件地址
#define LXDZ_OCR @"LXDZ"           //联系地址
#define ZJFZJG_OCR @"ZJFZJG"       //证件发证机关
#define ZJYXQ_OCR @"ZJYXQ"         //证件有效期
#define ZJLB_OCR @"ZJLB"           //证件类别
#define ZYDM_OCR @"ZYDM"           //职业代码
#define XYSTR_OCR @"XYSTR"
#define GJ_OCR @"GJ"               //国籍
#define XYBH_OCR @"XYBH"           //协议编号
#define QMLSH_OCR @"QMLSH"     

#define KHSP_SPJZ @"KHSP"
#define JZR_SPJZ @"JZR"

//密码设置
#define RMMARR_MMSZ @"rmmArr"
#define ZJMM_MMSZ @"ZJMM"
#define JYMM_MMSZ @"JYMM"
#define SFTB_MMSZ @"SFTB"

//存管银行
#define PX_CGYH @"PX"
#define CGYHARR_CGYH @"cgyhArr"
#define YHMC_CGYH @"YHMC"
#define CGZDFS_CGYH @"CGZDFS"
#define MMSR_CGYH @"MMSR"
#define CGXYSTR_CGYH @"CGXYSTR"     //存管协议str
#define XYBH_CGYH @"XYBH"
#define QMLSH_CGYH @"QMLSH"         //签名流水号
#define HTXY_CGYH @"HTXY"           //合同协议
#define CGYHSTR_CGYH @"CGYHSTR"     //存管银行str
#define YHZH_CGYH @"YHZH"
#define YHMC_CGYH @"YHMC"
#define YHDM_CGYH @"YHDM"
#define ZZHBZ_CGYH @"ZZHBZ"
#define BZ_CGYH @"BZ"
#define YHMM_CGYH @"YHMM"

//风险评测
#define BZRECORDS_FXPC @"bzRecords"         //标准数组
#define TMRECORDS_FXPC @"tmRecords"         //题目数组
#define JSFS_FXPC @"JSFS"                   //计算方式
#define QDESCRIBE_FXPC @"QDESCRIBE"         //题目描述
#define QTYPE_FXPC @"QTYPE"                 //题目类型(0 单选，1 多选)
#define SANSWER_FXPC @"SANSWER"             //各选项表述
#define SCORE_FXPC @"SCORE"                 //分数
#define MRANSWER_FXPC @"MRANSWER"           //默认图片
#define FXPCJSON_FXPC @"fxpcJson"           
#define PFSX_FXPC @"PFSX"
#define PFXX_FXPC @"PFXX"
#define FXCSNLMC_FXPC @"FXCSNLMC"
#define FXCSNL_FXPC @"FXCSNL"
#define WJID_FXPC @"WJID"
#define QID_FXPC @"QID"
#define TZMS_FXPC @"TZMS"
#define TMDAC_FXPC @"TMDAC"
#define FXPC_DIC_FXPC @"fxpc"

//回访问卷
#define HFWJID_HFWJ @"HFWJID"
#define HFTMDAC_HFWJ @"HFTMDAC"
#define HFJG_HFWJ @"HFJG"
#define HFWJKEY_HFWJ @"hfwj"
#define HFWJJSON_HFWJ @"hfwjJson"

//视频见证请求uuid
#define UUID @"uuid"

//上传基本资料的字段
#define ZY_UPLOAD_JBZL @"ZYDM"
#define XL_UPLOAD_JBZL @"XL"
#define DZ_UPLOAD_JBZL @"DZ"

//上传帐户类型
#define SH_ACCOUNT_TYPE @"GDKH_SH"
#define SZ_ACCOUNT_TYPE @"GDKH_SZ"
#define IBY1_ZQZH @"IBY1"
#define SQJJZH_ZQZH @"SQJJZH" // 开放式帐户

//开户绑定
#define KHBDINFO_KHBD @"khbdinfo"
#define GTKHH_KHBD @"GTKHH"
#define ZJZH_KHBD @"ZJZH"
#define CGYH_KHBD @"CGYH"
#define GDKH_SZ_KHBD @"GDKH_SZ"
#define GDKH_SH_KHBD @"GDKH_SH"
// 开放基金帐户
#define GDKH_SJ_KHBD @"GDDJ_SJ"
#define GDKH_HJ_KHBD @"GDDJ_HJ"


//html存储
#define XYZRS_NAME @"XYZRSHtmlString.html"
#define CGYHXY_NAME @"cgyhxy.html"
#define CGZD_FILE_NAME @"cgyhxy"

//各vc数据存储key
#define HFWJ_KEY @"fwj_dic_key"
#define YXCJ_KEY @"yxcj_dic_key"
#define JBZL_KEY @"jbzl_dic_key"
#define SPJZ_KEY @"spjz_dic_key"
#define ZSGL_KEY @"zsgl_dic_key"
#define KHXY_KEY @"khxy_dic_key"
#define MMSZ_KEY @"mmsz_dic_key"
#define CGZD_KEY @"cgzd_dic_key"
#define FXPC_KEY @"fxpc_dic_key"

//开户进度(非step范畴，是自定义的页面)
#define KHZD_KHJD @"khzd"


#define SelectedImageData @"selectedImageData"
#define CropImageData @"cropImageData.jpg"

//获取验证码
#define HQNZM @"/wskh/mobile/login/getSjyzm?sj"
//验证验证码(登陆)
#define NZNZM @"/wskh/mobile/main/loginBysj?sj&yzm"
//图片上传
#define TPSH @"/wskh/mobile/main/upload?sj&file&yxlx&yxlxmc&htxy"
//获取当前步骤页面数据
#define HQDQBUYMSJ @"/wskh/mobile/main/gotoStep?stepname&sj"
//保存当前步骤key(这里的当前步骤指的是将要进入的步骤，让服务器重置用户将要进入的步骤的标志位)
#define BCDQBZKEY @"/wskh/mobile/main/saveCurrentStep?sj&stepname"
//加载用户输入的数据(如获取上传相片后的ocr相片)
#define JZYHSRSJ @"/wskh/mobile/main/getStepInfo?sj&stepname"
//获取ocr识别信息
#define HQOCRSBXX @"/wskh/mobile/main/getOcrInfo?sj"
//获取电子合同协议
#define HQDZHTXY @"/wskh/mobile/query/queryHtxy?id"
//保存步骤数据信息
#define BCBZSJXX @"/wskh/mobile/main/saveStepInfo?formjson&sj&stepname"
//生成视频坐席端访问的客户信息
#define SCSPJZDFWDKHXX @"/wskh/mobile/cowork/getUUID?sj"
//查询存管银行第三方存管协议
#define CXCGYHDSFCGYX @"/wskh/mobile/query/queryCgxy?yhdm"
//开户确认提交
#define KHQRTJ @"/wskh/mobile/main/lastCommit?khzd&sj"
//查询开户信息
#define CXKHXX @"/wskh/mobile/query/queryKhxx?sj"
//查询证书接口
#define XQZSJK @"/wskh/mobile/cert/queryCert"
//下载证书接口
#define XZZSJK @"/wskh/mobile/cert/downLoadCert"
//数字证书更新
#define SZZSGX @"/wskh/mobile/cert/updateCert"
//数字证书签名
#define SZZSQM @"/wskh/mobile/cert/detachedSign"
// 数字证书申请
#define SZZSSQ @"/wskh/mobile/cert/certRequest?sj&bfjg"
// 全局更新证书
#define RELOADCERT @"/wskh/mobile/cert/reloadCert"
// 全局查询证书状态
#define CHECKDN @"/wskh/mobile/cert/checkDn"
// 开户状态查询
#define KHZTCX @"/wskh/mobile/query/queryKhztxx?"
// 重新指定银行帐号
#define RECGYH @"/wskh/mobile/main/renewCgyhzd"
// 重新指定股东号
#define REPOINTCOUNT @"/wskh/mobile/main/renewShagzh"
// 开户身份验证
#define KHSFNZ @"/wskh/mobile/query/sfxxhc?zjlb&zjbh"
// 版本检测
#define IOSBBJC @"/wskh/mobile/checkIOS?Version&Build"
// 图像文件下载
#define YXCJTPXZ @"/wskh/mobile/main/download?filepath"
// 崩溃日记上传
#define BKRJSC @"/wskh/mobile/log/upload?file"

typedef enum
{
   ServerCloseError = 1,            //服务器全关闭
   
} ErrorCode;

typedef enum
{
    URLImageViewOptionTransitionCubeFromTop = 0,
    URLImageViewOptionTransitionCubeFromBottom = 1,
    URLImageViewOptionTransitionCubeFromLeft = 2,
    URLImageViewOptionTransitionCubeFromRight = 3,
    URLImageViewOptionTransitionRipple = 4
} URLImageEffect;

typedef enum
{
    ZHIYE_DATA_TYPE                     = 22,
    XUELI_DATA_TYPE                     = 23,
    ZJYXQ_DATA_TYPE                     = 24
} SELECT_DATA_TYPE;

typedef enum
{
    ZHONGDENG_CERT                     = 1,
    TIANWEI_CERT                       = 2
} BFJG_TYPE;

typedef enum
{
    POP_MESSAGE                     = 809,                   //派发消息类型
    GET_OCR_FAIL_POP_MESSAGE        = 810,                   //获取ocr数据失败,而返回得新上传图片进行识别
    RELEASE_PRE_VIEWCTRL            = 811,                   //回收之前的页面
    XWD_POP_MESSAGE                 = 812,                   //回收小微贷页面.为注销而设
    XWD_JUSTPOP_MESSAGE             = 813,                   //只pop页面。而不回收对象，且回到首页;为小微贷而设
    NETWORK_DISCONNECT              = 814,                   //网络断开
    NETWORK_COMSUME                 = 815                    //网络恢复正常
} MESSAGE_TYPE;

typedef enum
{
    ZJZD_FS_CGYH                     = 1,                   //直接指定
    YZD_FS_CGYH                      = 2                    //预指定
} CGZDFS_TYPE;

typedef enum
{
    DOCUMENT_CACHE                     = 0,
    CACHESDIRECTORY                    = 1
} CACHE_PATH_TYPE;

typedef enum{
    NETTYPE_YIDONG    = 1,//移动
    NETTYPE_LIANTONG  = 2,//联通
    NETTYPE_DIANXIN   = 3//电信
} NETTYPE;

typedef enum {
    HQNZM_REQUEST                      = 0,                 //获取验证码
    NZNZM_REQUEST                      = 1,                 //验证验证码
    TPSC_REQUEST                       = 2,                 //图片上传
    BCDQBZKEY_REQUEST                  = 3,                 //保存当前步骤key（有时这个request代表一连串请求的第一个请求）
    HQDQBZYMSJ_REQUEST                 = 4,                 //获取当前步骤页面数据
    JZYHSRSJ_REQUEST                   = 5,                 //加载用户输入的数据
    HQOCRSBXX_REQUEST                  = 6,                 //获取ocr识别信息
    HQDZHTXY_REQUEST                   = 7,                 //获取电子合同协议
    KHQRTJ_REQUEST                     = 8,                 //开户确认提交
    CXKHXX_REQUEST                     = 9                  //查询开户信息
} REQUEST_TYPE;

typedef enum{
    CODE_SHOW_ME_POINT = 0,     //显示我菜单的红点
    CODE_HIDDEN_ME_POINT = 1,   //隐藏我菜单的红点
    CODE_SHOW_JK_POINT = 2,     //显示借款菜单的红点
    CODE_HIDDEN_POINT_POINT = 3 ,//隐藏借款菜单的红点
    CODE_MSKH = 4 ,             //马上开户
    CODE_MSJQ_UPDATE_MENU = 5,  //点击马上借钱的时候切换菜单
    CODE_SHARE = 6,             //分享
    CODE_CALL_PHONE = 7 ,       //打电话
    CODE_SYB_SKIP = 9,             //申易宝跳转
    CODE_CALL_RETURN_VERSION = 10  //返回版本
} JS_WEBVIEW_BRIDGE_MESSAGE_TYPE;

enum SEND_REQUEST_TYPE
{
    GetData                     = 0,            //简单的获取数据，且返回值为json。
    GetFileData                 = 1,            //以流的形式返回数据
    UploadDicDataWithPost       = 2,            //用post上传Dictionary数据。
    UploadDataWithPost          = 3             //上传图片流数据，非dic类型。
};


#endif
