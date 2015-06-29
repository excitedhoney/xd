//
//  LookProcessViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-22.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "LookProcessViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "DepositBankViewCtrl.h"

#define CELLWIDTH IOS7_SYS ? screenWidth : screenWidth - 2*5

@interface LookProcessViewCtrl (){
    UITableView * processTable;
    NSArray * cellNames;
    NSMutableArray * sectionNames;
    NSArray * cellKeys;
    float labelLength ;
    float secSessionLabLen;
    BOOL bKaihuSuccess;
}

@end

@implementation LookProcessViewCtrl

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
    UIButton * btn = self.navigationItem.leftBarButtonItem.customView;
    NSLog(@"customview lookprocess =%@,%@",btn,[btn allTargets]);
    
    if(bFirstShow){
        [self updateUI];
        bFirstShow = NO;
    }
    else {
        [processTable reloadData];
    }
    
    [super viewDidAppear:animated];
}

- (void)InitConfig{
    [self kaitongchaxun];
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.translucent = NO;
    bKeyBoardShow = NO;
    bKaihuSuccess = NO;
    labelLength = [PublicMethod getStringWidth:@"存管银行指定:" font:[UIFont systemFontOfSize:15]] + NormalSpace;
    secSessionLabLen = [PublicMethod getStringWidth:@"深开放式基金帐户:" font:[UIFont systemFontOfSize:15]] + NormalSpace;
    
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    cellNames = [NSArray arrayWithObjects:
                 [NSArray arrayWithObjects:
                  @"姓名",
                  @"身份证号",
                  @"开户进度",
                  @"客户号",
                  @"资金帐号",
                  @"存管银行指定", nil],
                 [NSArray arrayWithObjects:
                  @"上海A股帐户",
                  @"深圳A股帐户",
//                  @"沪开放式基金帐户",
//                  @"深开放式基金帐户",
                  nil], nil];
    cellKeys = [NSArray arrayWithObjects:
               [NSArray arrayWithObjects:
                 @"khxm",
                 @"zjbh",
                 @"statename",
                 @"gtkhh",
                 @"zjzh",
                 @"cgyhzdztsm", nil],
               [NSArray arrayWithObjects:
                [[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDKH_SH"] intValue] == 0 ?
                @"GDKH_SHSH" :
                @"GDDJ_SH",
                [[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDKH_SZ"] intValue] == 0 ?
                @"GDKH_SZSZ":
                @"GDDJ_SZ",
//                [[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDDJ_SJ"] intValue] == 0 ?
//                @"GDKH_SJSZ" :
//                @"GDDJ_SJ",
//                [[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDKH_HJ"] intValue] == 0 ?
//                @"GDKH_HJSH" :
//                @"GDDJ_HJ",
                 nil],
                nil];
    
    NSString * imageName = @"newkhjd_1";
    NSString * headerStr = @"   您的开户申请正在审核中,审核结果将以短信的结果通知您.若审核通过,您也可通过马上开户的手机号登录查询相关开通的帐户";
    if([[khbdInfo objectForKey:GTKHH_KHBD]intValue] == 0){
//        imageName = @"newkhjd_1";
        headerStr = @"   您的开户申请正在审核中,审核结果将以短信的结果通知您.若审核通过,您也可通过马上开户的手机号登录查询相关开通的帐户";
    }
    else{
//        imageName = @"newkhjd_2";
        headerStr = @"恭喜,您已经开户成功";
    }
//    UIButton * backButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:FigureButtonTag + 1];
//    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    sectionNames = [NSMutableArray arrayWithObjects:headerStr, @"   股东帐户",nil];
}

- (void)kaitongchaxun{
    [self activityIndicate:YES tipContent:@"正在查询进度..." MBProgressHUD:nil target:self.navigationController.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,KHZTCX];
        ASIFormDataRequest * theRequest = [self createASIRequest:urlComponent];
        
        [theRequest setPostValue:[SJKHEngine Instance]->SJHM
                          forKey:@"sj"];
        [theRequest startSynchronous];
        
        if([self parseResponseData:theRequest]){
            [self activityIndicate:NO tipContent:@"查询成功" MBProgressHUD:nil target:self.navigationController.view];
        }
        else{
            [self activityIndicate:NO tipContent:@"查询失败" MBProgressHUD:nil target:self.navigationController.view];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [processTable reloadData];
        });
    });
}

- (void)InitWidgets{
    processTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , screenWidth , screenHeight - UpHeight) style:UITableViewStyleGrouped];
    processTable.delegate = self;
    processTable.dataSource = self;
    [processTable setShowsVerticalScrollIndicator:NO];
    UIView * vi = [[UIView alloc]init];
    [vi setBackgroundColor:[UIColor whiteColor]];
    processTable.backgroundView = vi;
    
    UIButton * refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ButtonHeight, ButtonHeight)];
    [refreshButton setImage:[UIImage imageNamed:@"newicon_refresh"] forState:UIControlStateNormal];
    [refreshButton setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [refreshButton addTarget:self action:@selector(refreshBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * refreshBtn = [[UIBarButtonItem alloc]initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = refreshBtn;
    
    [self.view addSubview:processTable];
}

- (void)refreshBtnClicked:(UIBarButtonItem *)btn{
    [self kaitongchaxun];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (YEorNO *)parseResponseData:(ASIFormDataRequest *)theRequest{
    if(theRequest.responseData){
        NSDictionary *dic = nil;
        dic = [NSJSONSerialization JSONObjectWithData:theRequest.responseData options:NSJSONReadingMutableContainers error:Nil];
        NSString * tip = nil;
//        NSString *testSTR = [dic objectForKey:NOTE];
        if([dic objectForKey:NOTE]){
//            tip = [PublicMethod getNSStringFromCstring:[[dic objectForKey:NOTE] UTF8String]];
        }
        if(dic && [[dic objectForKey:SUCCESS] intValue] == 1){
            [SJKHEngine Instance]->khjd_Dic = [dic mutableCopy];
            
            cellKeys = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:
                         @"khxm",
                         @"zjbh",
                         @"statename",
                         @"gtkhh",
                         @"zjzh",
                         @"cgyhzdztsm", nil],
                        [NSArray arrayWithObjects:
                         [[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDKH_SH"] intValue] == 0 ?
                         @"GDKH_SHSH" :
                         @"GDDJ_SH",
                         [[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDKH_SZ"] intValue] == 0 ?
                         @"GDKH_SZSZ":
                         @"GDDJ_SZ",
//                         [[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDDJ_SJ"] intValue] == 0 ?
//                         @"GDKH_SJSZ" :
//                         @"GDDJ_SJ",
//                         [[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDKH_HJ"] intValue] == 0 ?
//                         @"GDKH_HJSH" :
//                         @"GDDJ_HJ",
                         nil],
                        nil];
            
            if (((NSString *)[dic objectForKey:@"cgyhzdzt"]).intValue < 0) {
                [SJKHEngine Instance]-> zhidingstate = yep;
            }
            else{
                [SJKHEngine Instance]-> zhidingstate = nop;
            }
            
            if ([[dic objectForKey:@"zdsx_sh"] isEqualToString:@"0"])
            {
                shstate = yep;
            }
            else{
                shstate = nop;
            }
            
            if([[dic objectForKey:@"gtkhh"]intValue] != 0){
                bKaihuSuccess = YES;
                [sectionNames replaceObjectAtIndex:0 withObject:@"恭喜,您已经开户成功"];
            }
            
//            bKaihuSuccess = YES;
//            [sectionNames replaceObjectAtIndex:0 withObject:@"恭喜,您已经开户成功"];
            
//            NSLog(@" zhidingstate = %d, shstate = %d,%@",[SJKHEngine Instance]-> zhidingstate,shstate,[dic objectForKey:@"zdsx_sh"]);
//            NSLog(@"[SJKHEngine Instance]->khjd_Dic = %@",[SJKHEngine Instance]->khjd_Dic);
            
            return yep;
        }
        else{
            return nop;
        }
    }
    return nop;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = ((NSArray *)[cellNames objectAtIndex:section]).count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    float labelWidth = secSessionLabLen ;
    
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
    int section = indexPath.section;
    
    NSString * cellName = [NSString stringWithFormat:@"%@",[[cellNames objectAtIndex:section] objectAtIndex:row]];
    UILabel *leftLabel = [PublicMethod initLabelWithFrame:CGRectMake(0, 0, labelWidth, ButtonHeight) title:cellName target:cell.contentView];
    leftLabel.font = [UIFont systemFontOfSize: 15];
    [leftLabel setTextAlignment:UITextAlignmentRight];
    leftLabel.textColor = WARN_TITLE_COLOR;
    cellName = [NSString stringWithFormat:@"%@", [[SJKHEngine Instance]->khjd_Dic objectForKey:[[cellKeys objectAtIndex:section] objectAtIndex:row]]];
    
    if ([cellName isEqualToString:@"(null)"] || [cellName isEqualToString:@"0"]) {
        cellName = @"";
    }
    
//    if (row == 5 && section == 0) {
//        cellName = @"qwepfiqwefiapwefjpq中西医宽松宽大你扩大茜中华人民共和国你我和你，心连心";
//    }
  //  NSLog(@"cellIWdth =%f",CELLWIDTH);
    
    float widgetWidth = (CELLWIDTH) - labelWidth - NormalSpace * 4;
    
    float height = 0;
    if(cellName.length > 0){
        height = [super getHeightForHeaderString:cellName size:CGSizeMake(widgetWidth , CGFLOAT_MAX)];
    }
    
    leftLabel = [PublicMethod initLabelWithFrame:CGRectMake(labelWidth + NormalSpace*2, 0 , widgetWidth , height)
                                           title:cellName
                                          target:cell.contentView];
//    [leftLabel setBackgroundColor:[UIColor redColor]];
    
    if(height < ButtonHeight){
        [leftLabel setFrame:CGRectMake(leftLabel.frame.origin.x,
                                      leftLabel.frame.origin.y,
                                      leftLabel.frame.size.width,
                                      ButtonHeight)];
    }
    
    [leftLabel setTextAlignment:UITextAlignmentLeft];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.textColor = [UIColor blackColor];
    leftLabel.numberOfLines = 0;
    leftLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    if (indexPath.section == 0 && indexPath.row == 5) {
        if ([SJKHEngine Instance]-> zhidingstate) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1011;
            btn.frame = CGRectMake(leftLabel.frame.origin.x,
                                   cellName.length > 0? leftLabel.frame.size.height : 0 ,
                                   widgetWidth,
                                   ButtonHeight);
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"重新指定" forState:UIControlStateNormal];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:[UIColor colorWithRed:239.0/255 green:65.0/255 blue:86.0/255 alpha:1] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
        }
    }
    if (indexPath.section && indexPath.row == 0) {
        if (shstate) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1012;
            btn.frame = CGRectMake(leftLabel.frame.origin.x,
                                  cellName.length > 0? leftLabel.frame.size.height : 0,
                                  widgetWidth,
                                  ButtonHeight);
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"重新指定" forState:UIControlStateNormal];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.backgroundColor = [UIColor clearColor];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [btn setTitleColor:[UIColor colorWithRed:239.0/255 green:65.0/255 blue:86.0/255 alpha:1] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)btnClicked:(UIButton *)btn{
    if (btn.tag == 1011) {
        DepositBankViewCtrl *bankVC= [[DepositBankViewCtrl alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self dispatchBankVC:bankVC];
        });
    }
    else if (btn.tag == 1012){
        [self activityIndicate:YES tipContent:@"正在重新指定股东帐号" MBProgressHUD:nil target:self.navigationController.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self pointToCount];
        });
    }
}

//重新指定股东号
- (void)pointToCount{
    YEorNO resault = nop;
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,REPOINTCOUNT];
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:URL];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    NSLog(@"kdh gdh = %@,%@",[[SJKHEngine Instance]->khjd_Dic objectForKey:@"gtkhh"],[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDDJ_SH"]);
    [theRequest setPostValue:[[SJKHEngine Instance]->khjd_Dic objectForKey:@"gtkhh"] forKey:@"khh"];
    //GDDJ_SH 股东登记上海
    [theRequest setPostValue:[[SJKHEngine Instance]->khjd_Dic objectForKey:@"GDDJ_SH"] forKey:@"gdh"];
    
//    [theRequest setPostValue:@"123" forKey:@"khh"];
//    [theRequest setPostValue:@"222" forKey:@"gdh"];
    
    [theRequest startSynchronous];
    NSDictionary *responseDic;
    resault = [self parseResponseData:theRequest dic:&responseDic];
    if (resault) {
        [self activityIndicate:NO tipContent:@"重新指定股东帐号成功" MBProgressHUD:nil target:self.navigationController.view];
    }
    else{
        NSLog(@"*stepDic =%@",responseDic);
        
        NSString * tip = @"新指定股东帐号失败";
        if([responseDic objectForKey:NOTE]){
            tip = [responseDic objectForKey:NOTE];
        }
        [self activityIndicate:NO tipContent:tip MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void)dispatchBankVC:(DepositBankViewCtrl *)bankVC{
    NSDictionary * stepDictionary = nil;
    if([self sendSaveCurrentStepKey:CGZD_STEP dataDictionary:&stepDictionary]){
        BOOL ok = [self sendGoToStep:CGZD_STEP dataDictionary:&stepDictionary];
        if(ok){
            [SJKHEngine Instance]->cgzd_step_Dic = [stepDictionary mutableCopy];
            bankVC->filterArray = [NSMutableArray array];
            for (NSDictionary * yhDic in [[SJKHEngine Instance]->cgzd_step_Dic objectForKey:CGYHARR_CGYH]) {
                [bankVC->filterArray addObject:[yhDic objectForKey:YHMC_CGYH]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                bankVC->bIsRepointPage = YES;
                [self.navigationController pushViewController:bankVC animated:YES];
            });
        }
        else {
            [self activityIndicate:NO tipContent:@"加载存管银行页面失败" MBProgressHUD:nil target:self.navigationController.view];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float labelWidth = secSessionLabLen;
    NSString * cellName = [NSString stringWithFormat:@"%@", [[SJKHEngine Instance]->khjd_Dic objectForKey:[[cellKeys objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
    if ([cellName isEqualToString:@"(null)"] || [cellName isEqualToString:@"0"]) {
        cellName = @"";
    }
    
    float widgetWidth = (CELLWIDTH) - labelWidth - NormalSpace * 5;
    
    float height = 0;
    if(cellName.length > 0){
        height = [super getHeightForHeaderString:cellName size:CGSizeMake(widgetWidth , CGFLOAT_MAX)];
    }
    
    if (indexPath.section == 0 && indexPath.row == 5) {
        if ([SJKHEngine Instance]-> zhidingstate) {
            return height + ButtonHeight;
        }
    }
    if(indexPath.section == 1 && indexPath.row == 0) {
        if(shstate){
            return height + ButtonHeight;
        }
    }
    if(height == 0 || height < ButtonHeight){
        return ButtonHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    NSString * title = [NSString stringWithFormat:@"%@",[sectionNames objectAtIndex:section]];
//    [PublicMethod trimSpecialCharacters:&title];
//    CGSize size = [PublicMethod getStringSize:title font:TipFont];
//    int numberLines = size.width / processTable.frame.size.width;
//    NSLog(@"section 0=%i,%@,%i",section,title,numberLines);
//    return 60 * (numberLines + 1);
    
    if(bKaihuSuccess && section == 0){
        return ButtonHeight + 15;
    }
    return [super getHeightForHeaderString:[sectionNames objectAtIndex:section] size:CGSizeMake(screenWidth , CGFLOAT_MAX)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [headerButton setBackgroundColor:LikeWhiteColor];
    NSString * title = [sectionNames objectAtIndex:section];
    [PublicMethod trimSpecialCharacters:&title];
    CGSize size = [PublicMethod getStringSize:title font:[UIFont boldSystemFontOfSize:17]];
    int numberLines = size.width / processTable.frame.size.width;
    
    [headerButton setFrame:CGRectMake(0, levelSpace, screenWidth - 2 * levelSpace,[super getHeightForHeaderString:[sectionNames objectAtIndex:section] size:CGSizeMake(screenWidth - 2 * levelSpace , CGFLOAT_MAX)])];
    [headerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    headerButton.titleLabel.numberOfLines = numberLines + 1;
    headerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    headerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerButton setTitle:title forState:UIControlStateNormal];
    [headerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, NormalSpace, 0, NormalSpace)];
    [headerButton setTitleColor:WARN_TITLE_COLOR forState:UIControlStateNormal];
    
    if(bKaihuSuccess && section == 0){
        headerButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [headerButton setTitleColor:[UIColor colorWithRed:77.0/255 green:181.0/255 blue:1.0/255 alpha:1] forState:UIControlStateNormal];
        headerButton.frame = CGRectMake(headerButton.frame.origin.x,
                                        headerButton.frame.origin.y,
                                        headerButton.frame.size.width,
                                        headerButton.frame.size.height + 20);
        [headerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    
    return headerButton;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [sectionNames objectAtIndex:section];
}

- (void)updateUI{
    [super updateUI];
    
    if(!self.isViewLoaded){
        return ;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(processTable.superview == nil){
            [self.view addSubview:processTable];
        }
        else {
            [processTable reloadData];
        }
    });
    
//    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:0];
//    NSArray *ar = [NSArray arrayWithObjects:set, nil];
//    [processTable insertSections:set withRowAnimation:UITableViewRowAnimationTop];
    
//    if(isInsert){
//        [filterArray addObject:@"交易密码"];
//        [table_view insertRowsAtIndexPaths:ar withRowAnimation:UITableViewRowAnimationTop];
//    }
//    else{
//        [filterArray removeObjectAtIndex:1];
//        [table_view deleteRowsAtIndexPaths:ar withRowAnimation:UITableViewRowAnimationBottom];
//    }
    
//    UIButton * headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [headerButton setBackgroundColor:LikeWhiteColor];
//    NSString * title = [sectionNames objectAtIndex:0];
//    [PublicMethod trimSpecialCharacters:&title];
//    CGSize size = [PublicMethod getStringSize:title font:PublicBoldFont];
//    int numberLines = size.width / processTable.frame.size.width;
//
//    [headerButton setFrame:CGRectMake(0, levelSpace, processTable.frame.size.width, 50 *(numberLines + 1))];
//    [headerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    headerButton.titleLabel.numberOfLines = numberLines + 1;
//    headerButton.titleLabel.font = PublicBoldFont;
//    headerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [headerButton setTitle:title forState:UIControlStateNormal];
//    [headerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    processTable.tableHeaderView = headerButton;
}

- (void)popToLastPage{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    [[SJKHEngine Instance]->rootVC vcOperation:nil];
//    [super popToLastPage];
    
    [[SJKHEngine Instance] backToKaiHuLoginVCAndDealloc];
}

- (void)dealloc{
    [khbdInfo removeAllObjects];
    khbdInfo = nil;
    processTable = nil;
    cellNames = nil;
    cellKeys = nil;
    [sectionNames removeAllObjects];
    sectionNames = nil;
    
    NSLog(@"进度页面回收");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
