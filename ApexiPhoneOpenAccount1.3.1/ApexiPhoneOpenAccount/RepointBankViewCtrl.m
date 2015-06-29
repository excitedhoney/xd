#import "RepointBankViewCtrl.h"
#import "LookProcessViewCtrl.h"
#import "UIImage+custom_.h"
#import "CertHandle.h"

#define CHOOSE_FRAME CGRectMake(levelSpace, labelHeight + 5, (screenWidth - 3 * levelSpace)/2, itemHeight)

#define ITEMBTNTAG 925

#define ReSelectButton 219

@interface RepointBankViewCtrl (){
    UIView * initCenterView;
    UIView * detailCenterView;
    UIImageView * triangleView;
    int labelHeight;
    int slideOffset;
    int itemIndex;
    int itemSetIndex;
    int centerHeight;
    int itemHeight ;
    int xyID;
    UIButton * headerBtn;
    UIView * enterFieldSecret;
    UITextField * phoneEditor;
    UITextField * passwordEditor;
    NSDictionary * currentDataSource;
    NSString * htmlFileKey;
    NSString *delegateContentString;
    UIButton * readCGXY;
    UIControl * touchControl;
    CGRect viewFrame;
    UILabel *warnLab;
    
    UIButton *_choosedBtn;
}

@end

@implementation RepointBankViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)init{
    self = [super init];
    if(self){
        //        [self InitConfig];
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
    viewFrame = self.view.frame;
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self addGesture:self.navigationController.navigationBar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    NSLog(@"ges =%@",self.navigationController.navigationBar.gestureRecognizers);
    //    [self.navigationController.navigationBar removeGestureRecognizer:singleTapRecognizer];
}

- (void) InitConfig{
    slideOffset = 100;
    itemIndex = 0;
    centerHeight = 175;
    itemSetIndex = 0;
    itemHeight = 85;
    xyID = -1;
    htmlFileKey = @"XYNR";
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    [self.navigationItem setHidesBackButton:YES];
    
    
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIButton * backButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:FigureButtonTag + 1];
    [backButton setImage:[UIImage imageNamed:@"step_3"] forState:UIControlStateNormal];
    
    //    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector (OnKeyboardChangeFrame:) name: UIKeyboardDidShowNotification object: nil];
    //    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector (OnKeyboardWillHidden:) name: UIKeyboardWillHideNotification object: nil];
    
}

- (void)setViewBound{
    if([SJKHEngine Instance]->systemVersion < 7){
        self.view.bounds = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
        
    }
}

- (void)OnKeyboardChangeFrame:(NSNotification*)aNotification{
    [touchControl setHidden:NO];
    [enterFieldSecret bringSubviewToFront:touchControl];
}

- (void)OnKeyboardWillHidden:(NSNotification*)notification{
    [touchControl setHidden:YES];
}

- (void) InitWidgets{
    [self InitScrollView];
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    labelHeight = 40;
    
    UILabel *la=[[UILabel alloc]initWithFrame: CGRectMake(levelSpace, 0, screenWidth - levelSpace, labelHeight)];
	la.backgroundColor = [UIColor clearColor];
    [la setText:@"请选择银行"];
	[la setFont: TipFont];
    la.textAlignment = NSTextAlignmentLeft;
	[la setTextColor: GrayTipColor_Wu];
    la.lineBreakMode = NSLineBreakByTruncatingTail;
    [scrollView addSubview:la];
    
    headerBtn = [[UIButton alloc]init];
    [headerBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [headerBtn setFrame:CGRectMake(levelSpace, labelHeight, screenWidth - levelSpace , ButtonHeight)];
    [headerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headerBtn setAlpha:0];
    [headerBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
    triangleView = [[UIImageView alloc] initWithImage: [[UIImage imageNamed:@"select_arrow_right"] ImageTintColor:ButtonColorNormal_Wu]];
    NSString * textTitle = @"其他银行";
    [headerBtn setTitle:textTitle forState:UIControlStateNormal];
    [headerBtn setTitleColor:ButtonColorNormal_Wu forState:UIControlStateNormal];
    headerBtn.titleLabel.font = TipFont;
    int width = [PublicMethod getStringWidth:textTitle font:TipFont] + 3;
    triangleView.frame = CGRectMake(width, ButtonHeight/2 - 20/2 , 20 , 20);
    [headerBtn addSubview:triangleView];
    [scrollView addSubview:headerBtn];
    
    [self createEnterFieldSecret];
    
    [self addGesture:scrollView];
    
    [super InitWidgets];
}

- (void) createEnterFieldSecret{
    enterFieldSecret = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               labelHeight + centerHeight + ButtonHeight,
                                                               screenWidth,
                                                               screenHeight - UpHeight - (labelHeight + centerHeight + ButtonHeight) + (itemHeight + 10 * 2))];
    [enterFieldSecret setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    [enterFieldSecret setAlpha:0];
    
    UILabel *tip=[[UILabel alloc]initWithFrame: CGRectMake(levelSpace, 0, screenWidth - 2 * levelSpace, labelHeight )];
	tip.backgroundColor = [UIColor clearColor];
    //    [tip setText:@"小提示:如果你的银行已经办理了其他券商三方存管，需要先解除才能办理哦"];
    [tip setText:@"填写银行卡信息"];
	[tip setFont: TipFont];
    tip.textAlignment = NSTextAlignmentLeft;
	[tip setTextColor: GrayTipColor_Wu];
    tip.lineBreakMode = NSLineBreakByTruncatingTail;
    tip.numberOfLines = 0;
    [enterFieldSecret addSubview:tip];
    
    phoneEditor = [[UITextField alloc] initWithFrame: CGRectMake(levelSpace  ,
                                                                 labelHeight + (itemHeight + 10 * 2),
                                                                 screenWidth - 2 * levelSpace,
                                                                 44)];
	phoneEditor.backgroundColor = [UIColor whiteColor];
	phoneEditor.borderStyle = UITextBorderStyleNone;
    [PublicMethod publicCornerBorderStyle:phoneEditor];
	phoneEditor.keyboardType = UIKeyboardTypeNumberPad;
    phoneEditor.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneEditor setTextAlignment:NSTextAlignmentLeft];
	[phoneEditor setFont: FieldFont];
    phoneEditor.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [phoneEditor setPlaceholder:@"请输入卡号"];
	[phoneEditor setTextColor: FieldFontColor];
    phoneEditor.delegate = self;
    [enterFieldSecret addSubview:phoneEditor];
    
    passwordEditor = [[UITextField alloc] initWithFrame: CGRectMake(levelSpace ,
                                                                    labelHeight + verticalHeight + ButtonHeight + (itemHeight + 10 * 2),
                                                                    screenWidth - levelSpace * 2,
                                                                    44)];
	passwordEditor.backgroundColor = [UIColor whiteColor];
	passwordEditor.borderStyle = UITextBorderStyleNone;
    [PublicMethod publicCornerBorderStyle:passwordEditor];
	passwordEditor.keyboardType = UIKeyboardTypeNumberPad;
    passwordEditor.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordEditor.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passwordEditor setTextAlignment:NSTextAlignmentLeft];
	[passwordEditor setFont: FieldFont];
    passwordEditor.delegate = self;
    [passwordEditor setPlaceholder:@"请输入密码"];
    [passwordEditor setSecureTextEntry:YES];
	[passwordEditor setTextColor: FieldFontColor];
    [enterFieldSecret addSubview:passwordEditor];
    
    readCGXY = [PublicMethod InitReadXY:@"我已阅读第三方存管协议"
                              withFrame:CGRectMake (levelSpace,
                                                    passwordEditor.frame.origin.y + 44 +verticalHeight,
                                                    screenWidth - 2 * levelSpace,
                                                    44)
                                    tag:MarkBtnTag + 1
                                 target:self];
    [enterFieldSecret addSubview:readCGXY];
    
    touchControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - UpHeight - KeyBoardHeight)];
    [touchControl addTarget:self action:@selector(OnTouchDownResign:) forControlEvents:UIControlEventTouchDown];
    [touchControl setHidden:YES];
    [touchControl setBackgroundColor:[UIColor clearColor]];
    [enterFieldSecret addSubview:touchControl];
    
    warnLab = [[UILabel  alloc] initWithFrame:CGRectMake(levelSpace, readCGXY.frame.origin.y + readCGXY.frame.size.height + verticalHeight, screenWidth - 2 * levelSpace, 30)];
    
    warnLab.backgroundColor = [UIColor clearColor];
    warnLab.text = @"友情提示：这里根据所选银行相关自定义提示填写，如果没有就设置为隐藏。";
    warnLab.textColor = [UIColor lightTextColor];
    warnLab.font = [UIFont systemFontOfSize:10];
    [enterFieldSecret addSubview:warnLab];
    
    [self InitNextStepButton:CGRectMake (levelSpace,
                                         readCGXY.frame.origin.y + readCGXY.frame.size.height + verticalHeight + 40,
                                         screenWidth - 2 * levelSpace,
                                         44)
                         tag:0
                       title:@"下一步"];
    [self chageNextStepButtonStype:NO];
    [enterFieldSecret addSubview:nextStepBtn];
    
    [self addGesture:enterFieldSecret];
    
    [enterFieldSecret setFrame:CGRectMake(0,
                                          labelHeight + centerHeight + ButtonHeight,
                                          screenWidth,
                                          nextStepBtn.frame.origin.y + nextStepBtn.frame.size.height + verticalHeight)];
    
    [scrollView addSubview:enterFieldSecret];
    
    //    [scrollView setContentSize:CGSizeMake(screenWidth, nextStepBtn.frame.origin.y + ButtonHeight +2*verticalHeight)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"event =%@",event);
}

- (void)reSelect:(UIButton *)btn{
    [scrollView setScrollEnabled:YES];
    phoneEditor.layer.borderColor = FieldNormalColor.CGColor;
    passwordEditor.layer.borderColor = FieldNormalColor.CGColor;
    
    UIButton * markSuperButton = (UIButton *)[scrollView viewWithTag:MarkBtnTag + 1];
    if(markSuperButton.selected){
        [self changeMarkState: markSuperButton];
    }
    
    [phoneEditor setText:@""];
    [passwordEditor setText:@""];
    currentDataSource = nil;
    
    //    [UIView animateWithDuration:.2f
    //                          delay:0
    //                        options:UIViewAnimationOptionCurveEaseOut
    //                     animations:^{
    //                         enterFieldSecret.alpha = 0;
    //                     }
    //                     completion:^(BOOL bl){
    //
    //                     }];
}

- (void)showMoreAnimation:(BOOL)bMoveDown{
    if(bMoveDown){
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        triangleView.layer.transform = CATransform3DMakeRotation(M_PI/2, 0,0, 1);
        [CATransaction commit];
        [enterFieldSecret setAlpha:0];
        
        [UIView animateWithDuration:.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [detailCenterView setAlpha:1];
                             [detailCenterView setFrame:CGRectMake(0,
                                                                   labelHeight*2 + centerHeight ,
                                                                   screenWidth,
                                                                   detailCenterView.frame.size.height)];
                         }
                         completion:^(BOOL bl){
                             
                         }];
        [scrollView setContentSize:CGSizeMake(screenWidth, detailCenterView.frame.origin.y + detailCenterView.frame.size.height )];
    }
    else{
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        triangleView.layer.transform = CATransform3DIdentity;
        [CATransaction commit];
        
        [UIView animateWithDuration:.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [detailCenterView setAlpha:0];
                             [detailCenterView setFrame:CGRectMake(0,
                                                                   labelHeight + centerHeight/2 ,
                                                                   screenWidth,
                                                                   detailCenterView.frame.size.height)];
                         }
                         completion:^(BOOL bl){
                             
                         }];
    }
}

- (void)showMore:(UIButton *)btn{
    if(bKeyBoardShow){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:phoneEditor,passwordEditor, nil]];
        return ;
    }
    [self reSelect:Nil];
    
    if(detailCenterView.alpha == 1){
        [self showMoreAnimation:NO];
    }
    else{
        [self showMoreAnimation:YES];
    }
}

- (void) updateUI{
    [super updateUI];
    
    [self createItemButtons];
    
    if(filterArray.count > 0){
        [UIView animateWithDuration:.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [initCenterView setAlpha:1];
                             [initCenterView setFrame:CGRectMake(0,
                                                                 labelHeight ,
                                                                 screenWidth,
                                                                 centerHeight)];
                             if(filterArray.count > 4){
                                 [headerBtn setAlpha:1];
                                 [headerBtn setFrame:CGRectMake(levelSpace,
                                                                labelHeight + centerHeight,
                                                                screenWidth - levelSpace,
                                                                44)];
                             }
                         }
                         completion:^(BOOL bl){
                             
                         }];
    }
}

- (void) createItemButtons{
    float itemSpace = (centerHeight - itemHeight * 2);
    //    initCenterView = [[UIView alloc]initWithFrame:CGRectMake(0,
    //                                                         labelHeight + verticalHeight,
    //                                                         screenWidth,
    //                                                         centerHeight)];
    initCenterView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                             labelHeight - slideOffset,
                                                             screenWidth,
                                                             centerHeight)];
    [initCenterView setBackgroundColor:[UIColor blueColor]];
    [initCenterView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    [initCenterView setAlpha:0];
    [scrollView addSubview:initCenterView];
    
    detailCenterView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               labelHeight + centerHeight/2,
                                                               screenWidth,
                                                               centerHeight/2)];
    [detailCenterView setBackgroundColor:[UIColor clearColor]];
    [detailCenterView setAlpha:0];
    [scrollView addSubview:detailCenterView];
    
    int itemSetNumber = filterArray.count/2 + filterArray.count%2;
    
    if(itemSetNumber == 0){
        return ;
    }
    
    if(itemSetNumber >= 2){
        for (int i= 0; i < 2 ; i++) {
            itemSetIndex ++;
            UIView *itemSetView = [self itemSetView:itemSetNumber];
            [itemSetView setFrame:CGRectMake(0, (itemSpace + itemHeight) * i, screenWidth, itemHeight)];
            [initCenterView addSubview:itemSetView];
        }
        for (int i= 0; i < itemSetNumber - 2 ; i++) {
            itemSetIndex ++;
            UIView *itemSetView = [self itemSetView:itemSetNumber];
            [itemSetView setFrame:CGRectMake(0, (itemSpace + itemHeight) * i , screenWidth, itemHeight)];
            [detailCenterView addSubview:itemSetView];
        }
    }
    
    [detailCenterView setFrame:CGRectMake(0,
                                          labelHeight + centerHeight/2,
                                          screenWidth,
                                          centerHeight/2 + (itemSetNumber - 2 )*centerHeight/2)];
    
    
    if(itemSetNumber == 1){
        itemSetIndex ++;
        [initCenterView addSubview:[self itemSetView:itemSetNumber]];
    }
    
    [scrollView addSubview:initCenterView];
    [scrollView addSubview:detailCenterView];
    
    [scrollView setContentSize:CGSizeMake(screenWidth, detailCenterView.frame.origin.y + detailCenterView.frame.size.height)];
}

- (UIView *)itemSetView:(int)itemSetNumber{
    float itemWidth = (screenWidth - 3*levelSpace)/2.0;
    UIView * itemSetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, itemHeight)];
    int setNumber = 2;
    
    if(itemSetNumber % 2 != 0 && itemSetIndex == itemSetNumber){
        setNumber = 1;
    }
    
    for (int i= 0; i < setNumber; i++) {
        UIButton * itemBtn = [[UIButton alloc]initWithFrame:CGRectMake (levelSpace + (levelSpace + itemWidth)*i,
                                                                        0,
                                                                        itemWidth,
                                                                        itemHeight)];
        if (itemIndex == filterArray.count) {
            break;
        }
        NSString * title = [filterArray objectAtIndex:itemIndex++];
        NSLog(@"%@",title);
        UIImage * image = [self getYHIcon:title];
        if (image) {
            NSLog(@"1");
        }else{
            NSLog(@"0");
        }
        if(image){
            [itemBtn setImage:image forState:UIControlStateNormal];
        }
        else{
            [itemBtn setBackgroundImage:[UIImage imageWithColor:LightGrayTipColor size:itemBtn.frame.size] forState:UIControlStateNormal];
        }
        
        //        [itemBtn setBackgroundColor:[UIColor lightGrayColor]];
        [PublicMethod publicCornerBorderStyle:itemBtn];
        itemBtn.tag = ITEMBTNTAG + itemIndex;
        [itemBtn setTitle:title forState:UIControlStateNormal];
        [itemBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [itemBtn addTarget:self action:@selector(itemTouch:) forControlEvents:UIControlEventTouchUpInside];
        [itemSetView addSubview:itemBtn];
    }
    
    return itemSetView;
}

- (UIImage *)getYHIcon:(NSString *)mark{
    NSString * iconName = nil;
    if([mark rangeOfString:@"工行"].length !=0 || [mark rangeOfString:@"工商"].length !=0){
        iconName = @"icon_bank_gsyh";
    }else if([mark rangeOfString:@"浦发"].length !=0){
        iconName = @"icon_bank_pfyh";
    }else if([mark rangeOfString:@"上海"].length !=0){
        iconName = @"icon_bank_shyh";
    }else if([mark rangeOfString:@"中行"].length !=0 || [mark rangeOfString:@"国行"].length != 0){
        iconName = @"icon_bank_zgyh";
    }else if([mark rangeOfString:@"招行"].length !=0 || [mark rangeOfString:@"招商"].length > 0){
        iconName = @"icon_bank_zsyh";
    }else if([mark rangeOfString:@"北京"].length !=0){
        iconName = @"icon_bank_bjyh.jpg";
    }else if([mark rangeOfString:@"广发"].length !=0 || [mark rangeOfString:@"广州发展"].length != 0){
        iconName = @"icon_bank_gfyh.jpg";
    }else if([mark rangeOfString:@"华夏"].length !=0){
        iconName = @"icon_bank_hxyh.jpg";
    }else if([mark rangeOfString:@"建设"].length !=0 || [mark rangeOfString:@"建行"].length !=0){
        iconName = @"icon_bank_jsyh.jpg";
    }else if([mark rangeOfString:@"交通"].length !=0 || [mark rangeOfString:@"交行"].length != 0){
        iconName = @"icon_bank_jtyh.jpg";
    }else if([mark rangeOfString:@"民生"].length !=0){
        iconName = @"icon_bank_msyh.jpg";
    }else if([mark rangeOfString:@"农行"].length !=0 || [mark rangeOfString:@"农业"].length != 0){
        iconName = @"icon_bank_nyyh.jpg";
    }else if([mark rangeOfString:@"深发"].length !=0 || [mark rangeOfString:@"深发展"].length != 0){
        iconName = @"icon_bank_sfzh.jpg";
    }else if([mark rangeOfString:@"兴业"].length !=0){
        iconName = @"icon_bank_xyyh.jpg";
    }else if([mark rangeOfString:@"中信"].length !=0){
        iconName = @"icon_bank_zxyh.jpg";
    }
    
    if(iconName){
        return [UIImage imageNamed:iconName];
    }
    else{
        return nil;
    }
}

- (void)itemTouch:(UIButton *)btn{
    if(_choosedBtn){
        [_choosedBtn removeFromSuperview];
        _choosedBtn = nil;
    }
    _choosedBtn = [[UIButton alloc]initWithFrame:CHOOSE_FRAME];
    NSString * title = btn.titleLabel.text;
    _choosedBtn.tag = -1000;
    UIImage * image = [self getYHIcon:title];
    [_choosedBtn setImage:image forState:UIControlStateNormal];
    [PublicMethod publicCornerBorderStyle:_choosedBtn];
    [_choosedBtn setTitle:title forState:UIControlStateNormal];
    [_choosedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [enterFieldSecret addSubview:_choosedBtn];
    
    if(bKeyBoardShow){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:phoneEditor,passwordEditor, nil]];
        return ;
    }
    
    NSLog(@"[SJKHEngine Instance]->cgzd_step_Dic = %@",[SJKHEngine Instance]->cgzd_step_Dic);
    
    for (NSDictionary * yhDic in [[SJKHEngine Instance]->cgzd_step_Dic objectForKey:CGYHARR_CGYH]) {
        if([[yhDic objectForKey:YHMC_CGYH] isEqualToString:btn.titleLabel.text]){
            currentDataSource = [yhDic mutableCopy];
            [self cunguanDelegateRequest];
        }
    }
    
    warnLab.text = [NSString stringWithFormat:@"%@%@",warnLab,[currentDataSource objectForKey:@"KHTS"]];
    
    UIButton * reSelectImageBtn = (UIButton *)[enterFieldSecret viewWithTag:ReSelectButton];
    [reSelectImageBtn setBackgroundImage:[self getYHIcon:[currentDataSource objectForKey:YHMC_CGYH]] forState:UIControlStateNormal];
    
    if ([[currentDataSource objectForKey:CGZDFS_CGYH] rangeOfString:@"1"].length != 0) {
        [phoneEditor setHidden:NO];
        if([[currentDataSource objectForKey:MMSR_CGYH] rangeOfString:@"1"].length == 0){
            [passwordEditor setHidden:YES];
        }
        else {
            [passwordEditor setHidden:NO];
        }
    }
    else{
        [passwordEditor setHidden:YES];
        [phoneEditor setHidden:YES];
        //        return ;
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    triangleView.layer.transform = CATransform3DIdentity;
    [CATransaction commit];
    
    [scrollView bringSubviewToFront:enterFieldSecret];
    
    //    [scrollView setScrollEnabled:NO];
    [detailCenterView setAlpha:0];
    [enterFieldSecret setAlpha:0];
    
    
    
    [UIView animateWithDuration:.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [enterFieldSecret setAlpha:1];
                     }
                     completion:^(BOOL bl){
                         
                     }];
    [scrollView setContentSize:CGSizeMake(screenWidth,
                                          enterFieldSecret.frame.origin.y + enterFieldSecret.frame.size.height + 4*verticalHeight)];
    [scrollView scrollRectToVisible:CGRectMake(0,
                                               scrollView.contentSize.height - verticalHeight,
                                               screenWidth,
                                               10)
                           animated:YES];
}

- (void)cunguanDelegateRequest{
    YEorNO resault = nop;
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,CXCGYHDSFCGYX];
    NSURL * URL = [NSURL URLWithString:urlComponent];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:URL];
    [theRequest setValidatesSecureCertificate:NO];
    [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
    [theRequest setAllowCompressedResponse:NO];
    [theRequest setTimeOutSeconds:10];
    NSString *yhdmStr = [[currentDataSource objectForKey:YHDM_CGYH] mutableCopy];
    NSLog(@"yhdm:%@",yhdmStr);
    [theRequest setPostValue:yhdmStr forKey:@"yhdm"];
    [theRequest startSynchronous];
    NSDictionary *responseDic;
    [self parseResponseData:theRequest dic:&responseDic];
    bankCGXYDic = nil;
    bankCGXYDic = [responseDic mutableCopy];
    NSLog(@"22222%@",bankCGXYDic);
    xyID = [responseDic objectForKey:@"ID"];
    delegateContentString = [[responseDic objectForKey:XYNR] mutableCopy];
}

- (void)OnTouchDownResign:(UIControl *)control{
    if(bKeyBoardShow ){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:phoneEditor,passwordEditor, nil]];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bKeyBoardShow = YES;
    
    keyboardOffset = textField.frame.origin.y + ButtonHeight + enterFieldSecret.frame.origin.y -scrollView.contentOffset.y - (screenHeight - UpHeight - KeyBoardHeight);
    textField.layer.borderColor = TEXTFEILD_BOLD_HIGHLIGHT_COLOR.CGColor;
    if(keyboardOffset > 0){
        [self beginEdit:YES textFieldArrar:nil];
    }
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * fieldText = [NSString stringWithFormat:@"%@%@", textField.text , string];
    if(fieldText.length>18 && textField==phoneEditor){
        return NO;
    }
    if(fieldText.length>6 && textField==passwordEditor){
        return NO;
    }
    return  YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor = FieldNormalColor.CGColor;
    [touchControl setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(bKeyBoardShow ){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:textField,nil]];
    }
    return YES;
}

- (void)reposControl{
    int offset = UpHeight;
    //    if([SJKHEngine Instance]->systemVersion < 7){
    //        offset = 0;
    //    }
    offset = 0;
	if (bKeyBoardShow)
	{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, offset-keyboardOffset - verticalHeight, screenWidth, screenHeight - UpHeight );
        }completion:^(BOOL finish){
            
        }];
	}
	else
	{
        [UIView animateWithDuration:0.2 animations:^{
            //            NSLog(@"viewframe =%@,%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(viewFrame));
            self.view.frame = viewFrame;
        }completion:^(BOOL finish){
            
        }];
	}
}

- (BOOL)changeMarkState:(UIButton *)btn{
    if(btn){
        UIButton * markBtn = (UIButton *)[btn viewWithTag:MarkBtnTag];
        if(!btn.isSelected){
            [markBtn setBackgroundImage:[UIImage imageNamed:@"checkBox_checked"] forState:UIControlStateNormal];
            [btn setSelected:YES];
            [self chageNextStepButtonStype:YES];
            return YES;
        }
        else{
            [markBtn setBackgroundImage:[UIImage imageNamed:@"checkBox_default"] forState:UIControlStateNormal];
            [btn setSelected:NO];
            [self chageNextStepButtonStype:NO];
            
            return NO;
        }
    }
    
    return NO;
}

- (void) showCustomAlertViewContent:(BOOL)isShow htmlString:(NSString *)htmlString{
    if(isShow){
        [[SJKHEngine Instance] createCustomAlertView];
        [[SJKHEngine Instance]->_customAlertView setTarget:self withSEL:@selector(showCustomAlertViewContent:htmlString:)];
        [SJKHEngine Instance]->_customAlertView->htmlKey = htmlFileKey;
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:YES htmlString:htmlString];
    }
    else{
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:NO htmlString:nil];
        [SJKHEngine Instance]->_customAlertView = nil;
    }
}

- (void)onButtonClick:(UIButton *)btn{
    if(bKeyBoardShow){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:phoneEditor,passwordEditor, nil]];
        return ;
    }
    
    NSString * insertZH = phoneEditor.text;
    [PublicMethod trimText: &insertZH];
    NSString * insertMM = @"";
    if (![passwordEditor isHidden]) {
        insertMM = passwordEditor.text;
        [PublicMethod trimText: &insertMM];
    }
    
    if(currentDataSource == nil){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择存管银行" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
    }
    if((insertZH.length ==0 || insertZH == nil) && !phoneEditor.isHidden){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先输入帐号" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
    }
    if((insertMM.length ==0 || insertMM == nil ) && !passwordEditor.isHidden){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先输入密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
    }
    if(insertMM.length != 6 && !passwordEditor.isHidden){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码需要是6位,请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
    }
    
    if(btn.tag == MarkBtnTag){
        if(!readCGXY.isSelected){
            [btn setBackgroundImage:[UIImage imageNamed:@"checkBox_checked"] forState:UIControlStateNormal];
            [readCGXY  setSelected:YES];
            [self chageNextStepButtonStype:YES];
        }
        else{
            [btn setBackgroundImage:[UIImage imageNamed:@"checkBox_default"] forState:UIControlStateNormal];
            [readCGXY setSelected:NO];
            [self chageNextStepButtonStype:NO];
        }
        return ;
    }
    
    if(btn.tag == MarkBtnTag + 1 ){
        if(![self changeMarkState:btn]){
            return ;
        }
        [self showCustomAlertViewContent:YES htmlString:delegateContentString];
        
        return ;
    }
    
    if(bKeyBoardShow ){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:phoneEditor,passwordEditor,nil]];
    }
    
    /*
     {"CGXYSTR":[{"XYBH":"","QMLSH":"","HTXY":"20"}],"CGYHSTR":[{"YHZH":"111111","YHMC":"浦发银行","YHDM":"PFYH","ZZHBZ":"1","BZ":1,"YHMM":"147852"}]}
     协议编号，签名流水号，合同协议(协议id)
     银行帐号
     主帐户标志
     备注
     */
    
    __block YEorNO isVailed = nop;
    if(!((UIButton *)[enterFieldSecret viewWithTag:MarkBtnTag + 1]).isSelected){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"请阅读第三方存管协议" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CertHandle *certClass = [CertHandle defaultCertHandle];
            NSLog(@"333333%@",bankCGXYDic);
            isVailed = [certClass secVailCertWithXYDic:[bankCGXYDic mutableCopy]];
            if (isVailed) {
                NSDictionary * dic =nil;
                NSMutableArray * cgxyStr = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"",XYBH_CGYH,
                                                                             [SJKHEngine Instance]->qmlsh,QMLSH_CGYH,[NSString stringWithFormat:@"%i",xyID],HTXY_CGYH, nil],nil];
                
                NSMutableArray * cgyhStr = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:insertZH,YHZH_CGYH,
                                                                             [currentDataSource objectForKey:YHMC_CGYH],YHMC_CGYH,
                                                                             [currentDataSource objectForKey:YHDM_CGYH],YHDM_CGYH,
                                                                             @"1",ZZHBZ_CGYH,
                                                                             @"1",BZ_CGYH,
                                                                             insertMM,YHMM_CGYH,
                                                                             nil],nil];
                NSMutableDictionary * saveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 cgxyStr,CGXYSTR_CGYH,
                                                 cgyhStr,CGYHSTR_CGYH,
                                                 [[SJKHEngine Instance]->khjd_Dic objectForKey:@"bdid"],@"BDID",nil];
                NSLog(@"cunguanzhanghu:%@",saveDic);
                
                if([self saveReCunguanWithJsonDic:saveDic]){
                    [self activityIndicate:YES tipContent:@"加载风险评测页面信息..." MBProgressHUD:nil target:self.navigationController.view];
                    LookProcessViewCtrl * lookPVC = [[LookProcessViewCtrl alloc]init];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self dispatchRiskEvaluateVC:lookPVC];
                        
                    });
                }
                else{
                    [self activityIndicate:NO tipContent:@"保存失败" MBProgressHUD:nil target:self.navigationController.view];
                }
            }
        });
        
    }
}

- (YEorNO)saveReCunguanWithJsonDic:(NSDictionary *)jsonDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,RECGYH];
    //    ?sj&GTKHH&ZJZH&formJson
    if ([NSJSONSerialization isValidJSONObject:jsonDic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString *jsonString = [[NSString alloc]initWithData:tempJsonData encoding:NSUTF8StringEncoding];
        NSLog(@"cunguanzhanghu:%@",jsonString);
        NSURL * URL = [NSURL URLWithString:urlComponent];
        NSLog(@"%@",URL);
        ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:URL];
        [theRequest setValidatesSecureCertificate:NO];
        [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
        
        [theRequest setAllowCompressedResponse:NO];
        [theRequest setTimeOutSeconds:10];
        
        
        [theRequest setPostValue:jsonString forKey:@"formJson"];
        [theRequest setPostValue:[SJKHEngine Instance]->SJHM forKey:@"sj"];
        [theRequest setPostValue:[[SJKHEngine Instance]->khjd_Dic objectForKey:@"gtkhh"]
                          forKey:@"gtkhh"];
        [theRequest setPostValue:[[SJKHEngine Instance]->khjd_Dic objectForKey:@"zjzh"] forKey:@"zjzh"];
        
        [theRequest startSynchronous];
        if(theRequest.responseData){
            NSDictionary *stepResponseDic = [NSJSONSerialization JSONObjectWithData:theRequest.responseData options:NSJSONReadingMutableContainers error:Nil];
            NSString * tip = nil;
            
//            NSString *testSTR = [stepResponseDic objectForKey:NOTE];
            if([stepResponseDic objectForKey:NOTE]){
//                tip = [PublicMethod getNSStringFromCstring:[[stepResponseDic objectForKey:NOTE] UTF8String]];
            }
            
            if(stepResponseDic && [stepResponseDic objectForKey:SUCCESS]){
                bSaveStepFinish = YES;
                return yep;
            }
        }
    }
    return nop;
}

- (void)loadXYS{
    //异步加载协议书数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * xys = nil;
        BOOL ok= [self sendCGYHXYID:[currentDataSource objectForKey:YHDM_CGYH] dataDictionary:&xys];
        if (xys && xys.count > 0 && ok)
        {
            BOOL ok = [[xys objectForKey:XYNR] writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:htmlFileKey] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [PublicMethod saveToUserDefaults:[xys objectForKey:ID] key:[currentDataSource objectForKey:YHMC_CGYH]];
            xyID = [[xys objectForKey:ID] intValue];
            
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

- (void)dispatchRiskEvaluateVC:(LookProcessViewCtrl *)lookPVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        [self.navigationController pushViewController:lookPVC animated:YES];
        [lookPVC updateUI];
    });
}

- (void)popToLastPage{
    
//    [super popToLastPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    NSLog(@"存管银行回收");
}

@end





