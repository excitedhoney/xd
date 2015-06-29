//
//  InstallProfileViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-11.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "InstallProfileViewCtrl.h"
#import "AccountTypeViewCtrl.h"
#import "func_def.h"
#import "ReturnVisitViewCtrl.h"

#define INSTALLPROFILETEXT @"安装数字证书"
#define NEXTSTEPTEXT @"下一步"

@interface InstallProfileViewCtrl (){
    UIButton * encourageBtn;
    UIButton * installProfileBtn;
    BOOL bQueryOK;
    BOOL bQueryFinish;
    BOOL bInstallOK;            // 安装成功
    CGRect installRect;
    BOOL bInstallCycle;         //安装证书的执行单元模块
    BOOL bInstallLock;
    UITextField * dialogTextfield;
    UITextField * sureTextfield;
}

@end

#ifdef HAOYTEST
#else
#endif

@implementation InstallProfileViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self InitConfig];
    [self InitWidgets];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //会在这里释放之前的内存
//    [[SJKHEngine Instance] dispatchMessage:RELEASE_PRE_VIEWCTRL];
}

- (void)InitConfig{
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    self.view.bounds = CGRectMake(0, 0, screenWidth, self.view.bounds.size.height);
    [self.navigationItem setHidesBackButton:YES];
    bQueryOK = NO;
    bQueryFinish = NO;
    bInstallOK = NO;
    bInstallCycle = NO;
    bInstallLock = NO;
}

- (void)fieldTextChanged:(NSNotification *)noti{
    UITextField * textField = noti.object;
    NSString * fieldText = textField.text;
    
    if(!textField.markedTextRange){
        if(fieldText.length> 6 ){
            [textField setText:[fieldText substringToIndex:6]];
        }
    }
}

- (void)InitWidgets{
    [self InitScrollView];
    scrollView.delegate=self;
    [scrollView setContentSize:CGSizeMake(screenWidth, screenHeight - UpHeight)];
    
    int labelHeight = 50;
    CGSize encourageButtonSize = CGSizeMake(130, 130);
    CGSize installButtonSize = CGSizeMake(150, 44);
    
    UIButton * headerFlowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerFlowButton setFrame:CGRectMake(0, 0 , screenWidth, ButtonHeight)];
    [headerFlowButton setImage:[[UIImage imageNamed:@"flow_1"] imageByResizingToSize:CGSizeMake(screenWidth, headerFlowButton.frame.size.height)]
                      forState:UIControlStateNormal];
    [headerFlowButton setUserInteractionEnabled:NO];
    [scrollView addSubview: headerFlowButton];
    
    UILabel *la=[[UILabel alloc]initWithFrame: CGRectMake(levelSpace, ButtonHeight *2, screenWidth - 2*levelSpace, labelHeight)];
	la.backgroundColor = [UIColor clearColor];
    [la setText:@"请点击安装数字证书"];
	[la setFont: [UIFont boldSystemFontOfSize:18]];
    la.numberOfLines = 0;
    la.textAlignment = NSTextAlignmentCenter;
	[la setTextColor: [UIColor blackColor]];
    la.lineBreakMode = NSLineBreakByTruncatingTail;
    [scrollView addSubview:la];
    [self addGesture:scrollView];
    singleTapRecognizer.delegate = self;
    
    encourageBtn = [[UIButton alloc]initWithFrame:CGRectMake (screenWidth/2 - encourageButtonSize.width/2,
                                                              ButtonHeight *2 + labelHeight ,
                                                              encourageButtonSize.width,
                                                              encourageButtonSize.height)];
    [encourageBtn setImage:[UIImage imageNamed:@"icon_szzs"] forState:UIControlStateNormal];
//    [encourageBtn setUserInteractionEnabled:NO];
//    [encourageBtn addTarget:self action:@selector(onInstallButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:encourageBtn];
    
    installProfileBtn = [[UIButton alloc]initWithFrame:CGRectMake (screenWidth/2 - installButtonSize.width/2,
                                                              encourageBtn.frame.origin.y + encourageBtn.frame.size.height + 7,
                                                              installButtonSize.width,
                                                              installButtonSize.height)];
    installRect = installProfileBtn.frame;
    
//    [installProfileBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:1] size:installProfileBtn.frame.size] forState:UIControlStateNormal];
//    [installProfileBtn setBackgroundImage:[UIImage imageWithColor:LightGrayTipColor size:installProfileBtn.frame.size] forState:UIControlStateHighlighted];
    
    UIImage * kaihuImage = [UIImage imageNamed: [NSString stringWithFormat:@"button_gray_default"]];
    kaihuImage = [kaihuImage stretchableImageWithLeftCapWidth: 9 topCapHeight: 9];
    [installProfileBtn setBackgroundImage:kaihuImage forState:UIControlStateNormal];
    
    [installProfileBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [installProfileBtn setTitle:INSTALLPROFILETEXT forState:UIControlStateNormal];
//    [installProfileBtn addTarget:self action:@selector(onInstallButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:installProfileBtn];
    
    [self InitNextStepButton:CGRectMake(levelSpace,
                                        installProfileBtn.frame.origin.y + installButtonSize.height + verticalHeight,
                                        screenWidth - 2 * levelSpace ,
                                        44)
                         tag:0
                       title:@"下一步"];
    [nextStepBtn setHidden:YES];
    [self chageNextStepButtonStype:NO];
    [scrollView addSubview:nextStepBtn];
    
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(screenWidth, nextStepBtn.frame.origin.y + 44 + 2 * verticalHeight)];
    [super InitWidgets];
}

- (void)showInstallSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * title = @"安装成功";
        if([SJKHEngine Instance]->bVideoAccess){
            title = @"安装真实证书成功";
        }
        
        [self activityIndicate:NO tipContent:title MBProgressHUD:nil target:self.navigationController.view];
        bInstallOK = YES;
        [self chageNextStepButtonStype:YES];
    });
}

- (void)onInstallButton:(UIButton *)btn{
//    ReturnVisitViewCtrl * returnVC = [[ReturnVisitViewCtrl alloc] init];
//    [self.navigationController pushViewController:returnVC animated:YES];
//    return;
    
//    if(bInstallLock){
//        return ;
//    }
//    else{
//        bInstallLock = YES;
//    }
    
    if ([installProfileBtn.titleLabel.text isEqualToString:INSTALLPROFILETEXT]) {
        [self activityIndicate:YES tipContent:@"安装证书..." MBProgressHUD:nil target:self.navigationController.view];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CertHandle *certClass = [CertHandle defaultCertHandle];
            certClass.delegate = self;
            YEorNO resault = nop;
            resault = [certClass certToHandle];
            
            if(resault){
                [self toSaveStepDataAndPushAccountTypePage:resault];
            }
            
            //因中登服务器不通,暂时这么做 待调试
//            AccountTypeViewCtrl * accountVC = [[AccountTypeViewCtrl alloc]initWithNibName:@"AccountTypeView" bundle:nil];
//            [self activityIndicate:YES tipContent:@"加载帐户信息..." MBProgressHUD:nil target:self.navigationController.view];
//            [self dispatchAccountTypeVC:accountVC];
        });
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self toSaveStepDataAndPushAccountTypePage:YES];
        });
    }
}

- (void)toSaveStepDataAndPushAccountTypePage:(BOOL)resault{
    if (resault) {
        if ([[CertHandle defaultCertHandle] toSaveProfileStepData]) {
            AccountTypeViewCtrl * accountVC = [[AccountTypeViewCtrl alloc]initWithNibName:@"AccountTypeView" bundle:nil];
            [self activityIndicate:YES tipContent:@"加载帐户信息..." MBProgressHUD:nil target:self.navigationController.view];
            [self dispatchAccountTypeVC:accountVC];
        }
        else{
            [self activityIndicate:NO tipContent:@"保存证书数据失败" MBProgressHUD:nil target:self.navigationController.view];
            
            if ([installProfileBtn.titleLabel.text isEqualToString:INSTALLPROFILETEXT]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [installProfileBtn setTitle:NEXTSTEPTEXT forState:UIControlStateNormal];
                    [CATransaction begin];
                    [CATransaction setAnimationDuration:0.2];
                    installProfileBtn.frame = CGRectMake(10,
                                                         installRect.origin.y,
                                                         screenWidth - 2*10,
                                                         installRect.size.height);
                    [CATransaction commit];
                });
            }
        }
    }
}

- (void)saveSuccessContinueOpetion:(BOOL)bSaveSuccess{
    bSaveStepFinish = YES;
    bSaveStepSuccess = bSaveSuccess;
}

- (void)updateUI{
    [super updateUI];
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)onButtonClick:(UIButton *)btn{
    if(!bInstallOK){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先安装数字证书" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    [self activityIndicate:YES tipContent:@"加载帐户信息..." MBProgressHUD:nil target:self.navigationController.view];
    
    AccountTypeViewCtrl * accountVC = [[AccountTypeViewCtrl alloc]init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dispatchAccountTypeVC:accountVC];
    });
}

- (void) dispatchAccountTypeVC:(AccountTypeViewCtrl *)accountVC{
    NSDictionary * stepDictionary = nil;
    if([self sendSaveCurrentStepKey:ZQZH_STEP dataDictionary:&stepDictionary]){
        BOOL ok = [self sendGoToStep:ZQZH_STEP dataDictionary:&stepDictionary];
        if(ok){
            [SJKHEngine Instance]->zqzh_step_Dic = [[stepDictionary objectForKey:KhxyArr_ZQZH] mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([SJKHEngine Instance]->zqzh_step_Dic &&
                    [SJKHEngine Instance]->zqzh_step_Dic.count > 0)
                {
                    [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                    [self.navigationController pushViewController:accountVC animated:YES];
                    [accountVC updateUI];
                }
                else{
                    [self activityIndicate:NO tipContent:@"加载帐户信息失败" MBProgressHUD:nil target:self.navigationController.view];
                }
            });
        }
        else {
            [self activityIndicate:NO tipContent:@"加载帐户信息失败" MBProgressHUD:nil target:self.navigationController.view];
//            [[SJKHEngine Instance] dispatchMessage:POP_MESSAGE];
        }
    }
}

- (void)popToLastPage{
//    dispatch_async(dispatch_get_main_queue(), ^{
////        [self activityIndicate:YES tipContent:@"加载失败" MBProgressHUD:nil];
//        hud.mode = MBProgressHUDModeText;
//        sleep(1);
//        [hud hide:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//    });
    
    [super popToLastPage];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(touch.view == installProfileBtn)
    {
//        [self onInstallButton:nil];
        
        [self onShowAlert:alertTitleString];
//        [dialog setMessage:@"请您妥善保管证书密码,使用该密码进行的任何操作视为本人操作"];
    }
//    else{
//        return YES;
//    }
    
    return NO;
}

- (void)onShowAlert:(NSString *)tipMessage{
    UIAlertView* dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setTitle:tipMessage];
    if([tipMessage isEqualToString:alertTitleString]){
        if([SJKHEngine Instance]->systemVersion >= 7){
            [dialog setTitle:@"请设置数字证书密码"];
            [dialog setMessage:@"请您妥善保管证书密码,使用该密码进行的任何操作视为本人操作"];
        }
    }
//    [dialog setMessage:tipMessage];
    [dialog addButtonWithTitle:@"确定"];
    dialog.tag = 5;
    
    [dialog setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    dialogTextfield = [dialog textFieldAtIndex:0];
    dialogTextfield.layer.cornerRadius = 3;
    dialogTextfield.layer.masksToBounds = YES;
    [dialogTextfield setPlaceholder:@"密码"];
    dialogTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [dialogTextfield setSecureTextEntry:YES];
    
    sureTextfield = [dialog textFieldAtIndex:1];
    sureTextfield.layer.cornerRadius = 3;
    sureTextfield.layer.masksToBounds = YES;
    [sureTextfield setSecureTextEntry:YES];
    sureTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [sureTextfield setPlaceholder:@"确定密码"];
    
    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
    [dialog setTransform: moveUp];
    [dialog show];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString * fieldText = [NSString stringWithFormat:@"%@%@", textField.text , string];
    
//    if(fieldText.length > 6){
//        return NO;
//    }
    return  YES;
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    NSLog(@"weizhi = %@",alertView.subviews);
    if(alertView.tag == 5){
        if([SJKHEngine Instance]->systemVersion < 7){
            if(![alertView.title isEqualToString:alertTitleString]){
                return ;
            }
            alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y -15
                                         ,alertView.frame.size.width, alertView.frame.size.height + 30);
            CGSize size = alertView.frame.size;
            for (UIView * view in alertView.subviews) {
                if(([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UIImageView class]]) && !CGSizeEqualToSize(view.frame.size, size))
                {
                    view.frame = CGRectMake(view.frame.origin.x,
                                            view.frame.origin.y + 25,
                                            view.frame.size.width,
                                            view.frame.size.height);
                }
                if(view.frame.size.height == 1){
                    view.frame = CGRectMake(view.frame.origin.x,
                                            view.frame.origin.y + 25,
                                            view.frame.size.width,
                                            view.frame.size.height);
                }
                if([view isKindOfClass:[UILabel class]]){
                    [view setHidden:YES];
                    
                    TTTAttributedLabel *la=[[TTTAttributedLabel alloc]initWithFrame: view.frame];
                    la.font = [UIFont boldSystemFontOfSize:19];
                    la.textColor = [UIColor whiteColor];
                    la.lineBreakMode = NSLineBreakByWordWrapping;
                    la.numberOfLines = 0;
                    la.backgroundColor = [UIColor clearColor];
                    la.highlightedTextColor = [UIColor whiteColor];
                    la.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
                    la.textAlignment = UITextAlignmentCenter;
                    
                    [la setText:alertTitleString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
                     {
                         UIFont *systemFont = [UIFont systemFontOfSize:16];
                         CTFontRef fontRef = CTFontCreateWithName((CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
                         [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:[[mutableAttributedString string] rangeOfString:@"请您妥善保管证书密码,使用该密码进行的任何操作视为本人操作"]];
                         CFRelease(fontRef);
                         
                         return mutableAttributedString;
                     }];
                    
                    [alertView addSubview:la];
                }
            }
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 5){
        UITextField * textField = [alertView textFieldAtIndex:0];
        NSString * sTextField = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(sTextField.length != 6){
            [self onShowAlert:@"密码长度需要是6位,请重新输入"];
        }
        else if(![[dialogTextfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[sureTextfield.text stringByReplacingOccurrencesOfString:@" " withString:@""]])
        {
            [self onShowAlert:@"密码输入不一致,请重新输入"];
        }
        else{
            [SJKHEngine Instance]->sImportPassword = [sTextField mutableCopy];
            [PublicMethod saveToUserDefaults:sTextField key:SIMPORTPASSWORD];
            [self performSelector:@selector(onInstallButton:) withObject:nil afterDelay:0.3];
        }
    }
    else{
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [encourageBtn removeFromSuperview];
    encourageBtn = nil;
    [installProfileBtn removeFromSuperview];
    installProfileBtn = nil;
    
    NSLog(@"证书安装回收");
}

- (void)certHandleResault:(NSString *)resaultString{
    [self activityIndicate:NO tipContent:resaultString MBProgressHUD:nil target:self.navigationController.view];
}

@end







