//
//  FirstPageViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-6-9.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "FirstPageViewCtrl.h"
#import "LoanMainViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"

@interface FirstPageViewCtrl ()

@end

@implementation FirstPageViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
//    [super initConfig];
//    [super initWidget];
    
//    /xwd/mobile/welcome/sy
    
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    [self initConfig];
    [self initWidget];
    
    [self toLoadWebPage:YES];
    // Do any additional setup after loading the view.
}

- (void)initConfig{
    webViewURL = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/welcome/sy", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port];
    [super initConfig];
}

- (void)initWidget{
    [super initWidget];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"首页回收");
}

- (void)xwdPopMessage{
    self.urlConnection = nil;
 //   [[SJKHEngine Instance].observeCtrls removeObject:self];
    [webView stopLoading];
    webView.delegate = nil;
    self.cancelTimer = nil;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated{
//    if(((LoanMainViewCtrl *) self.tabBarController)->bTouchFirstPage){
//        [[SJKHEngine Instance] dispatchMessage:XWD_JUSTPOP_MESSAGE];
//        ((LoanMainViewCtrl *) self.tabBarController)->bTouchFirstPage = NO;
//    }
    
//    KHRequestOrSearchViewCtrl * khRequestVC = [[KHRequestOrSearchViewCtrl alloc]init];
//    [self.navigationController pushViewController:khRequestVC animated:YES];
    
//    NSLog(@"FRAME =%@,%@,%@,%@",NSStringFromCGRect(self.navigationController.view.frame),NSStringFromCGRect(self.navigationController.view.bounds),NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds));
    
    [super viewDidAppear:animated];
}


@end
