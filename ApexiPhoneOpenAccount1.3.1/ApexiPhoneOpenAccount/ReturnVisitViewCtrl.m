//
//  ReturnVisitViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-13.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "ReturnVisitViewCtrl.h"
#import "RootModelViewCtrl.h"
#import "LookProcessViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"


typedef struct
{
    int        hfwjid;                     // 回访问卷id
    const char *     hftmdac;              // 回访题目答案串
    int        hfjg;                       // 回访结果
} Hfwj_Form_Data;


@interface ReturnVisitViewCtrl (){
    Hfwj_Form_Data hfwjFormData;;
    UILabel * tipLabel;
    LookProcessViewCtrl * lookVC;
    UIButton * nextBtn;
    NSArray * titleTips;
    UIView * totalView;
}

@end

@implementation ReturnVisitViewCtrl

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

- (void)viewWillAppear:(BOOL)animated{
    UIButton * btn = self.navigationItem.leftBarButtonItem.customView;
    NSLog(@"customview returnVisit =%@,%@",btn,[btn allTargets]);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    if(bFirstShow){
        [self updateUI];
        bFirstShow = NO;
    }
    [super viewDidAppear:animated];
}

- (void) InitConfig{
    [super InitConfig];
    titleTips = [NSArray arrayWithObjects:
                 @"如非本人意愿,请办理注销手续",
                 @"请您妥善保管好您的帐户相关密码,不要轻易告知别人,防止密码外泄为您带来风险",
                 @"请仔细阅读后选择'是'",
                 @"请本人立刻修改密码后重新选择'是'",
                 @"网上开户必须由本人亲自办理",
                 nil];
    
}

- (void) InitWidgets{
    [super InitWidgets];
    
    //    [tipLabel setText:@""];
    //    [tipLabel setText:@"请您完成以下回访问卷,马上就要完成了哦"];
    //    [tipLabel setNeedsDisplay];
    
//    int labelHeight = 40;
    //    tableHeight = screenHeight - UpHeight - 2 * verticalHeight - 44 - 2*verticalHeight - verticalHeight;
    //    tipLabel = [PublicMethod initLabelWithFrame:CGRectMake(levelSpace, 0, screenWidth - levelSpace, labelHeight)
    //                                                      title:@"请您完成以下回访问卷,马上就要完成了哦"
    //                                                     target:self.view];
    tip.frame = CGRectMake(tip.frame.origin.x,
                           ButtonHeight,
                           tip.frame.size.width,
                           ButtonHeight);
    [tip setText:@"请您完成以下回访问卷,马上就要完成了哦~"];
    tip.font = [UIFont boldSystemFontOfSize:16];
    
    tableHeight = screenHeight - UpHeight - ButtonHeight * 2 - verticalHeight - ButtonHeight ;
    rootImageView.frame = CGRectMake(levelSpace,
                                     ButtonHeight * 2 ,
                                     screenWidth - levelSpace*2,
                                     screenHeight - UpHeight - ButtonHeight * 2 - verticalHeight - ButtonHeight );
    table_view.frame = CGRectMake(table_view.frame.origin.x,
                                  table_view.frame.origin.y,
                                  table_view.frame.size.width,
                                  tableHeight - 2*verticalHeight + 4);
    table_view.delegate = self;
    table_view.dataSource = self;
    
    //    [rootView setFrame: CGRectMake(levelSpace,
    //                                                            0 ,
    //                                                            screenWidth - levelSpace*2,
    //                                                            tableHeight)];
    //    [rootView setAlpha:1];
    
    //    [rootView setBackgroundColor:[UIColor redColor]];
    
    //    [table_view setFrame:CGRectMake(0, 0 , screenWidth - levelSpace*2, tableHeight - verticalHeight)];
    //    [rootImageView setUserInteractionEnabled:YES];
    //    [rootImageView bringSubviewToFront:table_view];
    
    //    [nextStepBtn removeFromSuperview];
    //    [self.view addSubview:nextStepBtn];
    
    //    [nextStepBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextStepBtn removeFromSuperview];
    nextStepBtn = nil;
    [self InitNextStepButton:CGRectMake (levelSpace,
                                         screenHeight - UpHeight - verticalHeight - ButtonHeight,
                                         screenWidth - 2 * levelSpace,
                                         44)
                         tag:0
                       title:@"提交"];
    [self.view addSubview:nextStepBtn];
    
    //    [nextStepBtn setTitle:@"提交" forState:UIControlStateNormal];
}

- (void)createResultView{
    totalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - UpHeight)];
    [totalView setBackgroundColor:PAGE_BG_COLOR];
    
    //    [self.view setBackgroundColor:PAGE_BG_COLOR];
    
    resultView = [[UIView alloc]initWithFrame:CGRectMake(levelSpace ,
                                                         ButtonHeight + verticalHeight ,
                                                         screenWidth - 2*levelSpace ,
                                                         150)];
    [resultView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    [PublicMethod publicCornerBorderStyle:resultView];
    [resultView setAlpha:0];
    
    UIButton * headerFlowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerFlowButton setFrame:CGRectMake(0, 0 , screenWidth, ButtonHeight)];
    headerFlowButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headerFlowButton setImage:[UIImage imageNamed:@"flow_4"]
                      forState:UIControlStateNormal];
    [headerFlowButton setUserInteractionEnabled:NO];
    
    [totalView addSubview:headerFlowButton];
    
    NSString * title = @"恭喜,您的申请已提交";
    UIFont * font = [UIFont boldSystemFontOfSize:25];
    float titleWidth = [PublicMethod getStringWidth:title font:font] + 50;
    float space = (screenWidth - 2*levelSpace - titleWidth)/2.0;
    UIButton * selectButton = [PublicMethod InitSelectTitle:title
                                                  withFrame:
                               CGRectMake(space,
                                          verticalHeight,
                                          titleWidth,
                                          50)
                                                        tag:0
                                                     target:resultView];
    UIButton *markButton = ((UIButton *)[selectButton viewWithTag:SelectBtnTag]);
    [markButton setBackgroundImage:[UIImage imageNamed:@"icon_success"] forState:UIControlStateNormal];
    [markButton setFrame:CGRectMake(0, 0 , 50, 50)];
    [selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    selectButton.titleLabel.font = font;
    [resultView addSubview:selectButton];
    
    title = @"您的开户申请正在审核中，审核结果将以短信的方式通知您。您也可以通过开户的手机号重新登陆后查询开户进度或账户相关信息";
    UILabel * localtipLabel = [PublicMethod initLabelWithFrame:CGRectMake(levelSpace*2, verticalHeight + 50 , resultView.frame.size.width - 4*levelSpace, 80)
                                                         title:title
                                                        target:resultView];
    localtipLabel.font = [UIFont boldSystemFontOfSize:16];
    localtipLabel.textAlignment = NSTextAlignmentCenter;
    localtipLabel.numberOfLines = 0;
    
    //    [PublicMethod CreateButton:@"提交" withFrame:)
    //                           tag:1 target:totalView];
    
    nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(levelSpace,
                                                        resultView.frame.origin.y + verticalHeight + resultView.frame.size.height,
                                                        screenWidth - 2* levelSpace,
                                                        50)];
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    UIColor * color = [UIColor colorWithRed:255.0/255 green:71.0/255 blue:96.0/255 alpha:1];
    //    [PublicMethod publicCornerBorderStyle:nextBtn];
    //    nextBtn.layer.borderColor = color.CGColor;
    //    [nextBtn setBackgroundColor:color];
    //    nextBtn.layer.cornerRadius=4;
    //    nextBtn.layer.masksToBounds=YES;
    UIImage * kaihuImage = [UIImage imageNamed: [NSString stringWithFormat:@"button_gray_default"]];
    kaihuImage = [kaihuImage stretchableImageWithLeftCapWidth: 8 topCapHeight: 8];
    [nextBtn setBackgroundImage:kaihuImage forState:UIControlStateNormal];
    [nextBtn addTarget: self action: @selector(onBackRootVCMessage) forControlEvents: UIControlEventTouchUpInside];
    [nextBtn setTitle:@"返 回" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [nextBtn setTitleColor:WARN_TITLE_COLOR forState:UIControlStateHighlighted];
    [nextBtn setHidden:YES];
    [totalView addSubview:nextBtn];
    
    [totalView addSubview:resultView];
    
    [totalView setAlpha:0];
    [self.view addSubview:totalView];
}

- (void)onBackRootVCMessage{
    //    [self.navigationController popToViewController:[SJKHEngine Instance]->rootVC animated:YES];
    //
    //    [[SJKHEngine Instance]->rootVC vcOperation:nil];
    
    [[SJKHEngine Instance] backToKaiHuLoginVCAndDealloc];
}

- (void) onButtonClick:(UIButton *)btn{
    //    [rootImageView setHidden:YES];
    //    [table_view setHidden:YES];
    //    sleep(3);
    //    [table_view setAlpha:0];
    //    [rootImageView setAlpha:0];
    //    [self.view setNeedsDisplay];
    //    [self createResultView];
    //    sleep(3);
    //    [resultView setHidden:YES];
    //    [super hiddenMainView];
    NSLog(@"root table=%@,%@",rootImageView,table_view);
    
    //    [super onButtonClick:nil];
    
    if(resultView.alpha == 0){
        int section = [self caculateVC];
        if (section == -1) {
            [self createResultView];
        }
        else{
            NSString * titles =[NSString stringWithFormat:@"请答完第%i题",section + 1];
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:titles delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            
            return ;
        }
        
        int wrongSection = [self onJudgePreAnswer:(table_view.numberOfSections - 1)];
        if(wrongSection != -1){
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"为了您的开户顺利完成,请您在第%i题上选择'是'",wrongSection + 1] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            
            return ;
        }
        
        __block NSDictionary * dic = nil;
        
        if([self saveHFWJData]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self activityIndicate:YES tipContent:@"提交申请..." MBProgressHUD:nil target:self.navigationController.view];
                [self toSendLastCommit:[[SJKHEngine Instance] getKhzdString] dataDictionary:&dic];
            });
        }
        
        return ;
    }
    
    [self toSendQueryKHXX];
}

- (int)onJudgePreAnswer:(int)section{
    NSMutableArray * ar = nil;
    int wrongSection = -1;
    
    for (int i = 0; i <= section ;i++ ) {
        ar = [cellConditioins objectAtIndex:i];
        if([[ar objectAtIndex:1] intValue] == 1){
            wrongSection = i;
            break;
        }
    }
    
    return wrongSection;
}

- (void) tipRequestAccountSuccess{
    //    [self.navigationItem.leftBarButtonItem.customView setHidden:YES];
    [SJKHEngine Instance]->bLastCommitSuccess = YES;
    //    [rootImageView removeFromSuperview];
    [self activityIndicate:NO tipContent:@"提交申请成功" MBProgressHUD:nil target:self.navigationController.view];
    
    [nextStepBtn setTitle:@"开户进度跟踪" forState:UIControlStateNormal];
    nextStepBtn.frame = CGRectMake(nextStepBtn.frame.origin.x,
                                   resultView.frame.origin.y + resultView.frame.size.height + verticalHeight,
                                   screenWidth - 2 * levelSpace,
                                   ButtonHeight);
    [nextBtn setHidden:NO];
    
    [UIView animateWithDuration:.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         resultView.alpha = 1;
                         totalView.alpha = 1;
                     }
                     completion:^(BOOL bl){
                         
                     }];
}

- (BOOL) saveHFWJData{
    NSDictionary * dic =nil;
    
    NSDictionary * hfwjStr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%i",hfwjFormData.hfwjid],
                              HFWJID_HFWJ,
                              tmdacNSString,
                              HFTMDAC_HFWJ,
                              [NSString stringWithFormat:@"%i",1],
                              HFJG_HFWJ,
                              nil];
    //    NSMutableDictionary * saveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                     hfwjStr,HFWJKEY_HFWJ,nil];
    //    hfwj:{HFWJID"":""?"",""HFTMDAC"":""182|A;184|A;185|C;186|A;187|D;188|A"",""HFJG"":""1""}
    [self sendSaveStepInfo:HFWJ_STEP dataDictionary:&dic arrar:[NSMutableDictionary dictionaryWithDictionary:hfwjStr]];
    
    while (!bSaveStepFinish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    bSaveStepFinish = NO;
    
    if(bSaveStepSuccess){
        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        
        return YES;
    }
    else{
        [self activityIndicate:NO tipContent:@"保存失败" MBProgressHUD:nil target:self.navigationController.view];
        
        return NO;
    }
}

- (int)caculateVC{
    int point = 0;
    NSString * totalTmdac = nil;
    NSMutableArray * tmdacAr = [NSMutableArray array];
    
//    NSLog(@"cellConditioins =%@",cellConditioins);
    for (int section =0 ; section < tmRecords.count; section++) {
        NSMutableArray * ar = [cellConditioins objectAtIndex:section];
//        NSLog(@"cellConditioins ar =%@",ar);
        BOOL isSelected = NO;
        NSString * subTmdac = nil;
        int sectionPoint = 0;
        
        for (int row = 0; row < ar.count; row++) {
            if([[ar objectAtIndex:row] intValue] == 1){
                sectionPoint = [self pointForCell:section row:row tmdac:&subTmdac];
                isSelected = YES;
            }
        }
        
        if(!isSelected){
            return section;
        }
        
        point += sectionPoint;
        [tmdacAr addObject:subTmdac];
        
        NSLog(@"sectionPoint =%i,%i",sectionPoint,point);
    }
    
    tmdacNSString = [tmdacAr firstObject];
    for(int i=1;i<tmdacAr.count; i++){
        tmdacNSString = [tmdacNSString stringByAppendingFormat:@";%@",[tmdacAr objectAtIndex:i]];
    }
    
    hfwjFormData.hftmdac = [tmdacNSString UTF8String];
    
    NSDictionary * hfwjJson = [[SJKHEngine Instance]->hfwj_step_Dic objectForKey:HFWJJSON_HFWJ ];
    if(hfwjJson){
        bzRecords = [hfwjJson objectForKey:BZRECORDS_FXPC];
        for (NSDictionary * dic in bzRecords) {
            NSLog(@"sz xx =%i,%i",[[dic objectForKey:PFXX_FXPC] intValue] , [[dic objectForKey:PFSX_FXPC] intValue]);
            if([[dic objectForKey:PFXX_FXPC] intValue] <= point &&
               [[dic objectForKey:PFSX_FXPC] intValue] > point )
            {
                hfwjFormData.hfwjid = [[dic objectForKey:WJID_FXPC] intValue];
                break ;
            }
        }
    }
    
    return -1;
}

#pragma tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return tmRecords.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[tipMark objectAtIndex:section] intValue] == 0) {
        return 0;
    }
    return ((NSMutableArray *)[cellConditioins objectAtIndex:section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * title = [[cellTexts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	return [super getHeightForHeaderString:title size:CGSizeMake(table_view.frame.size.width - 25 - 30, CGFLOAT_MAX)];
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
    int section = indexPath.section;
    
//    NSDictionary * sectionDataSource = [tmRecords objectAtIndex:section];
    NSString * title = [[cellTexts objectAtIndex:section] objectAtIndex:row];
    UIButton * cellButton ;
    
    cellButton = [PublicMethod InitSelectTitle:title
                                     withFrame:CGRectMake(25 ,
                                                          0 ,
                                                          screenWidth - 2*levelSpace - 25 ,
                                                          [super getHeightForHeaderString:title size:CGSizeMake(table_view.frame.size.width - 25 -30, CGFLOAT_MAX)])
                                           tag:0
                                        target:self];
    cellButton.titleLabel.numberOfLines = 2;
    cellButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [cellButton addTarget:self action:@selector(onSelectClick:) forControlEvents:UIControlEventTouchDown];
    cellButton.tag = [[NSString stringWithFormat:@"%i%i",section,row] intValue];
    [cellButton setUserInteractionEnabled:YES];
    UIButton * markButton = (UIButton *)[cellButton viewWithTag:SelectBtnTag];
    if([[[cellConditioins objectAtIndex:section] objectAtIndex:row] intValue] == 1){
        [markButton setImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateNormal];
    }
    [cellButton setUserInteractionEnabled:NO];
    [cell.contentView addSubview:cellButton];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int indexrow = indexPath.row;
    int section = indexPath.section;
    
    NSMutableArray * ar = [cellConditioins objectAtIndex:section];
    
    if([[ar objectAtIndex:indexrow] intValue] == 0){
        if(indexrow == 1){
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:[titleTips objectAtIndex:section] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
        }
        
        for (int r = 0; r < ar.count; r++) {
            [ar replaceObjectAtIndex:r withObject:[NSNumber numberWithInt:0]];
        }
        [ar replaceObjectAtIndex:indexrow withObject:[NSNumber numberWithInt:1]];
    }
    else{
        [ar replaceObjectAtIndex:indexrow withObject:[NSNumber numberWithInt:0]];
    }
    [table_view reloadData];
    
    NSLog(@"zhi =%i,%i,%i",tipMark.count ,section ,[table_view numberOfRowsInSection:section + 1]);
    
    int rows = [table_view numberOfRowsInSection:section + 1];
    if (section < tipMark.count - 1 && rows > 0 && rows < 2147483647) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:section + 1];
        [table_view scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    NSString * title = [NSString stringWithFormat:@"%i.%@",section + 1, [[tmRecords objectAtIndex:section] objectForKey:QDESCRIBE_FXPC]];
    //    [PublicMethod trimSpecialCharacters:&title];
    //    CGSize size = [PublicMethod getStringSize:title font:TipFont];
    //    int numberLines = size.width / table_view.frame.size.width;
    //    return 40 * (numberLines + 1);
    
    //    return [super getHeightForHeaderString:[NSString stringWithFormat:@"%i.%@",section + 1, [[tmRecords objectAtIndex:section] objectForKey:QDESCRIBE_FXPC]] size:CGSizeMake(table_view.frame.size.width , CGFLOAT_MAX)];
    
    return [super getHeightForHeaderString:
            [NSString stringWithFormat:@"%i.%@",section + 1, [[tmRecords objectAtIndex:section] objectForKey:QDESCRIBE_FXPC]]
                                      size:
            CGSizeMake(table_view.frame.size.width , CGFLOAT_MAX)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerButton setBackgroundColor:LikeWhiteColor];
    headerButton.tag = section + HEADERBUTTONTAG;
    [headerButton addTarget:self action:@selector(onClickHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    NSString * title = [NSString stringWithFormat:@"%i.%@",section + 1, [[tmRecords objectAtIndex:section] objectForKey:QDESCRIBE_FXPC]];
    [PublicMethod trimSpecialCharacters:&title];
    CGSize size = [PublicMethod getStringSize:title font:PublicBoldFont];
    int numberLines = size.width / table_view.frame.size.width;
    
    [headerButton setFrame:CGRectMake(0, 0, table_view.frame.size.width, [super getHeightForHeaderString:title size:CGSizeMake(table_view.frame.size.width , CGFLOAT_MAX)])];
    [headerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    headerButton.titleLabel.numberOfLines = numberLines + 1;
    headerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    headerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerButton setTitle:title forState:UIControlStateNormal];
    if(section < tmRecords.count - 1){
        [headerButton addSubview:[PublicMethod getSepratorLine:CGRectMake(0, headerButton.frame.size.height-0.5,table_view.frame.size.width , 0.5) alpha:1]];
    }
	return headerButton;
}

- (void)onSelectClick:(UIButton *)btn{
    int section = -1;
    int index = -1;
    switch (btn.tag) {
        case 0:
            section = 0;
            index =0;
            break;
        case 1:
            section = 0;
            index = 1;
            break;
        default:{
            NSString * indexPath = [NSString stringWithFormat:@"%i",btn.tag];
            section = [[indexPath substringToIndex:indexPath.length - 1] intValue];
            index = [[indexPath substringFromIndex:indexPath.length - 1] intValue];
        }
            break;
    }
    NSMutableArray * ar = [cellConditioins objectAtIndex:section];
    
    if([[ar objectAtIndex:index] intValue] == 0){
        [ar replaceObjectAtIndex:1 - index withObject:[NSNumber numberWithInt:0]];
        [ar replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
    }
    else{
        [ar replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
    }
    
    [table_view reloadData];
}

- (void)onClickHeaderButton:(UIButton *)btn{
    if([[tipMark objectAtIndex:btn.tag - HEADERBUTTONTAG]intValue] == 1){
        [tipMark replaceObjectAtIndex:btn.tag - HEADERBUTTONTAG withObject:[NSNumber numberWithInt:0]];
    }
    else{
        [tipMark replaceObjectAtIndex:btn.tag - HEADERBUTTONTAG withObject:[NSNumber numberWithInt:1]];
    }
    
    [table_view reloadData];
}

- (void) updateUI{
    //    [super updateUI];
    
    if(!self.isViewLoaded){
        return ;
    }
    
    //    [tmRecords removeAllObjects];
    //    [cellConditioins removeAllObjects];
    //    [cellTexts removeAllObjects];
    
    NSDictionary * fxpcJson = [[SJKHEngine Instance]->hfwj_step_Dic objectForKey:HFWJJSON_HFWJ];
    if(fxpcJson){
        tmRecords = [fxpcJson objectForKey:TMRECORDS_FXPC];
        for (int i = 0; i < tmRecords.count; i++) {
            [tipMark addObject:[NSNumber numberWithInt:1]];
        }
        
        for (int section = 0; section < tmRecords.count; section++) {
            NSMutableArray * sectionData = [NSMutableArray array];
            NSDictionary * tmDic = [tmRecords objectAtIndex:section];
            NSString * sAnswer = [tmDic objectForKey:SANSWER_FXPC];
            
            NSLog(@"tmDic =%@",tmDic);
            
            int index = 0;
//            if([[tmDic objectForKey: SCORE_FXPC] isKindOfClass:[NSString class]]){
//                index = [super getSmallestScoreIndex: [tmDic objectForKey: SCORE_FXPC]];
//            }
//            if([[tmDic objectForKey: SCORE_FXPC] isKindOfClass:[NSNumber class]]){
//                index = -1;
//            }
            
            int rowCount = [sAnswer componentsSeparatedByString:@"|"].count - 1;
            for (int row =0; row < rowCount; row++) {
                [sectionData addObject:[NSNumber numberWithInt:0]];
            }
            
//            if(index != -1){
//                [sectionData replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
//            }
            
            [sectionData replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
            
            [cellConditioins addObject:sectionData];
        }
        
        for (NSDictionary * dic in tmRecords) {
            NSMutableArray * sectionArray = [NSMutableArray array];
            
            NSString * sanswer = [dic objectForKey:SANSWER_FXPC];
            NSMutableArray * cellContent = [NSMutableArray arrayWithArray:[sanswer componentsSeparatedByString:@"|"]];
            [cellContent removeObjectAtIndex:0];
            
            for (int i = 0;i<cellContent.count;i++) {
                NSString * content = [cellContent objectAtIndex:i];
                if(i == cellContent.count - 1){
                    [sectionArray addObject:content];
                }
                else{
                    [sectionArray addObject:[content substringWithRange:NSMakeRange(0, content.length - 2)]];
                }
            }
            
            [cellTexts addObject:sectionArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [table_view reloadData];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)popToLastPage{
    NSLog(@"customview hfwj =%i",[SJKHEngine Instance]->bLastCommitSuccess);
    
    if([SJKHEngine Instance]->bLastCommitSuccess){
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [[SJKHEngine Instance]->rootVC vcOperation:nil];
        
        [[SJKHEngine Instance] backToKaiHuLoginVCAndDealloc];
        [SJKHEngine Instance]->bLastCommitSuccess = NO;
    }
    else{
        if([SJKHEngine Instance]->fxpc_step_Dic.count == 0 || [SJKHEngine Instance]->fxpc_step_Dic == nil){
            NSArray * ar = self.navigationController.viewControllers;
            BaseViewController * preVC = [ar objectAtIndex:ar.count - 2];
            [[SJKHEngine Instance]->rootVC popToZDPage:FXPC_STEP preVC:preVC];
        }
        else{
            [self.navigationController popViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
        }
    }
    
    //    [super popToLastPage];
    [[SJKHEngine Instance].observeCtrls removeObject:self];
}

- (void)httpFinished:(ASIHTTPRequest *)http{
    [super httpFinished:http];
    
    NSString * tip = nil;
    if(http.request_type == KHQRTJ_REQUEST){
        if([[responseDictionary objectForKey:SUCCESS] intValue] == 1){
            tip = @"提交申请成功";
            [self tipRequestAccountSuccess];
        }
        else{
            tip = @"提交开户申请失败";
        }
        [self activityIndicate:NO tipContent:tip MBProgressHUD:hud target:self.navigationController.view];
    }
    if(http.request_type == CXKHXX_REQUEST){
        if([[responseDictionary objectForKey:SUCCESS] intValue]==1){
            //更新LookProcess的ui
            lookVC = [[LookProcessViewCtrl alloc]init];
            lookVC->khbdInfo = [responseDictionary objectForKey:@"khbdInfo"];
            [self activityIndicate:NO tipContent:nil MBProgressHUD:hud target:self.navigationController.view];
            [self.navigationController pushViewController:lookVC animated:YES];
            [lookVC updateUI];
        }
        else{
            tip = @"查询开户进度失败";
            [self activityIndicate:NO tipContent:tip MBProgressHUD:hud target:self.navigationController.view];
        }
    }
}

- (void)httpFailed:(ASIHTTPRequest *)http{
    [super httpFailed:http];
    
    if(http.request_type == KHQRTJ_REQUEST){
        [self activityIndicate:NO tipContent:@"提交开户申请失败" MBProgressHUD:hud target:self.navigationController.view];
    }
    if(http.request_type == CXKHXX_REQUEST){
        [self activityIndicate:NO tipContent:@"查询开户信息失败" MBProgressHUD:hud target:self.navigationController.view];
    }
}

- (void)dealloc{
    [tipLabel removeFromSuperview];
    tipLabel = nil;
    lookVC = nil;
    [nextBtn removeFromSuperview];
    nextBtn = nil;
    titleTips = nil;
    [totalView removeFromSuperview];
    totalView = nil;
    
    NSLog(@"回访问卷回收");
}

@end