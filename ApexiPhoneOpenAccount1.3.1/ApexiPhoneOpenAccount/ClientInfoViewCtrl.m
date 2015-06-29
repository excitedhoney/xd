//
//  ClientInfoViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-8.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "ClientInfoViewCtrl.h"
#import "VideoWitnessViewCtrl.h"
#import <QuartzCore/QuartzCore.h>
#import "KHRequestOrSearchViewCtrl.h"

#define JBZL_VIEW_TAG 2098
#define JBZL_BUTTON_TAG 16

@interface ClientInfoViewCtrl (){
    NSArray * fieldNames;
    NSMutableArray * fieldTexts;
    int scrollSpace ;
    CGSize normalSize ;
    UITextField * tipField;
    NSMutableArray * fieldKeys;
    int localVericalSpace;
    UIButton * requestZRS;
    NSMutableDictionary * tipIDs;
    UITextField *ocusView;
    NSMutableArray *characterLimtedWarnArr;
    NSMutableArray *nullCharacterWarnArr;
    UIButton * showPickerButton;
    UIButton * longTimeButton;
//    UIDatePicker * datePicker;

//    fieldNames = [NSArray arrayWithObjects:@"姓   名",@"身份证号码",@"证件地址",@"联系地址",@"邮   编",@"证件有效期",@"职   业",@"学   历",nil];
    UITextField * xmField;            //姓名输入框
    UITextField * sfzhmField;         //身份证号码输入框
    UITextField * zjdzField;          //证件地址输入框
    UITextField * lxdzField;          //联系地址输入框
    UITextField * ybField;            //邮编输入框
    UITextField * zjyxqField;         //证件有效期输入框
    UITextField * zhiyeField;         //职业输入框
    UITextField * xueliField;         //学历输入框
    NSMutableArray * fields;
    
    FlatDatePicker * flatDatePicker;
    BOOL bSfnzResult;                  //身份验证结果
    BOOL bSfnzEnd;
    NSString * sSfnzNote;              //身份验证提示
    UITapGestureRecognizer * tapFieldGesture;
}

@end

@implementation ClientInfoViewCtrl

int characterLimitedArr[5] = {8,30,50,50,6};

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
//#ifndef SelectTest
//    if(!jbzl_step_OCR_Dic || jbzl_step_OCR_Dic.count == 0){
//        [self activityIndicate:YES tipContent:@"照片识别中..." MBProgressHUD:nil target:self.navigationController.view];
//        [self performSelector:@selector(stopHUDOCRTip) withObject:Nil afterDelay:15];
//    }
//#endif
    
    if(bFirstShow && !bReEnter){
        if([SJKHEngine Instance]->bReUploadImage){
            [SJKHEngine Instance]->bReUploadImage = NO;
            [self dipatchImageRecognize];
            bFirstShow = NO;
        }
        else{
            BOOL isNil = YES;
            for (UITextField * field in fields) {
                if(field.text.length > 0 && field.text){
                    isNil = NO;
                    break;
                }
            }
            if(isNil){
                [self dipatchGetStepInfo];
            }
        }
    }
    if(bReEnter){
        bFirstShow = NO;
        [self dipatchGetStepInfo];
        bReEnter = NO;
    }
    
    [super viewDidAppear:animated];
    
//    [self addGesture:self.navigationController.navigationBar];
}

- (void)dipatchGetStepInfo{
    [self activityIndicate:YES tipContent:@"获取输入数据..." MBProgressHUD:nil target:self.navigationController.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * stepResponseDic = nil;
        if([self sendGetStepInfo:JBZL_STEP dataDictionary:&stepResponseDic]){
            NSLog(@"基本资料获取成功 ＝ %@",stepResponseDic);
            [self activityIndicate:NO tipContent:nil MBProgressHUD:Nil target:self.navigationController.view];
            jbzl_enterData_Dic = [[stepResponseDic objectForKey:JBZL_STEP] mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setFieldText];
            });
        }
        else{
            NSLog(@"基本资料获取失败");
//            [self activityIndicate:NO tipContent:@"输入信息获取失败" MBProgressHUD:nil target:self.navigationController.view];
            [self activityIndicate:YES tipContent:@"相片识别中" MBProgressHUD:nil target:self.navigationController.view];
            [self ocrOperation];
        }
    });
}

- (void)setFieldText{
    for (int i = 0 ; i < fields.count ;i++) {
        NSString * fieldText = [jbzl_enterData_Dic objectForKey:[fieldKeys objectAtIndex:i]];
        switch (i) {
            case 0:
            {
                if(fieldText.length > 8){
                    fieldText = [fieldText substringToIndex:8];
                }
                
                [xmField setText:fieldText];
                break;
            }
                
            case 1:
            {
                if(fieldText.length > 30){
                    fieldText = [fieldText substringToIndex:30];
                }
                [sfzhmField setText:fieldText];
                break;
            }
                
            case 2:
            {
                if(fieldText.length > 50){
                    fieldText = [fieldText substringToIndex:50];
                }
                [zjdzField setText:fieldText];
                break;
            }
                
            case 3:
            {
                fieldText = [jbzl_enterData_Dic objectForKey:ZJDZ_OCR];
                if(fieldText.length > 50){
                    fieldText = [fieldText substringToIndex:50];
                }
                [lxdzField setText:fieldText];
                break;
            }
                
            case 4:
            {
                if(fieldText.length > 6){
                    fieldText = [fieldText substringToIndex:6];
                }
                [ybField setText:fieldText];
                break;
            }
                
            case 5:
            {
                [zjyxqField setText:fieldText];
                break;
            }
            
            case 6:
            {
                [zhiyeField setText:[self getFieltContentWithID:fieldText type:ZYDM]];
                break;
            }
            
            case 7:
            {
                [xueliField setText:[self getFieltContentWithID:fieldText type:XLDM]];
                break;
            }
        }
    }
}

- (NSString *)getFieltContentWithID:(NSString *)sID type:(NSString *)type{
    NSDictionary * dic = [[SJKHEngine Instance]->jbzl_step_Dic objectForKey:type];
    NSString * sFieldContent = @"";
    if(dic){
        NSMutableArray * recordsDic = [dic objectForKey:RECORDS];
        if(recordsDic){
            for (NSDictionary * itemDic in recordsDic) {
                if([[itemDic objectForKey:ID] intValue] == [sID intValue]){
                    sFieldContent = [itemDic objectForKey:UPNOTE];
                    break ;
                }
            }
        }
    }
    
    return sFieldContent;
}

- (void)dipatchImageRecognize{
    [self activityIndicate:YES tipContent:@"相片识别中" MBProgressHUD:nil target:self.navigationController.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self ocrOperation];
    });
}

- (void)ocrOperation{
    NSDictionary * stepResponseDic = nil;
    if([self sendOCRInfo: &stepResponseDic]){
        NSLog(@"oct获取成功 ＝ %@",stepResponseDic);
        jbzl_step_OCR_Dic = [stepResponseDic mutableCopy];
        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        [self updateUI];
    }
    else{
        NSLog(@"ocr获取失败");
        [self activityIndicate:NO tipContent:@"相片识别失败" MBProgressHUD:Nil target:self.navigationController.view];
        //            [[SJKHEngine Instance] dispatchMessage:GET_OCR_FAIL_POP_MESSAGE];
//        [self failGetOcrData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar removeGestureRecognizer:singleTapRecognizer];
    
    [self resignAllResponse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) InitConfig{
    //    [super InitConfig];
    bSfnzResult = NO;
    bSfnzEnd = NO;
    sSfnzNote = @"该用户尚有非现开户申请未完成,禁止重新开户";
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    self.view.bounds = CGRectMake(0, 0, screenWidth, self.view.bounds.size.height);
    bKeyBoardShow = NO;
    scrollSpace = 0;
    tipField = nil;
    localVericalSpace = 5;
    delayTime = 2.2;
    tipIDs = [[NSMutableDictionary alloc]init];
    characterLimtedWarnArr = [NSMutableArray arrayWithObjects:
                              @"姓名必须少于8个字",
                              @"身份证号码必须30个字符",
                              @"证件地址必须少于50个字",
                              @"联系地址必须少于50个字",
                              @"邮编必须是6位数字",
                              nil];
    nullCharacterWarnArr = [NSMutableArray arrayWithObjects:
                            @"请输入姓名",
                            @"请输入身份证号码",
                            @"请输入证件地址",
                            @"请输入联系地址",
                            @"请输入邮编",
                            @"请选择职业",
                            @"请选择学历",
                            nil];
    fields = [NSMutableArray array];
    tapFieldGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFieldClick:)];
//    tapFieldGesture.delegate = self;
    
//    [textField addObserver:self forKeyPath:@"text" options:0 context:nil];
//    
//    - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//        if([keyPath isEqualToString:@"text"] && object == textField) {
//            // text has changed
//        }
//    }
    
    [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)fieldTextChanged:(NSNotification *)noti{
    UITextField * textField = noti.object;
    NSString * fieldText = textField.text;
    NSLog(@"view noti =%@,%@",noti.object,fieldText);
    
    if(!textField.markedTextRange){
        if(fieldText.length> 8 && textField == xmField){
            [xmField setText:[fieldText substringToIndex:8]];
        }
        if(fieldText.length> 30 && textField == sfzhmField){
            [sfzhmField setText:[fieldText substringToIndex:30]];
        }
        if(fieldText.length> 50 && textField == zjdzField){
            [zjdzField setText:[fieldText substringToIndex:50]];
        }
        if(fieldText.length> 50 && textField == lxdzField){
            [lxdzField setText:[fieldText substringToIndex:50]];
        }
        if(fieldText.length> 6 && textField == ybField){
            [ybField setText:[fieldText substringToIndex:6]];
        }
    }
}

- (void) InitWidgets{
    [super InitWidgets];
    [self InitScrollView];
    self.view.backgroundColor = PAGE_BG_COLOR;
    scrollView.delegate=self;
    
    flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    flatDatePicker.delegate = self;
    flatDatePicker.title = @"请选择证件有效期";
    flatDatePicker.datePickerMode = FlatDatePickerModeDate;
    flatDatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1581120000];
    [flatDatePicker setHidden:YES];
    
//    int viewHeight = screenHeight - UpHeight;
    int labelHeight = 40;
    int fieldHeight = 44;
    
    UIButton * headerFlowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerFlowButton setFrame:CGRectMake(0, 0 , screenWidth, ButtonHeight)];
    headerFlowButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headerFlowButton setImage:[UIImage imageNamed:@"flow_1"]
                      forState:UIControlStateNormal];
    [headerFlowButton setUserInteractionEnabled:NO];
    
    [scrollView addSubview:headerFlowButton];
    
    UILabel *la=[[UILabel alloc]initWithFrame: CGRectMake(levelSpace, 10 + ButtonHeight, screenWidth - levelSpace, labelHeight - 10)];
	la.backgroundColor = [UIColor clearColor];
    [la setText:@"请填写以下信息:"];
	[la setFont: PublicBoldFont];
    la.textAlignment = NSTextAlignmentLeft;
	[la setTextColor: [UIColor blackColor]];
    la.lineBreakMode = NSLineBreakByTruncatingTail;
    [scrollView addSubview:la];
    
    fieldNames = [NSArray arrayWithObjects:@"姓   名",@"身份证号码",@"证件地址",@"联系地址",@"邮   编",@"证件有效期",@"职   业",@"学   历",nil];
    fieldTexts = [NSMutableArray array];
    fieldKeys = [NSMutableArray arrayWithObjects:
                 KHXM_OCR,
                 ZJBH_OCR,
                 ZJDZ_OCR,
                 LXDZ_OCR,
                 YZBM_OCR,
                 ZJYXQ_OCR,
                 ZY_UPLOAD_JBZL,
                 XL_UPLOAD_JBZL ,
                 nil];
    
    if([SJKHEngine Instance]->jbzl_user_datas.count == 0){
        for (int i = 0; i < fieldNames.count;i++) {
            [[SJKHEngine Instance]->jbzl_user_datas addObject:@""];
        }
    }
    
    int i = 0;
    for (; i < fieldNames.count; i++) {
        UITextField * editEditor = [[UITextField alloc] initWithFrame: CGRectMake(levelSpace , labelHeight + ButtonHeight + (localVericalSpace + fieldHeight) * i, screenWidth - levelSpace * 2, fieldHeight)];
        editEditor.backgroundColor = [UIColor clearColor];
        editEditor.delegate=self;
        editEditor.borderStyle = UITextBorderStyleNone;
        editEditor.keyboardType = UIKeyboardTypeDefault;
        editEditor.clearButtonMode = UITextFieldViewModeWhileEditing;
        editEditor.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [editEditor setTextAlignment:NSTextAlignmentLeft];
        [editEditor setFont: FieldFont];
        editEditor.tag = JBZL_VIEW_TAG + i;
        editEditor.layer.borderColor = FieldNormalColor.CGColor;
        editEditor.layer.cornerRadius = 2;
        editEditor.layer.masksToBounds = YES;
        editEditor.layer.borderWidth = 0.7;
        [editEditor positSpace:yep];
        if (i == fieldNames.count - 4) {
            editEditor.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        UIView * totalView = nil;
        if (i == 5) {
            totalView = [[UIView alloc]initWithFrame:editEditor.frame];
            [totalView setBackgroundColor:[UIColor clearColor]];
            
            int longTimeButtonWidth = 60;
            int localSpace = 5;
            editEditor.frame =  CGRectMake(0 , 0, totalView.frame.size.width - longTimeButtonWidth - localSpace, fieldHeight);
            
            int inset = 3;
            showPickerButton = [[UIButton alloc]initWithFrame:CGRectMake (editEditor.frame.size.width - 30 - inset, ButtonHeight/2 - 30/2 , 30, 30)];
            [showPickerButton setImage:[UIImage imageNamed:@"icon_date"] forState:UIControlStateNormal];
            [showPickerButton setImageEdgeInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];
            [showPickerButton addTarget: self action: @selector(onLoginTimeButtonClick:) forControlEvents: UIControlEventTouchUpInside];
            
            [editEditor addSubview:showPickerButton];
            
//            [editEditor addGestureRecognizer:tapFieldGesture];
            [editEditor addSubview:[self tapButtonForLastThreeField:CGRectMake(0, 0, editEditor.frame.size.width - showPickerButton.frame.size.width, editEditor.frame.size.height)]];
            
            [totalView addSubview:editEditor];
            
            longTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [longTimeButton setBackgroundImage:[[UIImage imageNamed:BTN_GRAY_NORMAL] stretchableImageWithLeftCapWidth:8 topCapHeight:8]
                                      forState:UIControlStateNormal];
            [longTimeButton setFrame:CGRectMake(editEditor.frame.size.width + localSpace, 0 , longTimeButtonWidth , ButtonHeight)];
            [longTimeButton setTitle:@"长期" forState:UIControlStateNormal];
            [longTimeButton addTarget: self action: @selector(onLoginTimeButtonClick:) forControlEvents: UIControlEventTouchUpInside];
            [longTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            longTimeButton.titleLabel.font = PublicBoldFont;
            
            [totalView addSubview:longTimeButton];
        }
        
        //依次根据index的序列给field赋值
        NSString * fieldText = nil;
        if(i < fieldNames.count - 2){
            fieldText = [jbzl_step_OCR_Dic objectForKey:[fieldKeys objectAtIndex:i]];
            if(fieldText && fieldText.length > 0){
                [editEditor setText:fieldText];
            }
            else{
                [editEditor setPlaceholder:fieldNames[i]];
            }
        }
        else {
            [editEditor setPlaceholder:fieldNames[i]];
        }
        
        //写代码没有小心，原来是这个里的index:0出了问题。
//        if([SJKHEngine Instance]->jbzl_user_datas.count > 0){
//            NSString * editorText = [[SJKHEngine Instance]->jbzl_user_datas objectAtIndex:i];
//            if(editorText && editorText.length > 0){
//                [editEditor setText:editorText];
//            }
//        }
        
        [editEditor setTextColor: FieldFontColor];
        
        if(i > fieldNames.count - 3){
//            labelHeight + ButtonHeight + (localVericalSpace + fieldHeight) * i
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake (editEditor.frame.size.width - ButtonHeight, ButtonHeight/2 - 30/2 , 30, 30)];
            btn.tag = JBZL_BUTTON_TAG + i;
            [btn setBackgroundImage:[UIImage imageNamed:@"select_arrow_default"] forState:UIControlStateNormal];
            [btn addTarget: self action: @selector(onButtonClick:) forControlEvents: UIControlEventTouchUpInside];
            
//            [editEditor addGestureRecognizer:tapFieldGesture];
            [editEditor addSubview:[self tapButtonForLastThreeField:CGRectMake(0, 0, editEditor.frame.size.width - btn.frame.size.width, editEditor.frame.size.height)]];
            
            [editEditor addSubview:btn];
        }
        
        if(i == 5){
            [scrollView addSubview:totalView];
        }
        else{
            [scrollView addSubview:editEditor];
        }
        
        [self initFields:editEditor index:i];
    }
    
    [self InitNextStepButton:CGRectMake(levelSpace,
                                        labelHeight + ButtonHeight + (localVericalSpace + fieldHeight) * i ,
                                        screenWidth - 2*levelSpace ,
                                        fieldHeight + 3)
                         tag:JBZL_VIEW_TAG + i + 1
                       title:@"下一步"];
    [scrollView addSubview:nextStepBtn];
    normalSize = CGSizeMake(screenWidth, nextStepBtn.frame.origin.y + fieldHeight + 3 * localVericalSpace);
    [scrollView setContentSize:normalSize];
    
    [self.view addSubview:scrollView];
    
    [self addGesture:scrollView];
    
    if([SJKHEngine Instance]->systemVersion < 6){
        singleTapRecognizer.delegate = self;
    }
}

- (UIButton *)tapButtonForLastThreeField:(CGRect)frame{
    UIButton * tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.frame = frame;
    [tapButton setBackgroundColor:[UIColor clearColor]];
    [tapButton addTarget:self action:@selector(onFieldTapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return tapButton;
}

- (void)initFields:(UITextField *)field index:(int)index{
    [fields addObject:field];
    
    switch (index) {
        case 0:
            xmField = field;
            break;
        case 1:
            sfzhmField = field;
            break;
        case 2:
            zjdzField = field;
            break;
        case 3:
            lxdzField = field;
            break;
        case 4:
            ybField = field;
            break;
        case 5:
            zjyxqField = field;
            break;
        case 6:
            zhiyeField = field;
            break;
        case 7:
            xueliField = field;
            break;
    }
}

- (void)onFieldClick:(UIGestureRecognizer *)gesture{
    UITextField * field = (UITextField *)gesture.view;
    
    //职业下拉框
    if(field == zhiyeField){
        [self showCustomAlertViewSelectItem:YES param:nil];
    }
    //学历下拉框
    if(field == xueliField){
        [self showCustomAlertViewSelectXL:YES param:nil];
    }
    
    if(field == zjyxqField){
        [self onLoginTimeButtonClick:showPickerButton];
    }
}

- (void)onFieldTapButtonClick:(UIButton *)btn{
    //职业下拉框
    if(btn.superview == zhiyeField){
        [self showCustomAlertViewSelectItem:YES param:nil];
    }
    //学历下拉框
    if(btn.superview == xueliField){
        [self showCustomAlertViewSelectXL:YES param:nil];
    }
    
    if(btn.superview == zjyxqField){
        [self onLoginTimeButtonClick:showPickerButton];
    }
}

- (void)onLoginTimeButtonClick:(UIButton *)btn{
    if(btn == longTimeButton){
        [zjyxqField setText:btn.titleLabel.text];
    }
    else if(btn == showPickerButton){
        [scrollView setUserInteractionEnabled:NO];
        [flatDatePicker setHidden:NO];
        [self.view bringSubviewToFront:flatDatePicker];
        [flatDatePicker show];
    }
}

- (void) showCustomAlertViewContent:(BOOL)isShow htmlString:(NSString *)htmlString{
    if(isShow){
        [[SJKHEngine Instance] createCustomAlertView];
        [SJKHEngine Instance]->_customAlertView->htmlKey = XYZRS_NAME;
        [[SJKHEngine Instance]->_customAlertView setTarget:self withSEL:@selector(showCustomAlertViewContent:htmlString:)];
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:YES htmlString:htmlString];
    }
    else{
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:NO htmlString:nil];
        [SJKHEngine Instance]->_customAlertView = nil;
    }
}

//职业下拉框
- (void) showCustomAlertViewSelectItem:(BOOL)isShow param:(NSString *)param{
    if(isShow){
        [[SJKHEngine Instance] createCustomAlertView];
        [[SJKHEngine Instance]->_customAlertView setTarget:self withSEL:@selector(showCustomAlertViewSelectItem:param:)];
        [[SJKHEngine Instance]->_customAlertView toSetTitleLabel:@"请选择职业"];
//        [[SJKHEngine Instance]->_customAlertView setShowSearchAndRelayoutSubviews:@"搜索职业"];
        [[SJKHEngine Instance] JBZLCustomAlertViewSelect:YES DataType:ZHIYE_DATA_TYPE];
    }
    else{
        if(param && param.length > 0){
            int location =[param rangeOfString:@"&"].location;
            NSString * itemString = [param substringToIndex:location];
            [tipIDs setObject:[param substringFromIndex:location+1] forKey:itemString];
            [zhiyeField setText:itemString];
        }
        [[SJKHEngine Instance] JBZLCustomAlertViewSelect:NO DataType:ZHIYE_DATA_TYPE];
    }
}

//学历下拉框
- (void) showCustomAlertViewSelectXL:(BOOL)isShow param:(NSString *)param{
    if(isShow){
        if([SJKHEngine Instance]->jbzl_step_Dic == nil ||
           [SJKHEngine Instance]->jbzl_step_Dic.count == 0)
        {
            [self performSelector:@selector(stopHUDTip) withObject:nil afterDelay:10];
            return ;
        }
        
        [[SJKHEngine Instance] createCustomAlertView];
        [[SJKHEngine Instance]->_customAlertView setTarget:self withSEL:@selector(showCustomAlertViewSelectXL:param:)];
        [[SJKHEngine Instance]->_customAlertView toSetTitleLabel:@"请选择学历"];
//        [[SJKHEngine Instance]->_customAlertView setShowSearchAndRelayoutSubviews:@"搜索学历"];
        [[SJKHEngine Instance] JBZLCustomAlertViewSelect:YES DataType:XUELI_DATA_TYPE];
    }
    else{
        if(param && param.length > 0){
            int location =[param rangeOfString:@"&"].location;
            NSString * itemString = [param substringToIndex:location];
            [tipIDs setObject:[param substringFromIndex:location+1] forKey:itemString];
            [xueliField setText:itemString];
        }
        
        [[SJKHEngine Instance] JBZLCustomAlertViewSelect:NO DataType:XUELI_DATA_TYPE];
    }
}

- (void)stopHUDTip{
    if([SJKHEngine Instance]->jbzl_step_Dic == nil ||
       [SJKHEngine Instance]->jbzl_step_Dic.count == 0)
    {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1];
        hud = nil;
    }
}

- (void)stopHUDOCRTip{
    if(jbzl_step_OCR_Dic == nil ||
       jbzl_step_OCR_Dic.count == 0)
    {
        hud.labelText = @"照片识别失败";
        [hud hide:YES afterDelay:1];
        hud = nil;
    }
}

- (void) onButtonClick:(UIButton *)btn{
    [self resignAllResponse];
    
//    if(btn.tag == MarkBtnTag){
//        if(!btn.isSelected){
//            [btn setBackgroundImage:[UIImage imageNamed:@"checkBox_checked"] forState:UIControlStateNormal];
//            [btn setSelected:YES];
//            [self chageNextStepButtonStype:YES];
//        }
//        else{
//            [btn setBackgroundImage:[UIImage imageNamed:@"checkBox_default"] forState:UIControlStateNormal];
//            [btn setSelected:NO];
//            [self chageNextStepButtonStype:NO];
//        }
//    }
    //职业下拉框
    if(btn.tag == JBZL_BUTTON_TAG + fieldNames.count - 2){
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.2];
//        btn.layer.transform = CATransform3DMakeRotation(M_PI/2, 0,0, 1);
//        [CATransaction commit];
        [self showCustomAlertViewSelectItem:YES param:nil];
    }
    //学历下拉框
    else if(btn.tag == JBZL_BUTTON_TAG + fieldNames.count - 1){
        [self showCustomAlertViewSelectXL:YES param:nil];
    }
    //下一步
    else if(btn == nextStepBtn){
//        if(((UIButton *)[requestZRS viewWithTag:MarkBtnTag]).isSelected){
//            UITextField * sfzField = ((UITextField *)[scrollView viewWithTag:JBZL_VIEW_TAG + 1]);
//            NSLog(@"sfzfield =%@,%@",sfzField.text,sfzField);
            [self gotoVideoWitness];
//        }
//        else{
//            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请阅读申请责任书" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alertview show];
//        }
    }
}

- (void)dealloc{
    jbzl_step_OCR_Dic = nil;
    jbzl_enterData_Dic = nil;
    
    singleTapRecognizer.delegate = nil;
    singleTapRecognizer = nil;
    
    fieldNames = nil;
    fieldTexts = nil;
    [tipField removeFromSuperview];
    tipField = nil;
    [fieldKeys removeAllObjects];
    requestZRS = nil;
    [tipIDs removeAllObjects];
    ocusView = nil;
    [characterLimtedWarnArr removeAllObjects];
    characterLimtedWarnArr = nil;
    [nullCharacterWarnArr removeAllObjects];
    nullCharacterWarnArr = nil;
    [showPickerButton removeFromSuperview];
    showPickerButton = nil;
    [longTimeButton removeFromSuperview];
    longTimeButton = nil;
    
    [xmField removeFromSuperview];
    xmField = nil;
    [sfzhmField removeFromSuperview];
    sfzhmField = nil;
    [zjdzField removeFromSuperview];
    zjdzField = nil;
    [lxdzField removeFromSuperview];
    lxdzField = nil;
    [ybField removeFromSuperview];
    ybField = nil;
    [zjyxqField removeFromSuperview];
    zjyxqField = nil;
    [zhiyeField removeFromSuperview];
    zhiyeField = nil;
    [xueliField removeFromSuperview];
    xueliField = nil;
    [fields removeAllObjects];
    fields = nil;
    [flatDatePicker removeFromSuperview];
    flatDatePicker = nil;
    tapFieldGesture = nil;
    
    NSLog(@"回收客户信息");
}

//进入视频见证时所做的操作
- (void) gotoVideoWitness{
    NSDictionary * dic = nil;
    NSString *warnStr = nil;
    BOOL all_write = YES;
    
    for (int i =0 ;i<fields.count ; i++) {
        UIView * vi = [fields objectAtIndex:i];
        if([vi isMemberOfClass:[UITextField class]]){
            UITextField * field = (UITextField *)vi;
            NSString * fieldContent = field.text;
            [PublicMethod trimText:&fieldContent];
            if(fieldContent.length == 0 || fieldContent == nil){
                all_write = NO;
                break;
            }
        }
    }
    
    if(all_write){
        if(![PublicMethod validateIdentityCard:[sfzhmField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]]])
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的身份证号" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            return ;
        }
        if(![PublicMethod isAdultManByIdentifyCard:[sfzhmField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"未满十八周岁的中国公民不允许开立证券账户" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            return ;
        }
        if(![zjyxqField.text isEqualToString:@"长期"] && ![PublicMethod isCardValidByYXQ:[zjyxqField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]])
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请使用在有效期内的本人身份证办理开户" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            return ;
        }
        
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"我已确认以上信息真实有效" delegate:self cancelButtonTitle:@"修改" otherButtonTitles:@"确定", nil];
        [alertview show];
        alertview.tag = 1022;
        return ;
    }
    else{
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户信息还没输入完全,请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
    }
}

- (void)onGoToVideoWitness{
    NSDictionary * dic = nil;
    NSMutableDictionary * jsonDic = [NSMutableDictionary dictionary];
    NSString * fieldContent ;
    
    /*
     fieldNames = [NSArray arrayWithObjects:@"姓   名",@"身份证号码",@"证件地址",@"联系地址",@"邮   编",@"证件有效期",@"职   业",@"学   历",nil];
     
     //        基本资料传送数据：""jbzl"":{""KHXM"":""金连燕"",""ZJBH"":""330321196107036321"",""ZJDZ"":""福建省福州市鼓楼区软件园A区11#"",""ZJFZJG"":""福州市鼓楼区公安局"",""XB"":""2"",""CSRQ"":""19860410"",""MZDM"":""1"",""DZ"":""福建省福州市鼓楼区软件园A区11#"",""ZJYXQ"":""20281230"",""YZBM"":""350000"",""ZYDM"":""3"",""XL"":""2"",""ZJLB"":0,""GJ"":156,""XYSTR"":[{""HTXY"":""31"",""XYBH"":"""",""QMLSH"":""""}]}
     */
    
    [self activityIndicate:YES tipContent:@"正在进行身份证验证..." MBProgressHUD:nil target:self.navigationController.view];
    
//        NSThread * khsfnzThread = [[NSThread alloc]initWithTarget:self selector:@selector(dispatchSendKHSFNZOperation) object:nil];
//        [khsfnzThread start];
    
    [self performSelectorInBackground:@selector(dispatchSendKHSFNZOperation) withObject:nil];
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    while (!bSfnzEnd) {
        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    //        [khsfnzThread start];
    //        [self performSelector:@selector(dispatchSendKHSFNZOperation) onThread:khsfnzThread withObject:nil waitUntilDone:YES];
    
    //        [NSThread detachNewThreadSelector:@selector(dispatchSendKHSFNZOperation) toTarget:self withObject:nil];
    
    //        sleep(1);
    //        [self performSelectorOnMainThread:@selector(dispatchSendKHSFNZOperation) withObject:nil waitUntilDone:YES];
    
    //        [self performSelector:@selector(dispatchSendKHSFNZOperation) onThread:khsfnzThread withObject:nil waitUntilDone:YES];
    
    bSfnzEnd = NO;
    
    if(!bSfnzResult){
        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:sSfnzNote delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertview.delegate = self;
        [alertview show];
        
        return ;
    }
    
    for(int i = 0; i < fields.count ;i++){
        fieldContent = ((UITextField *)[fields objectAtIndex:i]).text;
        [PublicMethod trimText:&fieldContent];
        
        switch (i) {
            case 0:
                [jsonDic setObject:fieldContent forKey:KHXM_OCR];
                break;
                
            case 1:
                [jsonDic setObject:fieldContent forKey:ZJBH_OCR];
                break;
                
            case 2:
                [jsonDic setObject:fieldContent forKey:ZJDZ_OCR];
                break;
                
            case 3:
                
                break;
                
            case 4:
                [jsonDic setObject:fieldContent forKey:YZBM_OCR];
                break;
                
            case 5:
                
                break;
                
            case 6:
            {
                NSString *zydm = [tipIDs objectForKey:fieldContent];
                NSLog(@"zydm = %@",zydm);
                if(zydm || zydm.length == 0){
                    zydm = [self getSelectZYOrXLID:fieldContent type:ZHIYE_DATA_TYPE];
                }
                [jsonDic setObject:zydm forKey:ZY_UPLOAD_JBZL];
                break;
            }
            case 7:
            {
                NSString *xldm = [tipIDs objectForKey:fieldContent];
                NSLog(@"xldm = %@",xldm);
                if(xldm || xldm.length == 0){
                    xldm = [self getSelectZYOrXLID:fieldContent type:XUELI_DATA_TYPE];
                }
                [jsonDic setObject:xldm forKey:XL_UPLOAD_JBZL];
                break;
            }
        }
    }
    
    // 证件类别先传0
    [jsonDic setObject:@"0" forKey:ZJLB_OCR];
    [jsonDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",XYBH_OCR,@"",QMLSH_CGYH,HTXYID,HTXY_CGYH,nil] forKey:XYSTR_OCR];
    [jsonDic setObject:@"156" forKey:GJ_OCR];
    [jsonDic setObject:zjdzField.text forKey:DZ_UPLOAD_JBZL];
    
    NSString * ocrString = [jbzl_step_OCR_Dic objectForKey:ZJYXQ_OCR];
    if(ocrString && ocrString.length > 0){
        [jsonDic setObject:ocrString forKey:ZJYXQ_OCR];
    }
    else{
        ocrString = zjyxqField.text;
        [jsonDic setObject:ocrString forKey:ZJYXQ_OCR];
    }
    
    if (jbzl_step_OCR_Dic) {
        [jsonDic setObject:[jbzl_step_OCR_Dic objectForKey:XB_OCR] forKey:XB_OCR];
        [jsonDic setObject:[jbzl_step_OCR_Dic objectForKey:ZJFZJG_OCR] forKey:ZJFZJG_OCR];
        NSString * csrqOCR = [jbzl_step_OCR_Dic objectForKey:CSRQ_OCR];
        [PublicMethod filterNumber:&csrqOCR];
        [jsonDic setObject:csrqOCR forKey:CSRQ_OCR];
        [jsonDic setObject:[jbzl_step_OCR_Dic objectForKey:MZDM_OCR] forKey:MZDM_OCR];
    }
    
    [self activityIndicate:YES tipContent:@"保存数据..." MBProgressHUD:nil target:self.navigationController.view];
    [self sendSaveStepInfo:JBZL_STEP dataDictionary:&dic arrar:jsonDic];
    
    while (!bSaveStepFinish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    bSaveStepFinish = NO;
    
    if(bSaveStepSuccess){
        [SJKHEngine Instance]->jbzl_cache_dic = [jsonDic mutableCopy];
        VideoWitnessViewCtrl * videoWitnessVC = [[VideoWitnessViewCtrl alloc]initWithNibName:@"VideoWitnessView" bundle:nil];
        [self activityIndicate:YES tipContent:@"加载视频信息..." MBProgressHUD:nil target:self.navigationController.view];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self dispatchViewWitnessData:videoWitnessVC];
        });
    }
    else{
        NSLog(@"保存失败 =%@",dic);
        [self activityIndicate:NO tipContent:@"保存失败" MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void)dispatchSendKHSFNZOperation{
    NSDictionary * dic = nil;
    NSString * sfzhmText = sfzhmField.text;
    [PublicMethod trimText:&sfzhmText];
    bSfnzResult = [self toSendKHSFNZ:&dic sourceArray:[NSArray arrayWithObjects:@"0",sfzhmText, nil]];
    
    if([dic objectForKey:NOTE]){
        sSfnzNote = [dic objectForKey:NOTE];
        bSfnzEnd = YES;
    }
    bSfnzEnd = YES;
}

//如果失败，要不要作重连处理；加上saveCurrentStep的排错处理
- (void) dispatchViewWitnessData:(VideoWitnessViewCtrl *)videoWitnessVC{
    NSDictionary * stepDictionary = nil;
    if([self sendSaveCurrentStepKey:SPJZ_STEP dataDictionary:&stepDictionary]){
        BOOL ok = [self sendGoToStep:SPJZ_STEP dataDictionary:&stepDictionary];
        if(ok){
            [SJKHEngine Instance]->spzj_step_Dic = [stepDictionary mutableCopy];
        }
        BOOL uuidOK = [self sendGetUUID:&stepDictionary];
        if(uuidOK){
            videoWitnessVC->uuid = [stepDictionary objectForKey:UUID];
        }
        else {
            [self activityIndicate:NO tipContent:@"获取视频数据失败" MBProgressHUD:nil target:self.navigationController.view];
            return ;
//            [[SJKHEngine Instance] dispatchMessage:POP_MESSAGE];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(ok && uuidOK){
                [SJKHEngine Instance]->customerName = xmField.text;
                [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                [self.navigationController pushViewController:videoWitnessVC animated:YES];
//                [self saveUserData];
                
                if ([SJKHEngine Instance]->spzj_step_Dic &&
                    [SJKHEngine Instance]->spzj_step_Dic.count > 0)
                {
                    [videoWitnessVC updateUI];
                }
                else{
                    [self activityIndicate:NO tipContent:@"加载视频信息失败" MBProgressHUD:nil target:self.navigationController.view];
                }
            }
            else{
                [self activityIndicate:NO tipContent:@"加载视频信息失败" MBProgressHUD:nil target:self.navigationController.view];
            }
        });
    }
}

- (void)saveUserData{
    if([SJKHEngine Instance]->jbzl_user_datas.count > 0 && [SJKHEngine Instance]->jbzl_user_datas){
        for (int i =0 ;i<fields.count ; i++) {
            UITextField * vi = [fields objectAtIndex:i];
            if(vi.text.length > 0 && vi.text){
                [[SJKHEngine Instance]->jbzl_user_datas replaceObjectAtIndex:vi.tag - JBZL_VIEW_TAG withObject:vi.text];
            }
        }
    }
}

//异步加载责任书数据
- (void) loadTaskBook{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * taskBook = nil;
        BOOL ok= [self sendTaskBook:&taskBook];
        if (taskBook && taskBook.count > 0 && ok)
        {
            [[taskBook objectForKey:XYNR] writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:XYZRS_NAME] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SJKHEngine Instance] updateAlertViewUI:YES];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SJKHEngine Instance] updateAlertViewUI:NO];
            });
        }
    });
}

- (void) ServerAuthenticate:(REQUEST_TYPE)request_type{
    
}

- (void)updateUI{
    [super updateUI];
    
    if(!self.isViewLoaded){
        return ;
    }
    
    NSArray * arr = [[SJKHEngine Instance]->jbzl_step_Dic objectForKey:SZZRSARR];
    if (arr.count > 0) {
        NSDictionary * dic = [arr objectAtIndex:0];
        HTXYID= [dic objectForKey:ID];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0 ; i < fields.count ;i++) {
            NSString * fieldText = [jbzl_step_OCR_Dic objectForKey:[fieldKeys objectAtIndex:i]];
            
//            if([SJKHEngine Instance]->jbzl_user_datas.count > 0 && [SJKHEngine Instance]->jbzl_user_datas){
//                UITextField * vi = [fields objectAtIndex:i];
//                NSString * text = [[SJKHEngine Instance]->jbzl_user_datas objectAtIndex:vi.tag - JBZL_VIEW_TAG];
//                if(text.length > 0 && text){
//                    vi.text = text;
//                    continue ;
//                }
//            }
            
            switch (i) {
                case 0:
                {
                    if(fieldText.length > 8){
                        fieldText = [fieldText substringToIndex:8];
                    }
                    
                    [xmField setText:fieldText];
                    break;
                }
                    
                case 1:
                {
                    if(fieldText.length > 30){
                        fieldText = [fieldText substringToIndex:30];
                    }
                    [sfzhmField setText:fieldText];
                    break;
                }
                    
                case 2:
                {
                    if(fieldText.length > 50){
                        fieldText = [fieldText substringToIndex:50];
                    }
                    [zjdzField setText:fieldText];
                    break;
                }
                    
                case 3:
                {
                    fieldText = [jbzl_step_OCR_Dic objectForKey:ZJDZ_OCR];
                    if(fieldText.length > 50){
                        fieldText = [fieldText substringToIndex:50];
                    }
                    [lxdzField setText:fieldText];
                    break;
                }
                    
                case 4:
                {
                    if(fieldText.length > 6){
                        fieldText = [fieldText substringToIndex:6];
                    }
                    if(![fieldText isEqualToString:@"000000"]){
                        [ybField setText:fieldText];
                    }
                    
                    break;
                }
                    
                case 5:
                {
                    [zjyxqField setText:fieldText];
                    break;
                }
            }
        }
    });
}

#pragma textfield Delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithArray: scrollView.subviews]];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithArray: scrollView.subviews]];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bKeyBoardShow = YES;
    
    keyboardOffset = textField.frame.origin.y + ButtonHeight - (screenHeight - UpHeight - KeyBoardHeight);
    textField.layer.borderColor = TEXTFEILD_BOLD_HIGHLIGHT_COLOR.CGColor;
    
    if(keyboardOffset > 0){
        [self beginEdit:YES textFieldArrar:nil];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString * fieldText = [NSString stringWithFormat:@"%@%@", textField.text , string];
    
//    NSLog(@"fieldtext =%@",fieldText);
//    if(textField.markedTextRange){
//        NSRange range = [fieldText rangeOfString:[textField textInRange:textField.markedTextRange]];
//        fieldText = [fieldText stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length + 1) withString:@""];
//        NSLog(@"fieldtext 2=%@,%@",fieldText,[textField textInRange:textField.markedTextRange]);
//        return YES;
//    }
    
    /*
     姓名:8个汉字
     身份证号:30个字符，包括数字和字母
     证件地址:50个汉字
     联系地址:50个汉字
     邮编:6个数字，必须刚好6个汉字
     */
    
//    if(fieldText.length> 8 && textField == xmField){
//        [xmField setText:[fieldText substringToIndex:7]];
//    }
//    if(fieldText.length> 30 && textField == sfzhmField){
//        [sfzhmField setText:[fieldText substringToIndex:30]];
//    }
//    if(fieldText.length> 50 && textField == zjdzField){
//        [zjdzField setText:[fieldText substringToIndex:50]];
//    }
//    if(fieldText.length> 50 && textField == lxdzField){
//        [lxdzField setText:[fieldText substringToIndex:50]];
//    }
//    if(fieldText.length> 6 && textField == ybField){
//        [ybField setText:[fieldText substringToIndex:50]];
//    }
//    if ([string isEqualToString:@"x"] && textField == sfzhmField) {
////        [self activityIndicate:NO tipContent:@"身份证末尾须是大写的'X'" MBProgressHUD:Nil target:self.navigationController.view];
//        
////        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入大写字母'X'" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////        alertview.delegate = self;
////        [alertview show];
//        
//        return YES;
//    }
    
    return  YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == zjyxqField ||
       textField == zhiyeField ||
       textField == xueliField)
    {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor = FieldNormalColor.CGColor;
}

- (void)scrollViewWillBeginDragging: (UIScrollView *)_scrollView
{
    [self resignAllResponse];
}

- (void)OnTouchDownResign:(UIControl *)control{
    [self resignAllResponse];
}

- (void)reposControl{
    int offset = 0;
    
	if (bKeyBoardShow)
	{
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.frame = CGRectMake(0, offset-(keyboardOffset + verticalHeight), screenWidth, screenHeight - UpHeight );
        }completion:^(BOOL finish){
            
        }];
	}
	else
	{
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.frame = CGRectMake(0, offset, screenWidth, screenHeight - UpHeight  );
        }
        completion:^(BOOL finish){
            
        }];
	}
}

#pragma DataEngineOberver protocol
//当加载失败时，自动保存用户输入的数据，并加入内存中。
- (void)popToLastPage{
//    dispatch_async(dispatch_get_main_queue(), ^{
////        [self activityIndicate:YES tipContent:@"加载失败" MBProgressHUD:nil];
//        hud.mode = MBProgressHUDModeText;
//        sleep(2);
//        [hud hide:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//    });
    
    [[SJKHEngine Instance]->_customAlertView removeFromSuperview];
    [SJKHEngine Instance]->_customAlertView = nil;
    
    NSArray * ar = self.navigationController.viewControllers;
    BaseViewController * preVC = [ar objectAtIndex:ar.count - 2];
    
    
    if([SJKHEngine Instance]->yxData.count == 0 || [SJKHEngine Instance]->yxData == nil ||
       [SJKHEngine Instance]->yxcj_step_Dic.count == 0 || [SJKHEngine Instance]->yxcj_step_Dic.count == 0)
    {
        preVC->bReEnter = YES;
        [[SJKHEngine Instance]->rootVC popToZDPage:YXCJ_STEP preVC:preVC];
    }
    else{
        preVC->bReEnter = YES;
        [self.navigationController popViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
    }
    
    [super popToLastPage];
    
//    [self saveUserData];
}

- (void)failGetOcrData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide:YES];
        [self activityIndicate:NO tipContent:Nil MBProgressHUD:Nil target:self.navigationController.view];
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片识别失败,您需要重新上传照片进行识别么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertview.delegate = self;
        [alertview show];
    });
}

- (void)resignAllResponse{
    [self beginEdit:NO textFieldArrar:fields];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(alertView.tag == 1022){
//            [self onGoToVideoWitness];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(alertView.tag == 1022){
//            [self performSelectorInBackground:@selector(onGoToVideoWitness) withObject:nil];
//            [self onGoToVideoWitness];
            [self performSelector:@selector(onGoToVideoWitness) withObject:nil afterDelay:0.3];
        }
        else {
            [super alertView:alertView clickedButtonAtIndex:buttonIndex];
        }
    }
}

- (void)flatDatePicker:(FlatDatePicker *)datePicker didCancel:(UIButton *)sender{
    [scrollView setUserInteractionEnabled:YES];
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    [scrollView setUserInteractionEnabled:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }
    else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    [zjyxqField setText:value];
}

- (NSString *)getSelectZYOrXLID:(NSString *)selectContent type:(SELECT_DATA_TYPE)type{
    NSString * dataKey = ZYDM;
    NSString * idValue = @"";
    switch (type) {
        case ZHIYE_DATA_TYPE:
            dataKey = ZYDM;
            break;
            
        case XUELI_DATA_TYPE:
            dataKey = XLDM;
            break;
    }

    NSDictionary * xldmDic = [[SJKHEngine Instance]->jbzl_step_Dic objectForKey:dataKey];
    if(xldmDic){
        NSMutableArray * recordsDic = [xldmDic objectForKey:RECORDS];
        for (NSDictionary * dic in recordsDic) {
            if([[dic objectForKey:UPNOTE] isEqualToString:selectContent]){
                idValue = [dic objectForKey:IBM];
                break;
            }
        }
    }
    
    return idValue;
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    CGPoint point1 = [gestureRecognizer locationInView:longTimeButton];
//    CGPoint point2 = [gestureRecognizer locationInView:showPickerButton];
//    CGPoint point3 = [gestureRecognizer locationInView:scrollView];
//    
////    NSLog(@"frame =%@,%@,%@",
////          NSStringFromCGRect([longTimeButton convertRect:longTimeButton.frame toView:scrollView]),
////          NSStringFromCGPoint([longTimeButton convertPoint:point fromView:scrollView]),
////          NSStringFromCGPoint([longTimeButton convertPoint:point toView:scrollView]));
////    
////    NSLog(@"CGRectContainsPoint(longTimeButton.frame, [longTimeButton convertPoint:point fromView:scrollView]) =%i,%i",
////          CGRectContainsPoint(longTimeButton.frame, [longTimeButton convertPoint:point fromView:scrollView]) ,
////          CGRectContainsPoint(showPickerButton.frame, [showPickerButton convertPoint:point fromView:scrollView]));
//    
////    NSLog(@"frame =%@,%@,%@,%@,%i,%i",
////          NSStringFromCGPoint(point1),
////          NSStringFromCGPoint(point2),
////          NSStringFromCGRect(longTimeButton.frame),
////          NSStringFromCGRect(showPickerButton.frame),
////          CGRectContainsPoint(longTimeButton.frame, point1),
////          CGRectContainsPoint(showPickerButton.frame, point2)
////          );
//    
//    BOOL bLongTimeContain = (longTimeButton.frame.size.width > point1.x) &&
//                            (longTimeButton.frame.size.height > point1.y) &&
//                            (point1.x > 0) &&
//                            (point1.y > 0);
//    BOOL bShowPickerContain = (showPickerButton.frame.size.width > point2.x) &&
//                              (showPickerButton.frame.size.height > point2.y) &&
//                              (point2.x > 0) &&
//                              (point2.y > 0);
//    BOOL bNextStepContain = CGRectContainsPoint(nextStepBtn.frame, point3);
//        
//    if(bLongTimeContain || bShowPickerContain || bNextStepContain)
//    {
//        return NO;
//    }
//    
//    return YES;
//}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    NSLog(@"gestureRecognizerShouldBegin");
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    NSLog(@"shouldRequireFailureOfGestureRecognizer %@,%@",gestureRecognizer,otherGestureRecognizer);
//    if(gestureRecognizer == singleTapRecognizer && otherGestureRecognizer == tapFieldGesture){
////        if (otherGestureRecognizer.view == zjyxqField ||
////            otherGestureRecognizer.view == zhiyeField ||
////            otherGestureRecognizer.view == xueliField)
////        {
////            return YES;
////        }
//        
//        return YES;
//    }
//    
//    return NO;
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer =%@",otherGestureRecognizer);
//    return true;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    NSLog(@"shouldBeRequiredToFailByGestureRecognizer: %@",otherGestureRecognizer);
//    
//    return YES;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    if(gestureRecognizer == tapFieldGesture){
//        if(touch.view == zjyxqField ||
//        touch.view == zhiyeField ||
//           touch.view == xueliField)
//        {
//            return YES;
//        }
//    }
    
    if(touch.view == [xmField valueForKey:@"_clearButton"] ||
       touch.view == [sfzhmField valueForKey:@"_clearButton"] ||
       touch.view == [zjdzField valueForKey:@"_clearButton"] ||
       touch.view == [lxdzField valueForKey:@"_clearButton"] ||
       touch.view == [ybField valueForKey:@"_clearButton"] ||
       touch.view == [zjyxqField valueForKey:@"_clearButton"] ||
       touch.view == [zhiyeField valueForKey:@"_clearButton"] ||
       touch.view == [xueliField valueForKey:@"_clearButton"] ||
       touch.view == longTimeButton ||
       touch.view == showPickerButton ||
       touch.view == nextStepBtn ||
       touch.view.superview == zjyxqField ||
       touch.view.superview == xueliField ||
       touch.view.superview == zhiyeField)
    {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)httpFinished:(ASIHTTPRequest *)http{
    [super httpFailed:http];
}

- (void)httpFailed:(ASIHTTPRequest *)http{
    [super httpFailed:http];
}


@end
