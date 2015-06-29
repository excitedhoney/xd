//
//  LoginViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-21.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "LoginViewCtrl.h"
#import "LoanMainViewCtrl.h"
#import "RootModelViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "SettingViewController.h"
#import "aes.h"
//#import "CustomIntroductionView.h"


@interface LoginViewCtrl (){
    CGRect khButtonRect;
    int bLocalFirstShow;
    BOOL bFirstLayoutView;
//    MYIntroductionView *introductionView;

}

@end

@implementation LoginViewCtrl

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
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    singleTapRecognizer.delegate = self;
    kaihuNumberField.delegate = self;
    kaihuPasswordField.delegate = self;
    [kaihuPasswordField setSecureTextEntry:YES];
    kaihuNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    kaihuPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [loginButton addTarget:self action:@selector(onLoginHandle) forControlEvents:UIControlEventTouchUpInside];
    [kaihuButton addTarget:self action:@selector(onToKaihuHandle) forControlEvents:UIControlEventTouchUpInside];
    
    [kaihuButton setHidden:YES];
    
    bLocalFirstShow = YES;
    bFirstLayoutView = YES;
    
    [self addGesture:self.view];
    
    if([SJKHEngine Instance]->systemVersion < 6){
        singleTapRecognizer.delegate = self;
    }
        
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    
    [self onSmallScreenResetAutoLayout];
    
     NSLog(@"self.view 0=%@,%@,%@,%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds),kaihuNumberHeaderImageView,kaihuNumberField);
}

//改变3.5寸屏下autolayout的constrain对象的值。系统生成的自动布局并不完善
- (void)onSmallScreenResetAutoLayout{
    if(screenHeight == 480){
        if([SJKHEngine Instance]->systemVersion > 5){
            for (NSLayoutConstraint * constrant in self.view.constraints) {
                if(constrant.firstItem == headerImageView && constrant.firstAttribute == NSLayoutAttributeTop)
                {
                    [constrant setConstant:constrant.constant - 50];
                }
            }
        }
    }
}

//- (IBAction)testButton:(id)sender{
//    NSLog(@"testButton");
//}

- (void)showSettingVC:(UIGestureRecognizer *)getture{
    SettingViewController * settingVC = [[SettingViewController alloc]init];
    UINavigationController * naviVC = [[UINavigationController alloc]initWithRootViewController:settingVC];
    [self presentModalViewController:naviVC animated:YES];
}

- (void)InitWidgets{
    [headerImageView setImage:[UIImage imageNamed:@"SmallLoanBundle.bundle/images/icon_user_photo"]];
    //待调试
    [headerImageView setUserInteractionEnabled:YES];
    [headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettingVC:)]];
    
    UIImage * headerImage = [UIImage imageNamed:@"SmallLoanBundle.bundle/images/txt_login_number"];
    [kaihuNumberHeaderImageView setImage:headerImage];
//    [kaihuNumberHeaderImageView setContentMode:UIViewContentModeScaleToFill];
    headerImage = nil;
    headerImage = [UIImage imageNamed:@"SmallLoanBundle.bundle/images/txt_login_password"];
    [kaihuPassHeaderImageView setImage: headerImage];
    
    [self changeFieldBorderColor:NO targetView:kaihuNumberView bJustChangeLayer:NO];
    [self changeFieldBorderColor:NO targetView:kaihuPasswordView bJustChangeLayer:NO];
    [self changeFieldBorderColor:NO targetView:loginButton bJustChangeLayer:YES];
    
    [kaihuNumberView setUserInteractionEnabled:NO];
    [kaihuPasswordView setUserInteractionEnabled:NO];
    
    [kaihuNumberField setPlaceholder:@"客 户 号"];
    [kaihuPasswordField setPlaceholder:@"密 码"];
    [kaihuNumberField setBackgroundColor:[UIColor whiteColor]];
    [kaihuPasswordField setBackgroundColor:[UIColor whiteColor]];
    kaihuNumberField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    kaihuPasswordField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    UIColor * loginButtonColor = [UIColor colorWithRed:239.0/255 green:65.0/255 blue:86.0/255 alpha:1];
    [loginButton setBackgroundColor:loginButtonColor];
    loginButton.layer.borderColor = loginButtonColor.CGColor;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    UIImage * kaihuImage = [UIImage imageNamed: [NSString stringWithFormat:@"button_gray_default"]];
    kaihuImage = [kaihuImage stretchableImageWithLeftCapWidth: 8 topCapHeight: 8];
    kaihuImage = [kaihuImage imageByResizingToSize:kaihuButton.frame.size];
    //    kaihuImage = [kaihuImage imageByResizingToSize:loginButton.frame.size];
    [kaihuButton setBackgroundImage:kaihuImage forState:UIControlStateNormal];
    
    [kaihuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    kaihuButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
//    [kaihuButton setContentMode:UIViewContentModeScaleAspectFit];
    
    [super InitWidgets];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

//对ios5的系统进行区别处理，如果点击loginbutton或kaihuButton的位置，gesture事件将被注销。
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.view];
//    NSLog(@"point =%@,%i,%i",NSStringFromCGPoint(point),CGRectContainsPoint(loginButton.frame, point),CGRectContainsPoint(kaihuButton.frame, point));
    if(CGRectContainsPoint(loginButton.frame, point) || CGRectContainsPoint(kaihuButton.frame, point)){
        return NO;
    }
    
    return YES;
}

- (void)onLoginHandle{
    [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:kaihuNumberField,kaihuPasswordField, nil]];
    
    NSString * kaihuNumberText = [kaihuNumberField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * kaihuPassText = [kaihuPasswordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(kaihuNumberText.length == 0 || kaihuNumberText == nil){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请先输入客户号" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    if(kaihuPassText.length == 0 || kaihuPassText == nil){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请先输入密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    
    [self activityIndicate:YES tipContent:@"正在获取加密数据..." MBProgressHUD:nil target:self.navigationController.view];
    
    //加入aes加密版块
    unsigned char * output = nil ;
//    unsigned char output[1024] ;
    AES_KEY key ;
//    int ar[] = {1,334,1};
    for (int i = 0; i < 60; i++) {
        key.rd_key[i] = i;
    }
    
//    key.rd_key = ar;
//    key.rd_key = {1,334,1};
    
    key.rounds = 60;
    const unsigned char * inPut = [kaihuPassText UTF8String];
    AES_encrypt(inPut, output , &key);
    NSLog(@"output miwen =%s,%s,%@",inPut, output,[NSString stringWithFormat:@"%s",output] );
    
//    unsigned char twoput[1024] ;
//    AES_decrypt(output,twoput,&key);
//    NSLog(@"output miwen 2=%s,%s,%@",output, twoput,[NSString stringWithFormat:@"%s",output] );
    
    
    AES_KEY enkey;
//    AES_set_encrypt_key(““,128,&enkey);
    
//    unsigned char output[1024];
//    NSString * keyString = @"em300059370626";
////    NSData * keydata = [NSData dataWithBytes:[key UTF8String] length:strlen([key UTF8String])];
//    AES_set_encrypt_key([keyString UTF8String],128,&enkey);
//    [self AES_Encrypt_Block:inPut inlen:sizeof(inPut) outStr:output enkey:&enkey];
//    NSLog(@"output miwen =%s,%s,%@",inPut, output,[NSString stringWithFormat:@"%s",output] );
//    
//    unsigned char twoput[1024] ;
//    [self AES_Decrypt_Block:output inlen:sizeof(output) outStr:twoput dekey:&enkey];
//    NSLog(@"output miwen 2=%s,%s,%@",output, twoput,[NSString stringWithFormat:@"%s",output] );
    
    [self dispatchXWDPage:[NSMutableArray arrayWithObjects:
                           kaihuNumberText,
                           [NSString stringWithFormat:@"%s","123"] ,
                           nil]];
}

- (void) AES_Encrypt_Block:(unsigned char*)inStr inlen:(int)inlen outStr:(unsigned char*)outStr enkey:(AES_KEY*)enkey
{
//	int i;
//	for(i=0;i<inlen/16;i++)
//	{
		AES_encrypt(inStr,outStr,enkey);
//	}
}

- (void) AES_Decrypt_Block:(unsigned char*)inStr inlen:(int)inlen outStr:(unsigned char*)outStr dekey:(AES_KEY*)dekey
{
	int i;
	for(i=0;i<inlen/16;i++)
	{
		AES_decrypt(inStr+i*16,outStr+i*16,dekey);
	}
}

//跳到我要开户的起始界面
- (void)onToKaihuHandle{
    KHRequestOrSearchViewCtrl * rootVC = [[KHRequestOrSearchViewCtrl alloc]init];
    [self.navigationController pushViewController:rootVC animated:YES];
}

//进入小微贷页面所作操作
- (void)dispatchXWDPage:(NSMutableArray *)postValues{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * dic = nil;
        BOOL bLoadSuccess = NO;
        [self sendGetRSAPublicKey:nil dataDictionary:&dic];
        NSLog(@"diccccc =%@",dic);
        
        /*
         modules = 9a7dae708933ee3b805abbfac9e0bd0e427632045a354ab284b8abfa18aa32567d8a62edce42cd3fb8b74b9e7d3e3c61362359bd59e8d147f44eaf624a464582dcfb3ad219e02ff2389b3bcef02f028e19a3430bb25d4ffe2438c26b8132e51035cce09a7640ff429ef588ed3a36fc7f3c0b10c7a31c11ebf663f80f78dea161;
         publicExponent = 10001;
         success = 1;
         */
        if (dic && dic.count > 0) {
            dic = nil;
            [self activityIndicate:YES tipContent:@"正在登录..." MBProgressHUD:nil target:self.navigationController.view];
            bLoadSuccess = [self sendLoginXWDPage:&dic postValues:postValues];
            NSLog(@"dic =%@,%i,%@",dic,bLoadSuccess,[dic objectForKey:NOTE]);
            
            if(bLoadSuccess && dic){
                [SJKHEngine Instance]->xwdAccount = [postValues firstObject];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    LoanMainViewCtrl *loadMainVC = nil;
                    UIStoryboard *storyBoard = nil;
                    NSString * nibName = @"LoanMainStoryBoard";
                    if([SJKHEngine Instance]->systemVersion < 6){
                        nibName = [nibName stringByAppendingString:FORIOS5XIB];
                    }
                    
                    storyBoard = [UIStoryboard storyboardWithName:nibName bundle:nil];
                    loadMainVC = [storyBoard instantiateInitialViewController];
                    [SJKHEngine Instance]->uuid = [[dic objectForKey:UUID] mutableCopy];
                    [self.navigationController pushViewController:loadMainVC animated:YES];
                    
                    [self activityIndicate:NO tipContent:nil MBProgressHUD:hud target:self.navigationController.view];
                });
            }
            else{
                NSString * tip = @"登陆失败";
                if([dic objectForKey:NOTE]){
                    tip = [dic objectForKey:NOTE];
                }
                [self activityIndicate:NO tipContent:tip MBProgressHUD:hud target:self.navigationController.view];
            }
        }
        else{
            [self activityIndicate:NO tipContent:@"加载加密数据失败" MBProgressHUD:hud target:self.navigationController.view];
        }
    });
}

- (void)viewWillLayoutSubviews{
    //将以屏幕最左上角的点为参考系，改为以状态栏的底部线条和左边框的交点为参考点。
    
//    if([SJKHEngine Instance]->systemVersion <= 6){
//        self.navigationController.view.frame = CGRectMake(0, 20, screenWidth, screenHeight - 20);
//    }
//    else{
//        self.navigationController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
//    }
    
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews{
//    [self changeFieldCursorPosition:[NSMutableArray arrayWithObjects:kaihuNumberField,kaihuPasswordField,nil]];
//    [kaihuNumberField setSelectedTextRange:[kaihuNumberField textRangeFromPosition:0 toPosition:uitext]];
    
//        CGRect rect = kaihuNumberView.frame;
//        headerImageView.frame = CGRectMake(screenWidth/2 - 75/2.0,
//                                           kaihuNumberView.frame.origin.y / 2 - 75/2.0,
//                                           75,
//                                           75);
    
    if([SJKHEngine Instance]->systemVersion > 5){
        int space = 5;
        kaihuNumberField.frame = CGRectMake(kaihuNumberField.frame.origin.x - space,
                                            kaihuNumberField.frame.origin.y,
                                            kaihuNumberField.frame.size.width + space,
                                            kaihuNumberField.frame.size.height);
        kaihuPasswordField.frame = CGRectMake(kaihuPasswordField.frame.origin.x - space,
                                              kaihuPasswordField.frame.origin.y,
                                              kaihuPasswordField.frame.size.width + space,
                                              kaihuPasswordField.frame.size.height);
    }
    if([SJKHEngine Instance]->systemVersion == 5){
        if(bFirstLayoutView){
            bFirstLayoutView = NO;
            int space = 5;
            kaihuNumberField.frame = CGRectMake(kaihuNumberField.frame.origin.x - space,
                                                kaihuNumberField.frame.origin.y,
                                                kaihuNumberField.frame.size.width + space,
                                                kaihuNumberField.frame.size.height);
            kaihuPasswordField.frame = CGRectMake(kaihuPasswordField.frame.origin.x - space,
                                                  kaihuPasswordField.frame.origin.y,
                                                  kaihuPasswordField.frame.size.width + space,
                                                  kaihuPasswordField.frame.size.height);
        }
    }
    
    [super viewDidLayoutSubviews];
}

- (void)changeFieldCursorPosition:(NSMutableArray *)ar{
    for(UITextField * field in ar){
        NSLog(@"input =%@,%@",field.inputView,field.inputAccessoryView);
        
//        [field.inputView setBackgroundColor:[UIColor redColor]];
        
        for (UIView * vi in field.subviews) {
            if([vi isKindOfClass:[UILabel class]]){
                vi.frame = CGRectMake(vi.frame.origin.x + 10,
                                      vi.frame.origin.y,
                                      vi.frame.size.width,
                                      vi.frame.size.height);
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
//    [self.view setNeedsDisplay];
    
//    [self.navigationController.view layoutSubviews];
    
//    [kaihuNumberHeaderImageView setNeedsLayout];
    
//    [kaihuButton setNeedsLayout];
//    [kaihuButton setNeedsDisplay];
    
//    self.view.frame = CGRectMake(0, 20, screenWidth, screenHeight - 20);
//    self.view.bounds = CGRectMake(0, -20, screenWidth, screenHeight - 20);
    
    if([SJKHEngine Instance]->xwdAccount && [SJKHEngine Instance]->xwdAccount.length > 0)
    {
        [kaihuNumberField setText:[SJKHEngine Instance]->xwdAccount];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"self.view =%@,%@,%@,%@,%@,%@,%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds),
          NSStringFromCGRect(self.navigationController.view.frame), NSStringFromCGRect(self.navigationController.view.bounds),kaihuNumberHeaderImageView,kaihuNumberField,kaihuNumberField.subviews);
    
    [super viewDidAppear:animated];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//}

- (void)OnTouchDownResign:(UIGestureRecognizer *)gesture{
//    NSLog(@"gesture.view =%@",gesture.view);
    
//    if(gesture.view == loginButton){
//        [self onLoginHandle];
//        return ;
//    }
//    if(gesture.view == kaihuButton){
//        [self onToKaihuHandle];
//        return;
//    }
    
    if(bKeyBoardShow ){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:kaihuNumberField,kaihuPasswordField, nil]];
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bKeyBoardShow = YES;
    
    UITextPosition *beginning = [textField beginningOfDocument];
    [textField setSelectedTextRange:[textField textRangeFromPosition:beginning
                                                          toPosition:beginning]];
    
//    [self performSelector:@selector(changeFieldCursorPosition:) withObject:[NSMutableArray arrayWithObjects:kaihuNumberField,kaihuPasswordField,nil] afterDelay:0.1];
    
    keyboardOffset = textField.frame.origin.y + textField.frame.size.height - (screenHeight - 20 - 44 - KeyBoardHeight);
//    textField.layer.borderColor = [UIColor colorWithRed:255.0/255 green:71.0/255 blue:96.0/255 alpha:1].CGColor;
    if(textField == kaihuNumberField){
        [self changeFieldBorderColor:YES targetView:kaihuNumberView bJustChangeLayer:NO];
    }
    if(textField == kaihuPasswordField){
        [self changeFieldBorderColor:YES targetView:kaihuPasswordView bJustChangeLayer:NO];
    }
    
    if(keyboardOffset > 0){
        [self beginEdit:YES textFieldArrar:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == kaihuNumberField){
        [self changeFieldBorderColor:NO targetView:kaihuNumberView bJustChangeLayer:NO];
    }
    if(textField == kaihuPasswordField){
        [self changeFieldBorderColor:NO targetView:kaihuPasswordView bJustChangeLayer:NO];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * fieldText = [NSString stringWithFormat:@"%@%@", textField.text , string];
    
    //移动光标位置的尝试
//    UITextPosition *start = [textField positionFromPosition:[textField beginningOfDocument]
//                                                 offset:range.location];
//    UITextPosition *end = [textField positionFromPosition:start
//                                               offset:range.length];
//    [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:end]];
    
//    UITextRange *selRange = textField.selectedTextRange;
//    UITextPosition *selStartPos = selRange.start;
//    NSInteger idx = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selStartPos];
//    [textField setSelectedTextRange:[textField textRangeFromPosition:0 toPosition:idx]];
    
    if(fieldText.length > 18 && textField == kaihuNumberField){
        return NO;
    }
    if(fieldText.length > 6 && textField == kaihuPasswordField){
        return NO;
    }
    return  YES;
}

- (void)reposControl{
    int offset = 0;
    
    if([SJKHEngine Instance]->systemVersion == 7){
        offset = 64;
    }
    
	if (bKeyBoardShow)
	{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, offset-(keyboardOffset + verticalHeight), screenWidth, self.view.frame.size.height);
        }completion:^(BOOL finish){
            
        }];
	}
	else
	{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, offset, screenWidth, self.view.frame.size.height);
        }completion:^(BOOL finish){
            
        }];
	}
}

- (BOOL)sendGetRSAPublicKey:(NSString *)stepName dataDictionary:(NSDictionary **)stepResponseDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@:%d%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,@"/xwd/mobile/user/getRSAPublic"];
    
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:URL];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (BOOL)sendLoginXWDPage:(NSDictionary **)stepResponseDic postValues:(NSMutableArray *)postValues{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@:%d%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,@"/xwd/mobile/user/loginByMobile?khh&password"];
    ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
    
    NSArray *ar = [PublicMethod convertURLToArray:urlComponent];
    [theRequest setPostValue:[postValues objectAtIndex:0]
                      forKey:[ar firstObject]];
    [theRequest setPostValue:[postValues objectAtIndex:1]
                      forKey:[ar objectAtIndex:1]];
    [theRequest startSynchronous];
    
    return [self parseResponseData:theRequest dic:stepResponseDic];
}

- (void)popToLastPage{
    [self.navigationController popToRootViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
    
    [super popToLastPage];
    
    [kaihuNumberField resignFirstResponder];
    [kaihuPasswordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"小微贷登录回收");
}

@end
