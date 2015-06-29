//
//  LoanBaseViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ApexJs.h"
#import "ShareHeader.h"

@interface LoanBaseViewCtrl : BaseViewController<UIWebViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,ApexJsDelegate,UMSocialUIDelegate>{
    @public
    UIWebView * webView;
    UISearchBar * webSearchBar;
    NSMutableArray * urlStacks;
    NSMutableArray * startupMessageQueue;
    
    
@public
    NSString * webViewURL;
    
}

@property (strong, nonatomic) ApexJs *javascriptBridge;
@property (strong, nonatomic) NSURLConnection * urlConnection;
@property (strong, nonatomic) NSTimer * cancelTimer;


- (void)toLoadWebPage:(BOOL)toLoad;

- (void)toLoadWebPageWithUrl:(NSString *)weburl;

- (void)initWidget;

- (void)initConfig;


@end
