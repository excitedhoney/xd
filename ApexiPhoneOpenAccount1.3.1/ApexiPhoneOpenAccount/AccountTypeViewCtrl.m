//
//  AccountTypeViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-11.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "AccountTypeViewCtrl.h"
#import "SecretSetViewCtrl.h"
#import "CertHandle.h"

#define SelectTag 817

#define PROTOCOLBUTTONTAG 1101

@interface AccountTypeViewCtrl (){
    NSArray * selectNames;
    UIButton * readZRS ;
    UIImage * imageDefault;         //默认图片
    UIImage * imageHighLight;       //高亮图片
    UIImage * imageSelect;          //选择图片
    BOOL isVailSuccess;
    BOOL isVailFinish;
    BOOL bShowJiJinXYS;
}

@end

@implementation AccountTypeViewCtrl
@synthesize infosec = _infosec;

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

- (void)InitConfig{
    /*
     NSMutableArray *stepDic= [NSMutableArray arrayWithCapacity:0];
     stepDic = [SJKHEngine Instance]->zqzh_step_Dic;
     if (stepDic && stepDic.count) {
     
     }
     */
    
//    NSMutableArray *stepDic= [NSMutableArray arrayWithCapacity:0];
//    stepDic = [SJKHEngine Instance]->zqzh_step_Dic;
    
    isVailSuccess = NO;
    isVailFinish= NO;
    bShowJiJinXYS = NO;
    
#ifdef SelectTest
//    if (stepDic && stepDic.count) {
//        NSLog(@"accounttype data = %@",stepDic);
//    }
#endif
    
    [self.view setBackgroundColor:PAGE_BG_COLOR];
//    self.view.bounds = CGRectMake(0, 0, screenWidth, self.view.bounds.size.height);
//    UIButton * backButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:FigureButtonTag + 1];
//    [backButton setImage:[UIImage imageNamed:@"step_2"] forState:UIControlStateNormal];
    
    imageDefault = [UIImage imageNamed:@"checkbox_default"];
    imageHighLight = [UIImage imageNamed:@"checkbox_hot"];
    imageSelect = [UIImage imageNamed:@"checkbox_checked"];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setBackBarButtonItem:nil];
}

- (void)fieldTextChanged:(NSNotification *)noti{
    UITextField * textField = noti.object;
    NSString * fieldText = textField.text;
    
    if(!textField.markedTextRange){
        if(fieldText.length > 6){
            [textField setText:[fieldText substringToIndex:6]];
        }
    }
}

- (void)viewDidLayoutSubviews{
//    scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight - UpHeight);
//    [scrollView setContentInset:UIEdgeInsetsMake(40, 0, 0, 0)];
    [scrollView setContentSize:CGSizeMake(screenWidth, nextStepBtn.frame.origin.y + ButtonHeight + 2 * verticalHeight)];
//    [scrollView scrollRectToVisible:CGRectMake(0, 0, screenWidth, 10) animated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{    
    [super viewDidDisappear:animated];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"event =%@",event);
}

- (void)InitWidgets{
    [scrollView setBackgroundColor:PAGE_BG_COLOR];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    headerFlowButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headerFlowButton setBackgroundImage:[UIImage imageNamed:@"flow_2.png"]
                                forState:UIControlStateNormal];
    
    [centerView setBackgroundColor:[UIColor whiteColor]];
    [PublicMethod publicCornerBorderStyle:centerView];
    centerView.userInteractionEnabled = YES;
    
    tipLabel.font = [UIFont boldSystemFontOfSize:18];
    
    //设置勾选框
//    shAgImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [hkfsjjImage setImage:imageDefault forState:UIControlStateNormal];
    [skfsjjImage setImage:imageDefault forState:UIControlStateNormal];
    
    [shAgImage setImage:imageHighLight forState:UIControlStateHighlighted];
    [szAgImage setImage:imageHighLight forState:UIControlStateHighlighted];
    [hkfsjjImage setImage:imageHighLight forState:UIControlStateHighlighted];
    [skfsjjImage setImage:imageHighLight forState:UIControlStateHighlighted];
    
    [shAgImage setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [szAgImage setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [hkfsjjImage setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [skfsjjImage setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [readAndUnderstandImage setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [shAgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shAgButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [szAgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    szAgButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [shAgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shAgButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [hkfsjjButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    hkfsjjButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [skfsjjButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    skfsjjButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    hkfsjjButton.titleLabel.numberOfLines = 0;
    hkfsjjButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    skfsjjButton.titleLabel.numberOfLines = 0;
    skfsjjButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [readAndUnderstandButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    readAndUnderstandButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [readAndUnderstandImage setImage:imageDefault forState:UIControlStateNormal];
    
    [self onItemTouch:shAgImage];
    [self onItemTouch:szAgImage];
    [self onItemTouch:skfsjjImage];
    [self onItemTouch:hkfsjjImage];
    
    protocolView = [[UIView alloc]initWithFrame:CGRectMake(levelSpace,
                                                           readAndUnderstandButton.frame.origin.y + readAndUnderstandButton.frame.size.height,
                                                           screenWidth - 2*levelSpace,
                                                           ButtonHeight)];
    
    
//    [protocolView setAutoresizingMask:UIViewAutoresizingNone];
//    [nextStepButton setAutoresizingMask:UIViewAutoresizingNone];
    
    int i = [self initXYButton:YES];
    
    protocolView.frame = CGRectMake(levelSpace,
                                    readAndUnderstandButton.frame.origin.y + readAndUnderstandButton.frame.size.height,
                                    screenWidth - 2*levelSpace,
                                    ButtonHeight * i);
    [PublicMethod publicCornerBorderStyle:protocolView];
    [protocolView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:protocolView];
    
    if(i == 0){
        [readAndUnderstandImage setHidden:YES];
        [readAndUnderstandButton setHidden:YES];
    }
    
    [self InitNextStepButton:CGRectMake(levelSpace,
                                                  protocolView.frame.origin.y + protocolView.frame.size.height + 20,
                                                  screenWidth - 2*levelSpace,
                                                  ButtonHeight)
                         tag:0
                       title:@"下一步"];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrollView addSubview:nextStepBtn];
    
    [scrollView setContentSize:CGSizeMake(screenWidth, nextStepBtn.frame.origin.y + ButtonHeight + 2 * verticalHeight)];
    
    [super InitWidgets];
}

- (int)initXYButton:(BOOL)bShowJiJinXY{
    bShowJiJinXYS = bShowJiJinXY;
    for (UIView * vi in protocolView.subviews) {
        [vi removeFromSuperview];
    }
    
    int i = 0;
    UIButton * protocolButton = nil;
    for(NSDictionary * xyDic in [SJKHEngine Instance]->zqzh_step_Dic){
        NSLog(@"[xyDic objectForKey:XYBT_ZQZH] =%@,%@",[xyDic objectForKey:XYLX_ZQZH],[xyDic objectForKey:XYBT_ZQZH]);
        
        if([[xyDic objectForKey:XYLX_ZQZH] intValue] == 7 && !bShowJiJinXY){
            continue ;
        }
        
        protocolButton = [[UIButton alloc]initWithFrame:CGRectMake(4,
                                                                   0 + i * ButtonHeight,
                                                                   protocolView.frame.size.width - 2*4,
                                                                   ButtonHeight)];
        protocolButton.tag = i++ + PROTOCOLBUTTONTAG;
        [protocolButton addTarget:self action:@selector(onItemTouch:) forControlEvents:UIControlEventTouchUpInside];
        [protocolButton setTitle: [xyDic objectForKey:XYBT_ZQZH] forState:UIControlStateNormal];
//        protocolButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:16];
//        protocolButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        protocolButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        protocolButton.titleLabel.font = [UIFont italicSystemFontOfSize:16.0f];
//        [protocolButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        [protocolButton setTitleColor:[UIColor colorWithRed:0 green:123.0/255 blue:218.0/255 alpha:1.0] forState:UIControlStateNormal];
        [protocolButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [protocolButton setImage:[[UIImage imageNamed:@"linkimage"] imageByResizingToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
//        [protocolButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        [protocolButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
        
        [protocolView addSubview:protocolButton];
    }
    
    return i;
}

- (IBAction)onItemTouch:(id)sender{
    UIButton * btn  = (UIButton *)sender;
    if(btn == shAgImage){
        [self changeItemImageIcon:shAgImage];
    }
    else if(btn == shAgButton){
        [self changeItemImageIcon:shAgImage];
    }
    else if(btn == szAgImage){
        [self changeItemImageIcon:szAgImage];
    }
    else if(btn == szAgButton){
        [self changeItemImageIcon:szAgImage];
    }
    else if(btn == hkfsjjImage){
        [self changeItemImageIcon:hkfsjjImage];
    }
    else if(btn == hkfsjjButton){
        [self changeItemImageIcon:hkfsjjImage];
    }
    else if(btn == skfsjjImage){
        [self changeItemImageIcon:skfsjjImage];
    }
    else if(btn == skfsjjButton){
        [self changeItemImageIcon:skfsjjImage];
    }
    else if(btn == readAndUnderstandImage){
        [self changeItemImageIcon:readAndUnderstandImage];
    }
    else if(btn == readAndUnderstandButton){
//        [self changeItemImageIcon:readAndUnderstandImage];
    }
    else{
        int index = btn.tag - PROTOCOLBUTTONTAG;
        NSString * contentText = [[[SJKHEngine Instance]->zqzh_step_Dic objectAtIndex:index] objectForKey:XYNR_ZQZH];
        if(contentText && contentText.length > 0){
            [[SJKHEngine Instance] createCustomAlertView];
            [[SJKHEngine Instance]->_customAlertView toSetTitleLabel:btn.titleLabel.text];
            [self showCustomAlertViewContent:YES htmlString:contentText];
        }
        else{
            [self activityIndicate:NO tipContent:@"没有协议文本" MBProgressHUD:nil target:self.navigationController.view];
        }
    }
}

- (void) changeItemImageIcon:(UIButton *)vi{
    if(vi.selected){
        vi.selected = NO;
        [vi setImage:imageDefault  forState:UIControlStateNormal];
    }
    else{
        vi.selected = YES;
        [vi setImage:imageSelect forState:UIControlStateNormal];
        [vi setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        
//        if(vi == hkfsjjImage || vi == hkfsjjButton || vi == skfsjjImage || vi == skfsjjButton){
//            [self changeProtocolViewByUserTouchEvent:YES];
//        }
        
//        img = [img stretchableImageWithLeftCapWidth: 4 topCapHeight: 4];
//        [vi setBackgroundImage:img forState:UIControlStateNormal];
    }
    
    if(vi == hkfsjjImage || vi == hkfsjjButton || vi == skfsjjImage || vi == skfsjjButton){
        if(!skfsjjImage.selected && !hkfsjjImage.selected){
            [self changeProtocolViewByUserTouchEvent:NO];
        }
        else{
            [self changeProtocolViewByUserTouchEvent:YES];
        }
    }
    
    if(vi == szAgImage && !szAgImage.selected){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"取消深圳A股后,将无法参与深交所股票、基金等交易,请您慎重选择" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
    }
    
    if(vi == shAgImage && !shAgImage.selected){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"取消上海A股后,将无法参与上交所股票、基金等交易,请您慎重选择" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
    }
    
    if(!szAgImage.selected && !shAgImage.selected && (vi == shAgImage || vi ==szAgImage)){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"取消“上海A股”、“深圳A股”后，将无法参与沪深交易所股票、基金等交易" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
    }
}

- (void)changeProtocolViewByUserTouchEvent:(BOOL)bShow{
    int i = 0;
    if(bShow){
        i = [self initXYButton:YES];
    }
    else{
        i = [self initXYButton:NO];
    }
    
    if(i == 0){
        [readAndUnderstandImage setHidden:YES];
        [readAndUnderstandButton setHidden:YES];
    }
    
    [UIView animateWithDuration:0.2
                     animations:^{
        protocolView.frame = CGRectMake(levelSpace,
                                        readAndUnderstandButton.frame.origin.y + readAndUnderstandButton.frame.size.height,
                                        screenWidth - 2*levelSpace,
                                        ButtonHeight * i);
        
        nextStepBtn.frame = CGRectMake(levelSpace,
                                       protocolView.frame.origin.y + protocolView.frame.size.height + 20,
                                       screenWidth - 2*levelSpace,
                                       ButtonHeight);
    }completion:^(BOOL finish){
        [scrollView setContentSize:CGSizeMake(screenWidth, nextStepBtn.frame.origin.y + ButtonHeight + 2 * verticalHeight)];
    }];
    
}

- (void)OnTouchDownResign:(UITapGestureRecognizer *)gesture{
//    NSLog(@"views =%@", gesture.view);
}

//- (void)onSelectButtonGesture:(UIGestureRecognizer *)gesture{
//    NSLog(@"gestuer view =%@",[gesture view]);
//}

- (void)onSelectButton:(UIButton *)btn{
    int tagTemp = SelectTag + 1;
    [self buttonHandle:btn];
}

- (void)buttonHandle:(UIButton *)btn{
    int tagTemp = SelectTag + 1;
    if (btn.selected && btn.tag <= tagTemp) {
        UIButton * btnRev = (UIButton *)[centerView viewWithTag:btn.tag + 2];
        btn.selected = !btn.selected;
        btnRev.selected = btn.selected;
    }
    else if(btn.tag > tagTemp && !btn.selected){
        UIButton * btnRev = (UIButton *)[centerView viewWithTag:btn.tag - 2];
        btn.selected = !btn.selected;
        btnRev.selected = btn.selected;
    }
    else{
        btn.selected = !btn.selected;
    }
}

//- (void)onSelectTitleButton:(UIButton *)btn{
//    UIButton *targetBtn = (UIButton *)[centerView viewWithTag:btn.tag + 4];
//    [self buttonHandle:targetBtn];
//}

- (void)onButtonClick:(UIButton *)btn{
    if(shAgImage.selected == NO &&
       szAgImage.selected==NO &&
       skfsjjImage.selected==NO &&
       hkfsjjImage.selected==NO)
    {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"请选择欲开通的帐户" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    if(readAndUnderstandImage.selected == NO && !readAndUnderstandImage.isHidden){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"请阅读协议书" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    
    [self onGoToSecretVC];
}

- (void)onShowAlert:(NSString *)tipMessage{
    UIAlertView* dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setMessage:tipMessage];
    [dialog addButtonWithTitle:@"确定"];
    dialog.tag = 5;
    
    dialog.alertViewStyle = UIAlertViewStyleSecureTextInput;
    UITextField * textField = [dialog textFieldAtIndex:0];
    textField.delegate = self;
    textField.layer.cornerRadius = 3;
    textField.layer.masksToBounds = YES;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 5){
        UITextField * textField = [alertView textFieldAtIndex:0];
        NSString * sTextField = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(sTextField.length != 6){
            [self onShowAlert:@"密码长度需要是6位,请重新输入"];
        }
        else{
            [SJKHEngine Instance]->sImportPassword = sTextField;
            [self performSelector:@selector(onGoToSecretVC) withObject:nil afterDelay:0.3];
        }
    }
    else{
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)onGoToSecretVC{
    NSDictionary * dic =nil;
    
    /*
     开户协议与股东开户传送数据：""zqzh"":{""IBY1"":3,""XYSTR"":[{""HTXY"":""1"",""XYBH"":"""",""QMLSH"":""2012""},{""HTXY"":""2"",""XYBH"":"""",""QMLSH"":""2012""},{""HTXY"":""5"",""XYBH"":"""",""QMLSH"":""2012""}]}
     */
    
    NSString * mark = 0;
    if(shAgImage.selected && szAgImage.selected){
        mark = @"3";
    }
    else if(szAgImage.selected){
        mark = @"2";
    }
    else if(shAgImage.selected){
        mark = @"1";
    }
    else{
        mark = @"0";
    }
    
    NSString *mark2 = @"";
    if (hkfsjjImage.selected && skfsjjImage.selected) {
        mark2 = @"498;499";
    }
    else if(hkfsjjImage.selected){
        mark2 = @"498";
    }
    else if(skfsjjImage.selected){
        mark2 = @"499";
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CertHandle *certClass = [CertHandle defaultCertHandle];
        certClass.delegate = self;
        [self activityIndicate:YES tipContent:@"证书验证中..." MBProgressHUD:nil target:self.navigationController.view];
        isVailSuccess = [certClass vailCert];
        isVailFinish = YES;
    });
    while (!isVailFinish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    isVailFinish = NO;
    if(!isVailSuccess){
        //        [self activityIndicate:NO tipContent:@"证书验签失败" MBProgressHUD:nil target:self.navigationController.view];
        
        return ;
    }
    
    NSMutableArray * uploadToServerArray = [NSMutableArray array];
    for (NSDictionary * dic in [SJKHEngine Instance]->zqzh_step_Dic) {
        if(!bShowJiJinXYS && [[dic objectForKey:XYLX_ZQZH] intValue] == 7){
            continue ;
        }
        [uploadToServerArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [dic objectForKey:@"ID"],HTXY_CGYH,
                                        @"",XYBH_OCR,
                                        [SJKHEngine Instance]->qmlsh,QMLSH_CGYH,nil]];
    }
    NSMutableDictionary * saveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     mark,IBY1_ZQZH,
                                     uploadToServerArray,XYSTR_OCR,
                                     mark2,SQJJZH_ZQZH,
                                     nil];
    
    /*
     ""zqzh"":{""IBY1"":3,""XYSTR"":[{""HTXY"":""1"",""XYBH"":"""",""QMLSH"":""2012""},{""HTXY"":""2"",""XYBH"":"""",""QMLSH"":""2012""},{""HTXY"":""5"",""XYBH"":"""",""QMLSH"":""2012""}]}
     */
    [self activityIndicate:YES tipContent:@"保存页面数据..." MBProgressHUD:nil target:self.navigationController.view];
    [self sendSaveStepInfo:ZQZH_STEP dataDictionary:&dic arrar:saveDic];
    
    while (!bSaveStepFinish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    bSaveStepFinish = NO;
    
    if(bSaveStepSuccess){
        [self activityIndicate:YES tipContent:@"加载密码设置页面..." MBProgressHUD:nil target:self.navigationController.view];
        SecretSetViewCtrl * secretVC = [[SecretSetViewCtrl alloc]init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self dispatchSecretVC:secretVC];
        });
    }
    else {
        [self activityIndicate:NO tipContent:@"保存页面数据失败" MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void)dispatchSecretVC:(SecretSetViewCtrl *)secretVC{
    NSDictionary * stepDictionary = nil;
    if([self sendSaveCurrentStepKey:MMSZ_STEP dataDictionary:&stepDictionary]){
        BOOL ok = [self sendGoToStep:MMSZ_STEP dataDictionary:&stepDictionary];
        if(ok){
            [SJKHEngine Instance]->mmsz_step_Dic = [stepDictionary mutableCopy];
            NSMutableArray * ar = [[SJKHEngine Instance]->mmsz_step_Dic objectForKey:RMMARR_MMSZ];
            secretVC->rmmArray = [NSMutableArray array];
            for (NSDictionary * rmm in ar) {
                [secretVC->rmmArray addObject:[rmm objectForKey:@"MM"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                [self.navigationController pushViewController:secretVC animated:YES];
                
                if ([SJKHEngine Instance]->mmsz_step_Dic &&
                    [SJKHEngine Instance]->mmsz_step_Dic.count > 0)
                {
//                    [secretVC updateUI];
                }
                else {
                    [self activityIndicate:NO tipContent:@"加载密码设置页面失败" MBProgressHUD:nil target:self.navigationController.view];
                }
            });
        }
        else {
            [self activityIndicate:NO tipContent:@"加载密码设置页面失败" MBProgressHUD:nil target:self.navigationController.view];
//            [[SJKHEngine Instance] dispatchMessage:POP_MESSAGE];
        }
    }
    else{
        [self activityIndicate:NO tipContent:@"保存开户步骤失败" MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void)updateUI{
    [super updateUI];
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)certHandleResault:(NSString *)resaultString{
    if ([resaultString isEqualToString:@"证书验签成功"]) {
        [self activityIndicate:NO tipContent:resaultString MBProgressHUD:nil target:self.navigationController.view];
    }
    else{
        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        [self performSelectorOnMainThread:@selector(onShowAlert:) withObject:resaultString waitUntilDone:NO];
    }
    
//    [self onShowAlert:resaultString];
}

- (void) showCustomAlertViewContent:(BOOL)isShow htmlString:(NSString *)htmlString{
    if(isShow){
        [SJKHEngine Instance]->_customAlertView->htmlKey = XYZRS_NAME;
        [[SJKHEngine Instance]->_customAlertView setTarget:self withSEL:@selector(showCustomAlertViewContent:htmlString:)];
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:YES htmlString:htmlString];
    }
    else{
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:NO htmlString:nil];
    }
}

- (void)popToLastPage{
    [[SJKHEngine Instance]->_customAlertView removeFromSuperview];
    [SJKHEngine Instance]->_customAlertView = nil;
    [super popToLastPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [headerFlowButton removeFromSuperview];
    headerFlowButton = nil;
    [tipLabel removeFromSuperview];
    tipLabel = nil;
    [centerView removeFromSuperview];
    centerView = nil;
    [shAgImage removeFromSuperview];
    shAgImage = nil;
    [shAgButton removeFromSuperview];
    shAgButton = nil;
    [szAgImage removeFromSuperview];
    szAgImage = nil;
    [szAgButton removeFromSuperview];
    szAgButton = nil;
    [hkfsjjImage removeFromSuperview];
    hkfsjjImage = nil;
    [hkfsjjButton removeFromSuperview];
    hkfsjjButton = nil;
    [skfsjjImage removeFromSuperview];
    skfsjjImage = nil;
    [skfsjjButton removeFromSuperview];
    skfsjjButton = nil;
    [readAndUnderstandImage removeFromSuperview];
    readAndUnderstandImage = nil;
    [readAndUnderstandButton removeFromSuperview];
    readAndUnderstandButton = nil;
    [protocolView removeFromSuperview];
    protocolView = nil;
    
    selectNames = nil;
    [readZRS removeFromSuperview];
    readZRS = nil;
    imageDefault = nil;
    imageHighLight = nil;
    imageSelect = nil;
    
    NSLog(@"帐户类型回收");
}

@end
