//
//  LoanBaseViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "LoanBaseViewCtrl.h"
#import "Data_Structure.h"
#import "ApexJs.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "CustomURLCache.h"
//#import "../../NetWork/NetWork/NetReachability.h"
//#import "../../aximApi_IOS_XMPP_12_19/axim/webconnect/Reachability.h"
#import "Reachability.h"

@interface LoanBaseViewCtrl (){
    UIActivityIndicatorView * indicatorView;
    CGRect rootViewFrame;
    UMSocialIconActionSheet * socialIconSheet;
    
//    BOOL bToLogin;
}

@end

@implementation LoanBaseViewCtrl

@synthesize javascriptBridge;
@synthesize urlConnection;
@synthesize cancelTimer;

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
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    if([SJKHEngine Instance]->systemVersion >= 7){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
}

- (void)setUrlConnection:(NSURLConnection *)_urlConnection{
    if(urlConnection){
        [urlConnection cancel];
        urlConnection = nil;
    }
    urlConnection = _urlConnection;
}

- (void)setCancelTimer:(NSTimer *)_cancelTimer{
    if(cancelTimer){
        [cancelTimer invalidate];
        cancelTimer = nil;
    }
    
    cancelTimer = _cancelTimer;
}

- (void)initConfig{
    if([SJKHEngine Instance]->systemVersion >= 7){
        self.view.bounds = CGRectMake(0, -20, screenWidth, self.view.frame.size.height);
    }
    
    rootViewFrame = self.view.frame;
    delayTime = 2;
    
    [self.navigationController.navigationItem setHidesBackButton:YES];
//    UITapGestureRecognizer *single = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    single.numberOfTapsRequired = 1;
//    single.numberOfTouchesRequired = 1;
//    [webView addGestureRecognizer:single];
    
//    [self addGesture:webView];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)buttonPressed:(id)sender {
    [self.javascriptBridge sendMessage:@"Message from ObjC on normal situations!" toWebView:webView];
}

- (void)javascriptBridge:(ApexJs *)bridge receivedMessage:(NSString *)message fromWebView:(UIWebView *)webView {
    NSLog(@"js message = %@",message);
    
    //显示我菜单的红点
    if([message intValue] == CODE_SHOW_ME_POINT){
        [[SJKHEngine Instance]->loanMainVC->me_RedCycleButton setHidden:NO];
    }
    //隐藏我菜单的红点
    if([message intValue] == CODE_HIDDEN_ME_POINT){
        [[SJKHEngine Instance]->loanMainVC->me_RedCycleButton setHidden:YES];
    }
    //显示借款菜单的红点
    if([message intValue] == CODE_SHOW_JK_POINT){
        [[SJKHEngine Instance]->loanMainVC->jk_RedCycleButton setHidden:NO];
    }
    //隐藏借款菜单的红点
    if([message intValue] == CODE_HIDDEN_POINT_POINT){
        [[SJKHEngine Instance]->loanMainVC->jk_RedCycleButton setHidden:YES];
    }
    //马上开户
    if([message intValue] == CODE_MSKH){
        KHRequestOrSearchViewCtrl * khRequestVC = [[KHRequestOrSearchViewCtrl alloc]init];
        [self.navigationController pushViewController:khRequestVC animated:YES];
    }
    //点击马上借钱的时候切换菜单;5--融易宝 9-－申易宝
    if([message intValue] == CODE_MSJQ_UPDATE_MENU || [message intValue] == CODE_SYB_SKIP){
        self.tabBarController.selectedIndex = 1;
        UINavigationController * loanVC = [self.tabBarController.viewControllers objectAtIndex:1];
        LoanBaseViewCtrl * rootLoanVC = [loanVC.viewControllers firstObject];
        
        rootLoanVC.urlConnection = nil;
        [rootLoanVC->webView stopLoading];
        self.cancelTimer = nil;
        
        NSString * weburl = @"";
        switch (message.intValue) {
            case CODE_MSJQ_UPDATE_MENU:
                weburl = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/jk/jk?zjfl=0", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port];
                break;
                
            case CODE_SYB_SKIP:
                weburl = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/jk/jk?zjfl=1", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port];
                break;
                
            default:
                break;
        }
        [rootLoanVC toLoadWebPageWithUrl:weburl];
        
//        [rootLoanVC toLoadWebPage:YES];
    }
    //分享
    if([message intValue] == CODE_SHARE){
        [self onTestClick:nil];
    }
    //打电话
    if([message intValue] == CODE_CALL_PHONE){
        
    }
    if([message intValue] == CODE_CALL_RETURN_VERSION){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setVersionDate('%@');", [NSString stringWithFormat:@"{\"versionName\":\"%@\",\"systemVersion\":\"%@\"}",appCurVersion,[[UIDevice currentDevice] systemVersion]]]];
        
//        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"javascript:setVersionDate('%@');", [NSString stringWithFormat:@"{versionName:%@,systemVersion:%@}",appCurVersion,[[UIDevice currentDevice] systemVersion]]]]]];
    }

}

- (void)loadExamplePage {
    [webView loadHTMLString:@""
     "<!doctype html>"
     "<html><head>"
     "  <style type='text/css'>h1 { color:red; }</style>"
     "</head><body>"
     "  <script>"
//     "  document.addEventListener('sendMessage', onBridgeReady, false);"
//     "  function onBridgeReady() {"
//     "      ApexJs.setMessageHandler(function(message) {"
//     "          ApexJs.sendMessage(message);"
//     "      });"
//     "  }"
//     "var ApexJs = window.ApexJs;"
     
     "  </script>"
     "</body></html>" baseURL:nil];
}

- (void)initWidget{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 49 - 20)];
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    webView.opaque = NO;
    [self.view addSubview: webView];
    [webView setHidden:NO];
    
    urlStacks = [[NSMutableArray alloc]init];
    
    int indicatorWidth = 30;
    indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setFrame:CGRectMake(rootViewFrame.size.width/2 - indicatorWidth/2,
                                       rootViewFrame.size.height/2 - indicatorWidth/2,
                                       indicatorWidth,
                                       indicatorWidth)];
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView stopAnimating];
    [self.view addSubview:indicatorView];
    
    if([SJKHEngine Instance]->systemVersion >= 7){
        webSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
        //    UIImage * searchBarImage = [UIImage imageWithColor:[UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:1] size:CGSizeMake(screenWidth, 44)];
        UIImage * barIamge = [[UIImage imageNamed:@"SmallLoanBundle.bundle/images/bg_menu"] clipImagefromRect:CGRectMake(0, 8, screenWidth, 20)];
        [webSearchBar setBackgroundImage:barIamge
                          forBarPosition:UIBarPositionAny
                              barMetrics:UIBarMetricsDefault];
        webSearchBar.delegate = self;
        [self.view addSubview:webSearchBar];
        [webSearchBar setHidden:NO];
    }
    
//    bToLogin = NO;
    
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    [webView addGestureRecognizer:singleTap];
//    singleTap.delegate = self;
//    singleTap.cancelsTouchesInView = NO;
    
    [self.view bringSubviewToFront:webView];
    
    {
        //js相关
        self.javascriptBridge = [ApexJs javascriptBridgeWithDelegate:self];
        webView.delegate = self.javascriptBridge;
//#define JsStr @"var ApexJs = {}; (function initialize() { ApesJs.sendMessage = function () { ApexJs.sendMessage('5');};})(); "
//        NSString *js = [NSString stringWithFormat:JsStr];
//        [webView stringByEvaluatingJavaScriptFromString:js];
        
//        CustomURLCache * urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
//                                                     diskCapacity:30 * 1024 * 1024
//                                                         diskPath:@"1"
//                                                        cacheTime:120];
//        [CustomURLCache setSharedURLCache:urlCache];
        
//        [self loadExamplePage];
//        [webView stringByEvaluatingJavaScriptFromString:@"<script>var ApexJs = window.ApexJs;</script>"];
    }
    
    {
        //友盟社会化分享相关
        [UMSocialConfig setNavigationBarConfig:^(UINavigationBar *bar,UIButton *closeButton,UIButton *backButton,UIButton *postButton,UIButton *refreshButton,UINavigationItem * navigationItem){
            UIImage *image =[UIImage imageNamed:@"icon-close.png"];
            [closeButton setImage:image forState:UIControlStateNormal];
            [postButton setImage:[UIImage imageNamed:@"icon-right.png"] forState:UIControlStateNormal];
            [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0,7)];
            [postButton setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0,7)];
            
            UIView * titleView = navigationItem.titleView;
            if(titleView){
                UILabel * la = (UILabel *)titleView;
                [la setTextColor:[UIColor whiteColor]];
                la.font = [UIFont boldSystemFontOfSize:22];
                [la sizeToFit];
            }
            
            [bar setBackgroundImage:[UIImage
                                     imageWithColor:NAV_BG_COLOR
                                     size:CGSizeMake(screenWidth, 44)]
                      forBarMetrics:UIBarMetricsDefault];
        }];
        
        [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    }
    
    [PublicMethod hideGradientBackground:webView];
    
//    [self addGesture:webView];
    singleTapRecognizer.delegate = self;
}

- (void)onTestClick:(UIButton *)sender{
    NSString *shareText = [NSString stringWithFormat:@"小薇驾到，融资有道，在线申请，到账迅速\n%@", shijiAddress];             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"icon_user_photo"];          //分享内嵌图片
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQQ, nil]
                                       delegate:self];
    
    socialIconSheet = [self.navigationController.view viewWithTag:kTagSocialIconActionSheet];
    
//    UIScrollView * scrollview = [socialIconSheet.subviews firstObject];
    
//    for(UIView * btn in scrollview.subviews){
//        if([btn isMemberOfClass:[UIButton class]]){
//            UIButton * button = (UIButton *)btn;
//            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShareButtonClick:)];
//            tapGesture.delegate = self;
//            [button addGestureRecognizer:tapGesture];
//        }
//    }
    
//    NSLog(@"umVIew =%@,%@,%@",socialIconSheet,socialIconSheet.subviews,scrollview.subviews);
}

- (void)onShareButtonClick:(UIGestureRecognizer *)gesture{
    /*
     新浪微博 111
     腾讯微博 112
     qq空间 110
     微信好友 117
     朋友圈 118
     微信收 119
     qq  120
     */
    
    [socialIconSheet dismiss];
    NSString * snsName = UMShareToSina;
    UIButton * shareButton = (UIButton *)gesture.view;
    switch (shareButton.tag) {
        case 111:
            snsName = UMShareToSina;
            break;
            
        case 112:
            snsName = UMShareToTencent;
            break;
            
        case 110:
            snsName = UMShareToQzone;
            break;
            
        case 117:
            snsName = UMShareToWechatSession;
            break;
            
        case 118:
            snsName = UMShareToWechatTimeline;
            break;
            
        case 119:
            snsName = UMShareToWechatFavorite;
            break;
            
        case 120:
            snsName = UMShareToQQ;
            break;
            
        default:
            break;
    }
    
    NSString *shareText = @"小薇驾到，融资有道，在线申请，到账迅速";             //分享内嵌文字
    UIImage *shareImage = nil;
    shareImage = [UIImage imageNamed:@"icon_user_photo"];
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    NSLog(@"reponse =%@",response);
    
    if(response.responseCode == 200 && response.viewControllerType == UMSViewControllerShareEdit){
        delayTime = 3;
        [self activityIndicate:NO tipContent:@"分享成功" MBProgressHUD:nil target:self.tabBarController.view];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    CGPoint location=[[[event allTouches]anyObject]locationInView:webView];
////    [self OnTouchDownResig:location];
//}

-(void)handleSingleTap:(UITapGestureRecognizer *)ptt
{
    CGPoint pt = [ptt locationInView:webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).attributes", pt.x, pt.y];
    NSString *urlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"image url=%@", urlToSave);
    if (urlToSave.length > 0) {
        
    }
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
    self.cancelTimer = nil;
    NSString * currentURL = _webView.request.URL.absoluteString;
    if([currentURL rangeOfString:@"?"].length > 0)
    {
        currentURL = [currentURL substringToIndex:[currentURL rangeOfString:@"?"].location];
    }
    
    NSLog(@"_webView.request.URL.absoluteString =%@,%@,%@",
          _webView.request.URL.absoluteString,
          urlStacks,currentURL);
    
    //        if ([self judgeInWebViewStack:currentURL])
    //        {
    //            [urlStacks removeLastObject];
    //            [webView.layer addAnimation:[SJKHEngine Instance]->leftTransition forKey:nil];
    //        }
    //        else{
    //            [urlStacks addObject:currentURL];
    //            [webView.layer addAnimation:[SJKHEngine Instance]->rightTransition forKey:nil];
    //        }
    
    //
    //        [webView setAlpha:0];
    //        [UIView animateWithDuration:.2f
    //                              delay:0
    //                            options:UIViewAnimationOptionCurveEaseOut
    //                         animations:^{
    //                             [webView setAlpha:1];
    //                         }
    //                         completion:^(BOOL bl){
    //
    //                         }];
    
    [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
}

- (BOOL) judgeInWebViewStack:(NSString *)url{
    BOOL isExist = NO;
    for (NSString * subUrl in urlStacks) {
        if([url isEqualToString:subUrl]){
            isExist = YES;
            break;
        }
    }
    
    return isExist;
}

- (void)cancelWeb{
    if(self.urlConnection){
        self.urlConnection = nil;
        [webView stopLoading];
        self.cancelTimer = nil;
        
        [self activityIndicate:NO tipContent:@"请求超时" MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void) webView: (UIWebView *)_webView didFailLoadWithError: (NSError *)error
{
    NSLog(@"_webView.request.URL.absoluteString ERROR =%@",_webView.request.URL.absoluteString);
    
    self.cancelTimer = nil;
    
    if (error.code == -1001) {
        delayTime = 2;
        [self activityIndicate:NO tipContent:@"请求超时" MBProgressHUD:nil target:self.navigationController.view];
    }
    else {
        //uuid存在代表已登录
        if([SJKHEngine Instance]->uuid){
            delayTime = 2;
            [self activityIndicate:NO tipContent:@"加载出现错误" MBProgressHUD:nil target:self.navigationController.view];
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)_webView
{
    [self activityIndicate:YES tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
}

- (BOOL) webView: (UIWebView *)_webView shouldStartLoadWithRequest: (NSURLRequest *)request navigationType: (UIWebViewNavigationType)navigationType
{
    //在这获取转向的url和链接点击事件。如点击cowork中的附件的click事件。
    NSLog(@"URL loanBase = %@,%@,%@",request.URL,[request allHTTPHeaderFields],[request.URL scheme]);
    
    if([[request.URL absoluteString] hasSuffix:@"timeout.jsp"] ||
       [[request.URL absoluteString] hasSuffix:@"toLogin"] ||
       [[request.URL absoluteString] hasSuffix:@"logout"])
    {
//        [[SJKHEngine Instance] dispatchMessage:XWD_POP_MESSAGE];
        [SJKHEngine Instance]->uuid = nil;
        for (BaseViewController * vc in [SJKHEngine Instance].observeCtrls) {
            if([vc isKindOfClass:[LoanBaseViewCtrl class]]){
                NSRange range = [((LoanBaseViewCtrl *)vc)->webViewURL rangeOfString:@"uuid="];
                if(range.length > 0){
                    int location = range.location;
                    ((LoanBaseViewCtrl *)vc)->webViewURL = [((LoanBaseViewCtrl *)vc)->webViewURL substringToIndex:location+5];
                    NSLog(@"(LoanBaseViewCtrl *)vc)->webViewURL =%@",((LoanBaseViewCtrl *)vc)->webViewURL);
                }
            }
        }
        UINavigationController * naviVC = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
        LoanBaseViewCtrl * loanBaseVC = [naviVC.viewControllers firstObject];
        [(LoanMainViewCtrl *)self.tabBarController onLoadLoginVC:loanBaseVC naviVC:naviVC];
        
        if(hud){
            [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        }
        
        if( [[request.URL absoluteString] hasSuffix:@"logout"]){
            return YES;
        }
        else{
            return NO;
        }
    }
    if([[request.URL absoluteString] hasSuffix:@"/wskh/mobile/xw"]){
        NSURL *url = [[NSURL alloc] initWithString: request.URL.absoluteString];
        [[UIApplication sharedApplication] openURL: url];
        url = nil;
        
        return NO;
    }
    
    self.cancelTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
//    NSLog(@"navigationType =%i", navigationType);
    
	return YES;
}

- (void)toLoadWebPage:(BOOL)toLoad{
    if(toLoad){
        if([[Reachability reachabilityWithHostname:@"www.baidu.com"] currentReachabilityStatus] == NotReachable){
            self.urlConnection = nil;
            [webView stopLoading];
            self.cancelTimer = nil;
            [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
            NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"404" ofType:@"html"];
            NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            [webView loadHTMLString:appHtml baseURL:baseURL];
            
            return ;
        }
        
        [self activityIndicate:YES tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        
        NSURL *url = [NSURL URLWithString: webViewURL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
        
//        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.google.com/"]];
//        NSLog(@"agent =%@",[request valueForHTTPHeaderField:@"User-Agent"]);
        
//        [request setValue: @"iPhone" forHTTPHeaderField: @"User-Agent"]; // Or any other User-Agent value.
        
//        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.google.com/"]];
//        [urlRequest setValue: @"iPhone" forHTTPHeaderField: @"User-Agent"]; // Or any other User-Agent value.
        
//        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
//        [request setValue:@"ApexWebView" forHTTPHeaderField:@"User_Agent"];
        
        NSString * registerString = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; CPU)%i like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/11A466 ApexWebView",[SJKHEngine Instance]->systemVersion];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:registerString, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        
//        if([webViewURL rangeOfString:@"?"].length > 0){
//            [urlStacks addObject:[webViewURL substringToIndex:[webViewURL rangeOfString:@"?"].location]];
//        }
        
        self.urlConnection = nil;
        urlConnection = [NSURLConnection connectionWithRequest: request delegate: self];
//        NSLog(@"urlConnection = %@,%@,%@,%@",urlConnection,request,url,webViewURL);
        
        self.cancelTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
//        [webView loadRequest:request];
    }
    else{
        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        //        webView.delegate = nil;
        //        [webView stopLoading];
    }
}

- (void)toLoadWebPageWithUrl:(NSString *)weburl{
    [self activityIndicate:YES tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
    
    NSURL *url = [NSURL URLWithString: weburl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    NSString * registerString = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; CPU)%i like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/11A466 ApexWebView",[SJKHEngine Instance]->systemVersion];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:registerString, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    self.cancelTimer = nil;
    [webView loadRequest:request];
    
//    urlConnection = [NSURLConnection connectionWithRequest: request delegate: self];
//    cancelTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
}

- (void) connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)response
{
    if ([urlConnection isEqual: connection])
    {
        NSLog(@"curreentrequest =%@",urlConnection.currentRequest);
        [webView loadRequest:urlConnection.currentRequest];
        self.urlConnection = nil;
        
        return;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error 2 = %@",error);
    self.urlConnection = nil;
    
    if(abs(error.code) == 1003){
        [self activityIndicate:NO tipContent:@"域名解析失败" MBProgressHUD:nil target:self.navigationController.view];
    }
    else{
        [self activityIndicate:NO tipContent:[NSString stringWithFormat:@"网络发生错误,错误码:%i",abs(error.code)] MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (BOOL) connection: (NSURLConnection *)connection canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"protectionSpace =%@",protectionSpace);
    return [protectionSpace.authenticationMethod isEqualToString: NSURLAuthenticationMethodServerTrust] ||
    [protectionSpace.authenticationMethod isEqualToString: NSURLAuthenticationMethodClientCertificate] ;
}

- (void) connection: (NSURLConnection *)connection didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
		[challenge.sender useCredential: [NSURLCredential credentialForTrust: challenge.protectionSpace.serverTrust]
			 forAuthenticationChallenge: challenge];
    }
    //为服务器信任客户端所做的操作。只写了代码,待调试
//    else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]){
//        return ;
//        
//        SecIdentityRef * outIdentity = Nil ;
//        SecTrustRef* outTrust = nil;
//        NSData * PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"custom" ofType:@"p12"]];
//        
//        OSStatus securityError = errSecSuccess;
//        CFStringRef password = CFSTR("123456"); //证书密码
//        const void *keys[] =   { kSecImportExportPassphrase };
//        const void *values[] = { password };
//        
//        CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
//        
//        CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
//        securityError = SecPKCS12Import((__bridge CFDataRef)PKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
//        
//        if (securityError == 0) {
//            CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
//            const void *tempIdentity = NULL;
//            tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
//            *outIdentity = (SecIdentityRef)tempIdentity;
//            const void *tempTrust = NULL;
//            tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
//            *outTrust = (SecTrustRef)tempTrust;
//        }
//        
//        //两种方式，看哪种可用。
//        //        SecCertificateRef myCert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)PKCS12Data);
//        SecCertificateRef myCert = nil;
//        SecIdentityCopyCertificate(*outIdentity, &myCert);
//        SecCertificateRef certArray[1] = { myCert };
//        CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
//        CFRelease(myCert);
//        NSURLCredential *credential = [NSURLCredential credentialWithIdentity:*outIdentity
//                                                                 certificates:(__bridge NSArray *)myCerts
//                                                                  persistence:NSURLCredentialPersistencePermanent];
//        CFRelease(myCerts);
//        
//        [challenge.sender useCredential: credential forAuthenticationChallenge: challenge];
//    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge: challenge];
}

- (void)dealloc{
    self.urlConnection = nil;
    webView.delegate = nil;
    [webView stopLoading];
    
    self.cancelTimer = nil;
//    NSLog(@"loadBase回收");
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
