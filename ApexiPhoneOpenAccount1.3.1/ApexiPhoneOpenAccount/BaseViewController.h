//
//  BaseViewController.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PublicMethod.h"
#import "MBProgressHUD.h"
#import "CustomAlertView.h"
#import "Data_Structure.h"
#import "UIImage+custom_.h"
#import "UIKit+Tools.h"
//#import "TestScrollview.h"

@interface BaseViewController : UIViewController<DataEngineOberver,UITextFieldDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>{
    float delayTime;
    NSMutableDictionary * responseDictionary;
    IBOutlet UIScrollView * scrollView;
    UIButton * nextStepBtn;
    BOOL bKeyBoardShow;
    BOOL bSaveStepFinish;
    BOOL bSaveStepSuccess;
    BOOL bFirstShow;            //第一次出现
    
    UIView * rootView;
    int keyboardOffset;
//    float hudDelayTime;
    UITapGestureRecognizer *singleTapRecognizer;

    UIImageView *flowView;

    @public
    MBProgressHUD * hud ;
    BOOL  bReEnter;             //是否是重新进入到该界面
}

- (void) InitConfig;
- (void) InitWidgets;
- (void) InitScrollView;
//下一步按钮响应事件
- (void) onButtonClick:(UIButton *)btn;
- (void) reposControl;
- (void) beginEdit:(BOOL)isStart textFieldArrar:(NSMutableArray *)fields;
- (void) addGesture:(UIView *)view;
- (void) InitNextStepButton:(CGRect) rect tag:(int)tag title:(NSString *)title;
- (void) resignAllResponse;


- (void) ServerAuthenticate:(REQUEST_TYPE)request_type;
- (BOOL) sendCGYHXYID:(NSString *)yhdm dataDictionary:(NSDictionary **)stepResponseDic;
- (BOOL) sendSaveCurrentStepKey:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic;
- (BOOL) sendGoToStep:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic;
- (BOOL) sendGetStepInfo:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic;
- (BOOL) sendOCRInfo:(NSDictionary **)stepResponseDic;
- (BOOL) sendCheckVersion:(NSDictionary **)stepResponseDic; //ios版本检测
- (BOOL) sendTaskBook:(NSDictionary **)stepResponseDic;     //获得责任书
- (BOOL) sendSaveStepInfo:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic arrar:(NSMutableDictionary *)jsonDic;                         //saveStepInfo保存步骤数据
- (void) sendAsychronizeSaveCurrentStep:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic;
- (BOOL) sendGetUUID:(NSDictionary **)stepResponseDic;
- (void) toSendLastCommit:(NSString *)khzd dataDictionary:(NSDictionary **)stepResponseDic;
- (void) toSendQueryKHXX;
- (BOOL) toSendKHSFNZ:(NSDictionary **)stepResponseDic sourceArray:(NSArray *)sourceArr;
- (NSData *) toSendYXCJTPXZ:(NSDictionary **)stepResponseDic sourceArray:(NSArray *)sourceArr;

- (void)activityIndicateTextMode:(BOOL)isBegin tipContent:(NSString *)content target:(UIView *)target;
- (void)activityIndicate:(BOOL)isBegin tipContent:(NSString *)content MBProgressHUD:(MBProgressHUD *)hudd target:(UIView *)target;

- (void) dismissHUD;
- (void) updateUI ;

- (UIButton *)createSelectImageButton:(int)i withFrame:(CGRect)frame;
- (UIButton *)createSelectTitleButton:(int)i withFrame:(CGRect)frame title:(NSString *)title;

- (void)customPushAnimation:(UIView *)target withFrame:(CGRect)frame controller:(UIViewController *)vc;

- (void)httpFailed:(ASIHTTPRequest *)http;
- (void)httpFinished:(ASIHTTPRequest *)http;

- (void)saveSuccessContinueOpetion:(BOOL)bSaveSuccess;

- (void)chageNextStepButtonStype:(BOOL)isOK;

- (ASIFormDataRequest *)createASIRequest:(NSString *)urlComponent;
- (BOOL)parseResponseData:(ASIFormDataRequest *)theRequest dic:(NSDictionary **)stepResponseDic;

- (YEorNO)parseResponseData:(ASIFormDataRequest *)theRequest dict:(NSDictionary *)stepResponseDic;

- (float)getHeightForHeaderString:(NSString *)text size:(CGSize)size;

- (void)backOperation;

- (void)OnTouchDownResign:(UIControl *)control;

- (void)changeFieldBorderColor:(BOOL)isChange targetView:(UIView *)vi bJustChangeLayer:(BOOL)bJustChangeLayer;

//非小微贷界面的pop响应方法
- (void)popToLastPage;

- (void)xwdPopMessage;

- (BOOL)sendUploadConsoleLog:(NSDictionary **)stepResponseDic path:(NSString *)path;

- (void)onCancelCurrentOperation:(UIButton *)cancelButton;

- (BOOL)onJudgePreVCExist:(Class )preClass currentVC:(BaseViewController *)currentVC;

- (void)fieldTextChanged:(NSNotification *)noti;

@end








