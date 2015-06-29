//
//  SecretSetViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-11.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "SecretSetViewCtrl.h"
#import "DepositBankViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "AccountTypeViewCtrl.h"

#define CellHeight 140.0
#define CellTag 101
#define FieldControlTag   231

@interface SecretSetViewCtrl (){
    NSMutableArray * filterArray;
    UITableView * table_view;
//    NSMutableArray * fieldArray;
    UIButton * frontBtn;
    BOOL bIsSelected;               //"...同..."按钮有没划上勾，有没被选择
    UIButton * sameSecretBtn;
    int labelHeight;
    
    UITextField * ZJMMFirstField;
    UITextField * ZJMMSecondField;
    UITextField * JYMMFirstField;
    UITextField * JYMMSecondField;
}

@end

@implementation SecretSetViewCtrl

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
    [super viewWillAppear:animated];
//    [self addGesture:self.navigationController.navigationBar];
}

- (void)viewDidAppear:(BOOL)animated{
    if(bIsSelected){
        [self onSelectButton:sameSecretBtn];
    }
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar removeGestureRecognizer:singleTapRecognizer];
}

- (void) InitConfig{
    filterArray = [[NSMutableArray alloc]initWithObjects:@"交易密码", nil];
    bIsSelected = YES;
    labelHeight = 40;
    
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)fieldTextChanged:(NSNotification *)noti{
    UITextField * textField = noti.object;
    NSString * fieldText = textField.text;
    
    if(!textField.markedTextRange){
        if(fieldText.length > 6){
            [textField setText:[fieldText substringToIndex:6]];
        }
    }
}

- (void) InitWidgets{
    UIButton * headerFlowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerFlowButton setFrame:CGRectMake(0, 0 , screenWidth, ButtonHeight)];
    [headerFlowButton setImage:[[UIImage imageNamed:@"flow_2"] imageByResizingToSize:CGSizeMake(screenWidth, headerFlowButton.frame.size.height)]
                      forState:UIControlStateNormal];
    [headerFlowButton setUserInteractionEnabled:NO];
    
    table_view = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - UpHeight)];
    table_view.delegate = self;
    table_view.dataSource = self;
    [table_view setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    table_view.tableHeaderView = headerFlowButton;
    [table_view setBackgroundColor:PAGE_BG_COLOR];
    [self.view addSubview:table_view];
    
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    
    [self addGesture:self.view];
    
    if([SJKHEngine Instance]->systemVersion < 6){
        singleTapRecognizer.delegate = self;
    }
    
    [super InitWidgets];
}

#pragma tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filterArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return CellHeight;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel * tipLabel = [PublicMethod initLabelWithFrame:CGRectMake(levelSpace, 0, screenWidth - 2*levelSpace, 50) title:@"  设置交易密码(进行证券交易时使用)" target:self.view];
//    tipLabel.textColor = [UIColor blackColor];
//    [tipLabel setBackgroundColor:PAGE_BG_COLOR];
//    tipLabel.font = [UIFont boldSystemFontOfSize:15];
//    tipLabel.numberOfLines = 0;
//    
//    return tipLabel;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"tableViewCellIdentify";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    for (UIView * vi in cell.contentView.subviews) {
        for(UIView * subV in vi.subviews){
            [subV removeFromSuperview];
        }
        [vi removeFromSuperview];
    }
    
    int row = indexPath.row;
    float space = (CellHeight - 44*3)/3;
    if(row == filterArray.count){
        sameSecretBtn = [PublicMethod InitReadXY:@"资金密码同交易密码"
                                       withFrame:CGRectMake(5 ,
                                                                       space ,
                                                                       screenWidth - 2*5 ,
                                                                       ButtonHeight)
                                             tag:FieldControlTag + 100
                                          target:self];
        
        UIButton * markBtn = (UIButton *)[sameSecretBtn viewWithTag:MarkBtnTag];
        [markBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
        [sameSecretBtn removeTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sameSecretBtn addTarget:self action:@selector(onSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:sameSecretBtn];
        
        UILabel *tip= [PublicMethod initLabelWithFrame:CGRectMake(10,
                                                                 space * 2 + ButtonHeight,
                                                                 screenWidth - 10*2 ,
                                                                 44)
                                                title:@"提示:请您妥善保管帐户密码,使用该密码进行的任何操作视为本人操作"
                                               target:cell.contentView];
        tip.textColor = [UIColor blackColor];
        [tip setBackgroundColor:[UIColor clearColor]];
        tip.font = [UIFont boldSystemFontOfSize:15];
        tip.numberOfLines = 0;
        tip.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self InitNextStepButton:CGRectMake (10,
                                             space * 3 + 44*2,
                                             screenWidth - 2 * 10,
                                             44)
                             tag:0
                           title:@"下一步"];
        [cell.contentView addSubview:nextStepBtn];
    }
    else{
        [cell.contentView addSubview:[self createFieldSupeView:row]];
    }
    
    [cell.contentView setBackgroundColor:PAGE_BG_COLOR];
    
    return cell;
}

- (void)onSelectButton:(UIButton *)btn{
    if(bKeyBoardShow){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:ZJMMFirstField,ZJMMSecondField,JYMMFirstField,JYMMSecondField, nil]];
    }
    UIButton * markBtn = (UIButton *)[btn viewWithTag:MarkBtnTag];
    if(!bIsSelected){
        [markBtn setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
        [self insertZJField:NO];
        bIsSelected = YES;
    }
    else{
        [markBtn setImage:[UIImage imageNamed:@"checkbox_default"] forState:UIControlStateNormal];
        [self insertZJField:YES];
        bIsSelected = NO;
    }
}

- (UIView *)createFieldSupeView:(int)index{
    int space = 5;
    int cellWidth = screenWidth - 2*space;
    int localCellHeight = CellHeight ;
    UIView *la = [[UIView alloc]initWithFrame: CGRectMake(space, 0, cellWidth, localCellHeight)];
    [la setBackgroundColor:[UIColor whiteColor]];
    [PublicMethod publicCornerBorderStyle:la];
    la.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSString * placeHolder = [filterArray objectAtIndex:index];
    NSArray * currentHolders = [NSArray arrayWithObjects:placeHolder,[NSString stringWithFormat:@"确定%@",placeHolder],nil];
    //交易密码
    if(index == 0){
        [self createLocalLabel:0 target:la];
        JYMMFirstField = [self createLocalField:0 placeHolder:currentHolders target:la];
        JYMMSecondField = [self createLocalField:1 placeHolder:currentHolders target:la];
    }
    //资金密码
    if(index == 1){
        [self createLocalLabel:1 target:la];
        ZJMMFirstField = [self createLocalField:0 placeHolder:currentHolders target:la];
        ZJMMSecondField = [self createLocalField:1 placeHolder:currentHolders target:la];
    }
    
    return la;
}

- (UILabel *)createLocalLabel:(int)index target:(UIView *)view{
    NSString * tip = @"";
    
    switch (index) {
        case 0:
            tip = @"设置交易密码(进行证券交易时使用)";
            break;
            
        case 1:
            tip = @"设置资金密码(设置资金转入和转出时使用)";
            break;
    }
    
    UILabel * tipLabel = [PublicMethod initLabelWithFrame:CGRectMake(levelSpace, 0, view.frame.size.width - 2*levelSpace, labelHeight) title:tip target:view];
    tipLabel.textColor = [UIColor blackColor];
    [tipLabel setBackgroundColor:[UIColor clearColor]];
    tipLabel.font = [UIFont boldSystemFontOfSize:16];
    tipLabel.numberOfLines = 0;
    
    return tipLabel;
}

- (UITextField *)createLocalField:(int)index placeHolder:(NSArray *)holders target:(UIView *)vi{
    int verticalSpace = 5;
    int localLevelSpace = 10;
    int fieldWidth = vi.frame.size.width - 2*localLevelSpace;
    int fieldHeight = (CellHeight - labelHeight - 2*verticalSpace) / 2.0;
    UITextField *field = [PublicMethod CreateField:[holders objectAtIndex:index]
                                         withFrame:CGRectMake(localLevelSpace,
                                                              (fieldHeight + verticalSpace)*index + labelHeight,
                                                              fieldWidth,
                                                              fieldHeight)
                                               tag:0
                                            target:vi];
    [field setSecureTextEntry:YES];
    field.delegate = self;
    [field setBackgroundColor:[UIColor whiteColor]];
    field.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    [PublicMethod publicCornerBorderStyle:field];
    
    return field;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [table_view reloadData];
}

//插入资金输入框
- (void)insertZJField:(BOOL)isInsert{
    NSIndexPath * index = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *ar = [NSArray arrayWithObjects:index, nil];
    
    if(isInsert){
//        [ZJMMFirstField resignFirstResponder];
//        [ZJMMSecondField resignFirstResponder];
        [filterArray addObject:@"资金密码"];
        [table_view insertRowsAtIndexPaths:ar withRowAnimation:UITableViewRowAnimationTop];
    }
    else{
        [filterArray removeObjectAtIndex:1];
        [table_view deleteRowsAtIndexPaths:ar withRowAnimation:UITableViewRowAnimationBottom];
    }
}

#pragma textfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bKeyBoardShow = YES;
    
    CGRect newFrame=[textField convertRect:[[UIScreen mainScreen] applicationFrame] toView:self.view];
//    CGRect newFrame = textField.frame;
    keyboardOffset = newFrame.origin.y + ButtonHeight - (screenHeight - UpHeight - KeyBoardHeight);
    textField.layer.borderColor = TEXTFEILD_BOLD_HIGHLIGHT_COLOR.CGColor;
    if(keyboardOffset > 0){
        [self beginEdit:YES textFieldArrar:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor = FieldNormalColor.CGColor;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(bKeyBoardShow ){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:textField,nil]];
    }
    return YES;
}

#pragma scrollview delegate
- (void)scrollViewWillBeginDragging: (UIScrollView *)_scrollView
{
    if(bKeyBoardShow ){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:ZJMMFirstField,ZJMMSecondField,JYMMFirstField,JYMMSecondField, nil]];
    }
}

- (void)OnTouchDownResign:(UIControl *)control{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZJMMFirstField resignFirstResponder];
        [ZJMMSecondField resignFirstResponder];
        [JYMMFirstField resignFirstResponder];
        [JYMMSecondField resignFirstResponder];
        
        if(bKeyBoardShow ){
            [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:ZJMMFirstField,ZJMMSecondField,JYMMFirstField,JYMMSecondField, nil]];
        }
    });
}

- (void)updateUI{
    [super updateUI];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)reposControl{
    int offset = 0;
    
	if (bKeyBoardShow)
	{
        [UIView animateWithDuration:0.2 animations:^{
            table_view.frame = CGRectMake(0, offset-(keyboardOffset + verticalHeight), screenWidth, screenHeight - UpHeight );
        }completion:^(BOOL finish){
            
        }];
	}
	else
	{
        [UIView animateWithDuration:0.2 animations:^{
            table_view.frame = CGRectMake(0, offset, screenWidth, screenHeight - UpHeight);
        }completion:^(BOOL finish){
            
        }];
	}
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * fieldText = [NSString stringWithFormat:@"%@%@", textField.text , string];
    
    int index = [rmmArray indexOfObject:fieldText];
    if(index >= 0 && index < rmmArray.count){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入保密等级高的密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        
        return NO;
    }
//    if (fieldText.length>6) {
////        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"您的密码不能超过6位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
////        [alertview show];
//        
//        return NO;
//    }
    
    return YES;
}

- (void)onButtonClick:(UIButton *)btn{
    if(bKeyBoardShow ){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:ZJMMFirstField,ZJMMSecondField,JYMMFirstField,JYMMSecondField, nil]];
    }
    
    if(btn.tag == MarkBtnTag){
        [self onSelectButton:sameSecretBtn];
        
        return ;
    }
    
    NSDictionary * dic =nil;
    
    NSString * insertJY = JYMMFirstField.text;
    [PublicMethod trimText: &insertJY];
    NSString * fieldText = JYMMSecondField.text;
    [PublicMethod trimText:&fieldText];
    
    NSLog(@"jy =%@,%@",insertJY,fieldText);
    
    if(fieldText==nil ||fieldText.length == 0 ||insertJY ==nil || insertJY.length == 0){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"请输入交易密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    if(![fieldText isEqualToString:insertJY])
    {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"交易密码不一致,请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    if (insertJY.length < 6) {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"您的交易密码不能少于6位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    
    NSString * insertZJ = Nil;
    insertZJ = ZJMMFirstField.text;
    [PublicMethod trimText: &insertZJ];
    
    fieldText = ZJMMSecondField.text;
    [PublicMethod trimText:&fieldText];
    
    if(bIsSelected == NO){
        if(fieldText==nil ||fieldText.length == 0 ||insertZJ==nil || insertZJ.length == 0){
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"请输入资金密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            return ;
        }
        if(![fieldText isEqualToString:insertZJ]){
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"资金密码不一致,请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            return ;
        }
        if (insertZJ.length < 6) {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"您的资金密码不能少于6位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            return ;
        }
    }
    else {
        insertZJ = insertJY;
    }
    
//    ""mmsz"":{""JYMM"":""123321"",""ZJMM"":""321123"",""SFTB"":""0""}
    NSMutableDictionary * saveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     insertJY,JYMM_MMSZ,
                                     bIsSelected?insertJY:insertZJ,ZJMM_MMSZ,
                                     bIsSelected?@"1":@"0",SFTB_MMSZ,nil];
    [self sendSaveStepInfo:MMSZ_STEP dataDictionary:&dic arrar:saveDic];
    
    while (!bSaveStepFinish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    bSaveStepFinish = NO;
    
    if(bSaveStepSuccess){
        [self activityIndicate:YES tipContent:@"加载存管银行页面信息..." MBProgressHUD:nil target:self.navigationController.view];
        DepositBankViewCtrl * bankVC = [[DepositBankViewCtrl alloc]init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self dispatchBankVC:bankVC];
        });
    }
    else{
        [self activityIndicate:NO tipContent:@"保存页面数据失败" MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void)dispatchBankVC:(DepositBankViewCtrl *)bankVC{
    NSDictionary * stepDictionary = nil;
    if([self sendSaveCurrentStepKey:CGZD_STEP dataDictionary:&stepDictionary]){
        BOOL ok = [self sendGoToStep:CGZD_STEP dataDictionary:&stepDictionary];
        if(ok){
            [SJKHEngine Instance]->cgzd_step_Dic = [stepDictionary mutableCopy];
            bankVC->filterArray = [NSMutableArray array];
            NSMutableArray * cgyharr = [NSMutableArray arrayWithArray:[[SJKHEngine Instance]->cgzd_step_Dic objectForKey:CGYHARR_CGYH]];
            [cgyharr sortUsingComparator:^NSComparisonResult(id obj1 ,id obj2){
                NSDictionary *data1 = (NSDictionary *)obj1;
                NSDictionary *data2 = (NSDictionary *)obj2;
                
                NSLog(@"obj1 , obj 2=%@,%@",obj1,obj2);
                return [[data1 objectForKey:PX_CGYH] compare:[data2 objectForKey:PX_CGYH]];
            }];
            [[SJKHEngine Instance]->cgzd_step_Dic setObject:cgyharr forKey:CGYHARR_CGYH];
            
            for (NSDictionary * yhDic in [[SJKHEngine Instance]->cgzd_step_Dic objectForKey:CGYHARR_CGYH]) {
                [bankVC->filterArray addObject:[yhDic objectForKey:YHMC_CGYH]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                [self.navigationController pushViewController:bankVC animated:YES];
//                [bankVC updateUI];
            });
        }
        else {
            [self activityIndicate:NO tipContent:@"加载存管银行页面失败" MBProgressHUD:nil target:self.navigationController.view];
//            [[SJKHEngine Instance] dispatchMessage:POP_MESSAGE];
        }
    }
}

- (void)popToLastPage{
    [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:ZJMMFirstField,ZJMMSecondField,JYMMFirstField,JYMMSecondField, nil]];
    
    if([SJKHEngine Instance]->zqzh_step_Dic.count == 0 || [SJKHEngine Instance]->zqzh_step_Dic == nil){
        NSArray * ar = self.navigationController.viewControllers;
        BaseViewController * preVC = [ar objectAtIndex:ar.count - 2];
        [[SJKHEngine Instance]->rootVC popToZDPage:ZQZH_STEP preVC:preVC];
    }
    else{
        NSArray * ar = self.navigationController.viewControllers;
        BaseViewController * preVC = [ar objectAtIndex:ar.count - 2];
        if([SJKHEngine Instance]->systemVersion == 6){
            [preVC->scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            [preVC->scrollView setBounds:CGRectMake(0, -10, screenWidth, preVC->scrollView.bounds.size.height)];
        }
        [self.navigationController popViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
    }
    
    [super popToLastPage];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    CGPoint point1 = [gestureRecognizer locationInView:sameSecretBtn];
//    CGPoint point2 = [gestureRecognizer locationInView:nextStepBtn];
//    
//    BOOL bSameSecretContain = (sameSecretBtn.frame.size.width > point1.x) &&
//    (sameSecretBtn.frame.size.height > point1.y) &&
//    (point1.x > 0) &&
//    (point1.y > 0);
//    BOOL bNestStepContain = (nextStepBtn.frame.size.width > point2.x) &&
//    (nextStepBtn.frame.size.height > point2.y) &&
//    (point2.x > 0) &&
//    (point2.y > 0);
//    
//    NSLog(@"blongTime =%i,%i",bSameSecretContain,bNestStepContain);
//    
//    if(bNestStepContain || bSameSecretContain)
//    {
//        return NO;
//    }
//    
//    return YES;
//}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    UITextField * ZJMMFirstField;
//    UITextField * ZJMMSecondField;
//    UITextField * JYMMFirstField;
//    UITextField * JYMMSecondField;
    
    BOOL bShouldReceive = bIsSelected ?
    (touch.view ==[JYMMFirstField valueForKey:@"_clearButton"] || touch.view ==[JYMMSecondField valueForKey:@"_clearButton"]) :
    (touch.view ==[ZJMMFirstField valueForKey:@"_clearButton"] || touch.view ==[ZJMMSecondField valueForKey:@"_clearButton"] ||
     touch.view ==[JYMMFirstField valueForKey:@"_clearButton"] || touch.view ==[JYMMSecondField valueForKey:@"_clearButton"]);
    
    if(bShouldReceive||
       touch.view == sameSecretBtn ||
       touch.view == nextStepBtn)
    {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [rmmArray removeAllObjects];
    rmmArray = nil;
    
    [filterArray removeAllObjects];
    filterArray = nil;
    
    [table_view removeFromSuperview];
    table_view = nil;
    [frontBtn removeFromSuperview];
    frontBtn = nil;
    [sameSecretBtn removeFromSuperview];
    sameSecretBtn = nil;
    [ZJMMFirstField removeFromSuperview];
    ZJMMFirstField = nil;
    [ZJMMSecondField removeFromSuperview];
    ZJMMSecondField = nil;
    [JYMMFirstField removeFromSuperview];
    JYMMFirstField = nil;
    [JYMMSecondField removeFromSuperview];
    JYMMSecondField = nil;
    
    NSLog(@"密码设置回收");
}

@end
