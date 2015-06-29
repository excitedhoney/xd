//
//  CreditViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "CreditViewCtrl.h"
#import "SJKHEngine.h"

@interface CreditViewCtrl (){
    
}

@end


@implementation CreditViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initConfig];
    [self initWidget];
    
    [self toLoadWebPage:YES];
}

- (void)initConfig{
//    webViewURL = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/jk/xzcp?uuid=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid];
    webViewURL = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/jk/xzcp_uat?uuid=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid];
    [super initConfig];
}

- (void)xwdPopMessage{
    self.urlConnection = nil;
    
    [webView stopLoading];
    webView.delegate = nil;
    self.cancelTimer = nil;
    
//    [[SJKHEngine Instance].observeCtrls removeObject:self];
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
    NSLog(@"借款回收");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
