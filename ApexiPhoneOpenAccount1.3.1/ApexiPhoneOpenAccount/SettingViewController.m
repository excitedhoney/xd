//
//  SettingViewController.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-4-22.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "SettingViewController.h"
#import "Data_Structure.h"
#import "SJKHEngine.h"
#import "UIImage+custom_.h"
#import "FirstPageViewCtrl.h"
#import "CreditViewCtrl.h"
#import "RepayMentViewCtrl.h"
#import "MemberMessageViewCtrl.h"

typedef struct
{
    int        type;                       // 设置类型
    const char *     title;              // 设置标题
    int        tag;                        // 控件标签
} Cell_Data;

typedef enum
{
    IS_UISWITCH                    = 22,
    IS_UITEXTFIELD                     = 23
} Widget_Type;

@interface SettingViewController (){
    UITableView * settignTable;
    NSMutableArray * widgetDatas;
    int buttonTag ;
    UMSocialIconActionSheet * socialIconSheet;
//    vector
}

@end

@implementation SettingViewController

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
    
    [self InitSet];
    [self InitWidget];
}

- (void)InitSet{
    widgetDatas = [NSMutableArray array];
    buttonTag = 0;
    
//    Cell_Data _cellData;
//    _cellData.type = IS_UISWITCH;
//    _cellData.title = [[NSString stringWithFormat:@"%@",@"是否是https"] UTF8String];
//    _cellData.tag = 0;
    
    //是否是https
    [widgetDatas addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:IS_UISWITCH],@"是否是https",[NSNumber numberWithInt: buttonTag++], nil]];
    [widgetDatas addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:IS_UITEXTFIELD],@"ip地址",[NSNumber numberWithInt: buttonTag++], nil]];
    [widgetDatas addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:IS_UITEXTFIELD],@"端口",[NSNumber numberWithInt: buttonTag++], nil]];
    
//    [widgetDatas addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:IS_UITEXTFIELD],@"",buttonTag++, nil]];
//    [widgetDatas addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:IS_UITEXTFIELD],@"ip地址",buttonTag++, nil]];
//    [widgetDatas addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:IS_UITEXTFIELD],@"ip地址",buttonTag++, nil]];
//    [widgetDatas addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:IS_UITEXTFIELD],@"ip地址",buttonTag++, nil]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    NSString * localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
    [self activityIndicate:NO tipContent:[NSString stringWithFormat:@"当前版本:%@",localVersion] MBProgressHUD:nil target:self.navigationController.view];
}

- (void)InitWidget{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(Done:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    settignTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, screenWidth , self.view.frame.size.height - 160) style:UITableViewStyleGrouped];
    settignTable.dataSource = self;
    settignTable.delegate = self;
    
    UIButton *jian = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [jian setTitle:@"测试分享" forState:UIControlStateNormal];
    [jian addTarget:self action:@selector(onTestClick:) forControlEvents:UIControlEventTouchUpInside];
    [jian setFrame:CGRectMake(10, self.view.frame.size.height - 100, 120, 50)];
    [self.view addSubview:jian];
    
    [self.view addSubview:settignTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    NSLog(@"reponse =%@",response);
    
    if(response.responseCode == 200 && response.viewControllerType == UMSViewControllerShareEdit){
        delayTime = 3;
        [self activityIndicate:NO tipContent:@"分享成功" MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void)onTestClick:(UIButton *)sender{
    NSString *shareText = @"顶点软件测试分享平台所用文字,来源:lyh,用处,瞎拼的";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"point"];          //分享内嵌图片
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQQ, nil]
                                       delegate:self];
    
    socialIconSheet = [self.navigationController.view viewWithTag:kTagSocialIconActionSheet];
    
    UIScrollView * scrollview = [socialIconSheet.subviews firstObject];
    
    for(UIView * btn in scrollview.subviews){
        if([btn isMemberOfClass:[UIButton class]]){
            UIButton * button = (UIButton *)btn;
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShareButtonClick:)];
            tapGesture.delegate = self;
            [button addGestureRecognizer:tapGesture];
        }
    }
    
    NSLog(@"umVIew =%@,%@,%@",socialIconSheet,socialIconSheet.subviews,scrollview.subviews);
}

- (void)onShareButtonClick:(UIGestureRecognizer *)gesture{
//    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"发送分享消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertview.delegate = self;
//    [alertview show];
    
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
    
    NSString *shareText = @"顶点软件测试分享平台所用文字,来源:lyh,用处,瞎拼的";             //分享内嵌文字
    UIImage *shareImage = nil;
//    if([snsName isEqualToString:UMShareToQzone]){
//        shareImage = [UIImage imageNamed:@"Icon"];
//    }
    shareImage = [UIImage imageNamed:@"Icon114"];
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

- (void)Done:(UIButton *)btn{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return widgetDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ButtonHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"tableViewCellIdentify";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    for (UIView * vi in cell.contentView.subviews) {
        [vi removeFromSuperview];
    }
    
    int row = indexPath.row;
//    int section = indexPath.section;
    
    NSArray * cellData = [widgetDatas objectAtIndex:row];
    [self initCellContentView:[[cellData objectAtIndex:0] intValue]
                   targetView:cell.contentView
                      tipText:[cellData objectAtIndex:1]
                          tag:[[cellData objectAtIndex:2] intValue]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)initCellContentView:(Widget_Type)type targetView:(UIView *)superView tipText:(NSString *)tipText tag:(int)tag{
    CGRect rectLeftPart = CGRectMake (10, 10, 120, 20);
	CGRect rectRightPart = CGRectMake (100, 2, 170, 40);
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    CGRect rec= CGRectMake (235, 7, 100, 26);

    switch (type) {
        case IS_UISWITCH:{
            UILabel *domainLabel = [[UILabel alloc] initWithFrame: rectLeftPart];
            domainLabel.backgroundColor = [UIColor clearColor];
            [domainLabel setFont: font];
            [domainLabel setText: tipText];
            [domainLabel setTextColor: [UIColor grayColor]];
            [domainLabel setTextAlignment: UITextAlignmentLeft];
            [superView addSubview: domainLabel];
            
            UISwitch * rightSwitch = [[UISwitch alloc] initWithFrame:rec];
            rightSwitch.on = [SJKHEngine Instance]->isHttps;
            [rightSwitch addTarget:self action:@selector(OnTouchBegin:) forControlEvents:UIControlEventValueChanged];
            [superView addSubview: rightSwitch];
        }
            break;
            
        case IS_UITEXTFIELD:{
            UILabel *domainLabel = [[UILabel alloc] initWithFrame: rectLeftPart];
            domainLabel.backgroundColor = [UIColor clearColor];
            [domainLabel setFont: font];
            [domainLabel setText: tipText];
            [domainLabel setTextColor: [UIColor grayColor]];
            [domainLabel setTextAlignment: UITextAlignmentLeft];
            [superView addSubview: domainLabel];
            
            UITextField *domainEditor = [[UITextField alloc] initWithFrame: CGRectMake(rectRightPart.origin.x-20, rectRightPart.origin.y, rectRightPart.size.width+20, rectRightPart.size.height)];
            domainEditor.backgroundColor = [UIColor clearColor];
            domainEditor.tag = tag;
            domainEditor.borderStyle = UITextBorderStyleRoundedRect;
            domainEditor.keyboardType = UIKeyboardTypeDefault;
            domainEditor.clearButtonMode = UITextFieldViewModeWhileEditing;
            [domainEditor setTextAlignment:UITextAlignmentRight];
            [domainEditor setFont: font];
            [domainEditor setTextColor: [UIColor darkGrayColor]];
            [domainEditor addTarget: self action: @selector(OnTouchBegin:) forControlEvents: UIControlEventEditingDidEnd];
            
            NSString * editorText = nil;
            if(tag == 1){
                editorText = [SJKHEngine Instance]->doMain;
            }
            if(tag == 2){
                editorText = [NSString stringWithFormat:@"%@",[SJKHEngine Instance]->port];
            }
            domainEditor.text = editorText;
            
            [superView addSubview: domainEditor];
        }
            break;
            
        default:
            break;
    }
}

- (void)OnTouchBegin:(UIView *)vi{
    switch (vi.tag) {
        case 0:
            [SJKHEngine Instance]->isHttps = ((UISwitch *)vi).isOn;
            break;
            
        case 1:{
            UITextField * textfield = (UITextField *)vi;
            NSString * text = textfield.text;
            [PublicMethod trimText:&text];
            [SJKHEngine Instance]->doMain = text;
        }
            break;
            
        case 2:{
            UITextField * textfield = (UITextField *)vi;
            NSString * text = textfield.text;
            [PublicMethod trimText:&text];
            [SJKHEngine Instance]->port = text;
        }
            break;
        default:
            break;
    }
    
    NSLog(@"[SJKHEngine Instance].observeCtrls =%@,%@,%@",[SJKHEngine Instance].observeCtrls,[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port);
    for (BaseViewController * vc in [SJKHEngine Instance].observeCtrls) {
        if ([vc isMemberOfClass:[FirstPageViewCtrl class]]) {
            ((LoanBaseViewCtrl *)vc)->webViewURL = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/welcome/sy", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port];
        }
        if ([vc isMemberOfClass:[CreditViewCtrl class]]) {
            ((LoanBaseViewCtrl *)vc)->webViewURL = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/jk/jk?uuid=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid];
        }
        if ([vc isMemberOfClass:[RepayMentViewCtrl class]]) {
            ((LoanBaseViewCtrl *)vc)->webViewURL = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/hk/wdjk?uuid=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid];
        }
        if ([vc isMemberOfClass:[MemberMessageViewCtrl class]]) {
            ((LoanBaseViewCtrl *)vc)->webViewURL = [NSString stringWithFormat:@"%@://%@%@/xwd/mobile/user/me?uuid=%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,[SJKHEngine Instance]->uuid];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
