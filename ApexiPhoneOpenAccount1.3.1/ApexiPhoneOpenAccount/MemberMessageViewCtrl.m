//
//  MemberMessageViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "MemberMessageViewCtrl.h"
#import "SJKHEngine.h"

@interface MemberMessageViewCtrl ()

@end

@implementation MemberMessageViewCtrl

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initConfig];
    [self initWidget];
    
    [self toLoadWebPage:YES];
}

- (void)initConfig{
    webViewURL = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/user/me?uuid=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid];
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
    NSLog(@"我界面回收");
}

- (void)xwdPopMessage{
    self.urlConnection = nil;
    [webView stopLoading];
    webView.delegate = nil;
    self.cancelTimer = nil;
    
//    [[SJKHEngine Instance].observeCtrls removeObject:self];
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
