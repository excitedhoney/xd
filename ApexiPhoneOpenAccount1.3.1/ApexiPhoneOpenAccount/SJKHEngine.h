//
//  SJKHEngine.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data_Structure.h"
#import "../../NetWork/NetWork/ASIHTTPRequest.h"
#import "../../NetWork/NetWork/ASIFormDataRequest.h"
#import "CustomAlertView.h"
#import "PublicMethod.h"
#import "LoanMainViewCtrl.h"

@protocol DataEngineOberver<NSObject>

//- (void)ResponseJBZLMessage;
- (void)popToLastPage:(UIViewController *)toPopVC;
- (void)popToLastPage;

@end

@class KHRequestOrSearchViewCtrl;

//整个数据的管理类。消息派发、数据增删改查等。
@interface SJKHEngine : NSObject{
@public
    NSStringEncoding stringEncode;                //若服务器要求gbk，则使用这个作全局设定。
    BOOL             isHttps;                     //当前是否是https协议
    NSString *       doMain;                      //ip
    NSString *       port;                        //端口
    SecIdentityRef   identify;                    //https验证通行证
    NSString *       SJHM;                        //手机号码
    NSString *       xwdAccount;                  //小微贷帐户
    BOOL             bReUploadImage;              //是否有重新上传图片
    BOOL             bShowIntroduction;           //出现引导页面
    NSString *       consoleLogPath;
    NSString *       customerName;
    NSMutableArray * logFileNames;                //crashLog文件名集合
    NSMutableDictionary * userConfigDic;          //用户配置信息
    NSString * sImportPassword;                   //证书导入密码
    NSString * sPrePin;                           //在证书文件中已经存入的密码
    NSString * sEnterPassword;                    //证书输入待判断是否正确的密码
    
    NSMutableArray * yxData;                      //图片上传所需数据
    NSMutableDictionary * yxcj_step_Dic;          //影像采集所需数据
    NSMutableDictionary * jbzl_step_Dic;          //基本资料所需dic
    NSMutableDictionary * jbzl_cache_dic;         //存入服务器缓存的数据
//    NSMutableDictionary * jbzl_step_OCR_Dic;      //基本资料所需ocr数据
    NSMutableDictionary * spzj_step_Dic;          //视频见证所需数据
    NSMutableDictionary * zsgl_step_Dic;          //证书管理所需数据
    NSMutableArray * zqzh_step_Dic;          //证券帐户所需数据
    NSMutableDictionary * mmsz_step_Dic;          //密码设置所需数据
    NSMutableDictionary * cgzd_step_Dic;          //存管指定银行所需数据
    NSMutableDictionary * fxpc_step_Dic;          //风险评测所需数据
    NSMutableDictionary * hfwj_step_Dic;          //回访问卷所需数据
//    NSMutableDictionary * ;          //回访问卷所需数据
    NSDictionary *khbd_info_Dic;       // 进入审批后申请的资料
    NSDictionary *khsq_info_Dic;             // 开户过程中的资料（证书安装后续步骤）
    NSDictionary *khjd_Dic;
    
    
    CustomAlertView * _customAlertView;           //提示框(初步定为随开随取，用完释放)
    
    int currentTipZhiYeIndex;                     //点击的职业index
    int currentTipXueLiIndex;                     //点击的学历index
    
    NSMutableArray * jbzl_user_datas;             //如加载基本资料数据失败，则保存用户输入的数据。下次登录可以自动输入。
    NSMutableArray * color_datas;                   //app颜色数据
    int systemVersion;
    
    KHRequestOrSearchViewCtrl * rootVC;
    LoanMainViewCtrl * loanMainVC;
    UIViewController * loginVC;                //临时存放的登录界面
    
    CATransition * rightTransition;
    CATransition * leftTransition;
    CATransition * topTransition;
    BOOL           initNavigationBar;
    UIWindow *     mainWindow;
    
    BFJG_TYPE      bfjg_type;
    NSString *     qmlsh;
    BOOL           bVideoAccess;
    BOOL           bPopAnimate;
    BOOL           bLastCommitSuccess;      //提交开户申请成功
    YEorNO         zhidingstate;            //小于0重新指定
    NSDictionary *zsgl_upload_dic;
    
    YEorNO isKaiHuOVER;
    NSString * uuid;
    
}

@property (atomic,strong) NSMutableArray * observeCtrls;                //监听数组
//@property (atomic,strong) NSMutableDictionary * jbzl_step_OCR_Dic;


+ (SJKHEngine *) Instance;

//- (void) sendRequest:(NSURL *)url isAsynchronize:(BOOL)isAsynchronize type:(int) type;
- (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data;

- (void)setWindowHeaderView:(BOOL)isShow;

//协议责任书
- (void)JBZLCustomAlertViewXYZRS:(BOOL)isShow htmlString:(NSString *)htmlString ;

//职业或学历的数据类型
- (void)JBZLCustomAlertViewSelect:(BOOL)isShow DataType:(SELECT_DATA_TYPE) data_type;

- (void)createCustomAlertView;

- (void)updateAlertViewUI:(BOOL)isFirst;

- (BOOL)dispatchMessage:(MESSAGE_TYPE)message_type;

- (NSString *)getKhzdString;

- (NSMutableArray *)getFilterData:(NSMutableArray *)sourceArray originString:(NSString *)sOriginString;

- (void) deallocLoginVCAndLoanMainVC;

- (void) backToKaiHuLoginVCAndDealloc;

- (void) onClearKaihuData;

- (void)startNotificatioin;

- (void)reachabilityChange:(NSNotification *)note;

@end











