//
//  LoginViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-21.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"
//#import "InsetTextField.h"
#import "MYIntroductionPanel.h"
//#import "MYIntroductionView.h"
#import "CustomIntroductionView.h"
#import "LoanBaseViewCtrl.h"

@interface LoginViewCtrl : BaseViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,MYIntroductionDelegate>{
    @public
    IBOutlet UIImageView * headerImageView;
    IBOutlet UIView * kaihuNumberView;
    IBOutlet UIView * kaihuPasswordView;
    IBOutlet UITextField * kaihuNumberField;
    IBOutlet UITextField * kaihuPasswordField;
    IBOutlet UIButton * loginButton;
    IBOutlet UIButton * kaihuButton;
    IBOutlet UIImageView * kaihuNumberHeaderImageView;
    IBOutlet UIImageView * kaihuPassHeaderImageView;
    IBOutlet UINavigationBar * naviBar;
    IBOutlet UIButton * rememberAccountButton;
    IBOutlet UIButton * forgetSecretButton;
    LoanBaseViewCtrl * handleLoanBaseVC;
    
}

//- (void)popToLastPage;

- (void)onLoginHandle;

//- (IBAction)testButton:(id)sender;

@end
