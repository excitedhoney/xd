#import "DepositBankViewCtrl.h"
#import "RiskEvaluateViewCtrl.h"
#import "UIImage+custom_.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "LookProcessViewCtrl.h"
#import "SecretSetViewCtrl.h"


#define CHOOSE_FRAME CGRectMake(levelSpace, labelHeight , (screenWidth - 3 * 5)/2, itemHeight)

#define ITEMBTNTAG 925

#define ReSelectButton 219

typedef enum
{
    ACCOUNTANDSECRETSHOW            = 22,
    ACCOUNTORSECRETSHOW             = 23,
    NOFIELDSHOW                     = 24
} FIELDSHOWSTATUS;


@interface DepositBankViewCtrl (){
    BOOL isVailSuccess;
    BOOL isVailFinish;
    UIView * initCenterView;
    UIView * detailCenterView;
    UIImageView * triangleView;
    int labelHeight;
    int slideOffset;
    int itemIndex;
    int itemSetIndex;
    int centerHeight;
    int itemHeight ;
//    int xyID;
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
    UIButton * headerFlowButton;
    
    UIButton *_choosedBtn;
    UIButton * markButton;
    
    NSMutableDictionary * YHDM_IDS;
    UITextField * dialogTextField;
}

@end

@implementation DepositBankViewCtrl

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
        bIsRepointPage = NO;
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
    if(bFirstShow){
        [self updateUI];
        bFirstShow = NO;
    }
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
//    NSLog(@"ges =%@",self.navigationController.navigationBar.gestureRecognizers);
//    [self.navigationController.navigationBar removeGestureRecognizer:singleTapRecognizer];
}

- (void) InitConfig{
    slideOffset = 100.0;
    itemIndex = 0;
    centerHeight = 180.0;
    itemSetIndex = 0;
    itemHeight = 55.0;
    delayTime = 2;
    htmlFileKey = @"";
    isVailSuccess = NO;
    isVailFinish = NO;
    YHDM_IDS = [[NSMutableDictionary alloc]init];
    
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    [self.navigationItem setHidesBackButton:YES];
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
//    UIButton * backButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:FigureButtonTag + 1];
//    [backButton setImage:[UIImage imageNamed:@"step_3"] forState:UIControlStateNormal];
    
    //    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector (OnKeyboardChangeFrame:) name: UIKeyboardDidShowNotification object: nil];
    //    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector (OnKeyboardWillHidden:) name: UIKeyboardWillHideNotification object: nil];

}

- (void)fieldTextChanged:(NSNotification *)noti{
    UITextField * textField = noti.object;
    NSString * fieldText = textField.text;
    
    if(!textField.markedTextRange){
        if(fieldText.length> 25 && textField == phoneEditor){
            [textField setText:[fieldText substringToIndex:25]];
        }
        if(fieldText.length> 6 && textField == passwordEditor){
            [textField setText:[fieldText substringToIndex:6]];
        }
        if(fieldText.length> 6 && textField == dialogTextField){
            [textField setText:[fieldText substringToIndex:6]];
        }
    }
}

- (void)setViewBound{
    if([SJKHEngine Instance]->systemVersion < 7){
//        self.view.bounds = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
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
    
    labelHeight = 50;
    
    headerFlowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerFlowButton setFrame:CGRectMake(0, 0 , screenWidth, ButtonHeight)];
//    [headerFlowButton setImage:[[UIImage imageNamed:@"flow_3"] imageByResizingToSize:CGSizeMake(screenWidth, headerFlowButton.frame.size.height)]
//                      forState:UIControlStateNormal];
    headerFlowButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headerFlowButton setBackgroundImage:[UIImage imageNamed:@"flow_3"]
                      forState:UIControlStateNormal];
    [headerFlowButton setUserInteractionEnabled:NO];
    [scrollView addSubview: headerFlowButton];
    
    UILabel *la=[[UILabel alloc]initWithFrame: CGRectMake(levelSpace, ButtonHeight, screenWidth - 2 * levelSpace, labelHeight)];
	la.backgroundColor = [UIColor clearColor];
    [la setText:@"开通三方存管后,您的资金可以在银行卡与股票交易帐户中自由调度"];
	[la setFont: [UIFont boldSystemFontOfSize:15]];
    la.textAlignment = NSTextAlignmentLeft;
	[la setTextColor: [UIColor blackColor]];
    la.numberOfLines = 0;
    la.lineBreakMode = NSLineBreakByTruncatingTail;
    [scrollView addSubview:la];
    
    headerBtn = [[UIButton alloc]init];
    [headerBtn setFrame:CGRectMake(levelSpace, labelHeight + ButtonHeight, screenWidth - levelSpace , ButtonHeight)];
    [headerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headerBtn setAlpha:0];
    [headerBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
    
    triangleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"select_arrow_hot"]];
    UIFont * font = [UIFont boldSystemFontOfSize:15];
    NSString * textTitle = @"其他银行";
    [headerBtn setTitle:textTitle forState:UIControlStateNormal];
    [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headerBtn.titleLabel.font = font;
    int width = [PublicMethod getStringWidth:textTitle font:font] + levelSpace/2;
    triangleView.frame = CGRectMake(width, ButtonHeight/2 - 20/2 , 20 , 20);
    [headerBtn addSubview:triangleView];
    [scrollView addSubview:headerBtn];
    
    [scrollView setBackgroundColor:PAGE_BG_COLOR];
    
    [self createEnterFieldSecret];
    
    [self addGesture:scrollView];
    
    if([SJKHEngine Instance]->systemVersion < 6){
        singleTapRecognizer.delegate = self;
    }
    
    [super InitWidgets];
    
    if(bIsRepointPage){
        [headerFlowButton setHidden:YES];
        [scrollView setContentInset:UIEdgeInsetsMake(-ButtonHeight, 0, 0, 0)];
    }
}

- (void) createEnterFieldSecret{
    enterFieldSecret = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               labelHeight + centerHeight + ButtonHeight,
                                                               screenWidth,
                                                               screenHeight - UpHeight - (labelHeight + centerHeight + ButtonHeight) + (itemHeight + 10 * 2))];
    [enterFieldSecret setBackgroundColor:PAGE_BG_COLOR];
    [enterFieldSecret setAlpha:0];
    
    UILabel *tip=[[UILabel alloc]initWithFrame: CGRectMake(levelSpace, 0, screenWidth - 2 * levelSpace, labelHeight )];
	tip.backgroundColor = [UIColor clearColor];
    //    [tip setText:@"小提示:如果你的银行已经办理了其他券商三方存管，需要先解除才能办理哦"];
    [tip setText:@"填写银行卡信息:"];
	[tip setFont: [UIFont boldSystemFontOfSize:15]];
    tip.textAlignment = NSTextAlignmentLeft;
	[tip setTextColor: [UIColor blackColor]];
    tip.lineBreakMode = NSLineBreakByTruncatingTail;
    tip.numberOfLines = 0;
    [enterFieldSecret addSubview:tip];
    
    if(_choosedBtn){
        [_choosedBtn removeFromSuperview];
        _choosedBtn = nil;
    }
    _choosedBtn = [[UIButton alloc]initWithFrame:CHOOSE_FRAME];
    _choosedBtn.tag = -1000;
    [PublicMethod publicCornerBorderStyle:_choosedBtn];
    [_choosedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_choosedBtn setUserInteractionEnabled:NO];
    [_choosedBtn setBackgroundColor:[UIColor whiteColor]];
    [enterFieldSecret addSubview:_choosedBtn];
    
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
	[phoneEditor setFont: TipFont];
    phoneEditor.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [phoneEditor setPlaceholder:@"请输入卡号"];
	[phoneEditor setTextColor: [UIColor blackColor]];
    phoneEditor.delegate = self;
    phoneEditor.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
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
	[passwordEditor setFont: TipFont];
    passwordEditor.delegate = self;
    [passwordEditor setPlaceholder:@"请输入密码"];
    [passwordEditor setSecureTextEntry:YES];
    passwordEditor.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
	[passwordEditor setTextColor: [UIColor blackColor]];
    [enterFieldSecret addSubview:passwordEditor];
    
    readCGXY = [PublicMethod InitReadXY:@"阅读并同意签署第三方存管协议"
                              withFrame:CGRectMake (levelSpace,
                                                    passwordEditor.frame.origin.y + 44 +verticalHeight,
                                                    screenWidth - 2 * levelSpace,
                                                    44)
                                    tag:MarkBtnTag + 1
                                 target:self];
    readCGXY.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    readCGXY.titleLabel.font = [UIFont italicSystemFontOfSize:16.0f];
    [readCGXY setTitleColor:[UIColor colorWithRed:0 green:123.0/255 blue:218.0/255 alpha:1.0] forState:UIControlStateNormal];
    markButton = (UIButton *)[readCGXY viewWithTag:MarkBtnTag];
//    [markButton setImage:[UIImage imageNamed:@"linkimage"] forState:UIControlStateNormal];
//    [markButton setBackgroundImage:[UIImage imageNamed:@"checkbox_default"] forState:UIControlStateNormal];
//    [markButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3,3)];
    [readCGXY setSelected:NO];
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
                                         readCGXY.frame.origin.y + readCGXY.frame.size.height + verticalHeight,
                                         screenWidth - 2 * levelSpace,
                                         44)
                         tag:0
                       title:@"下一步"];
    [enterFieldSecret addSubview:nextStepBtn];
    
    if([SJKHEngine Instance]->systemVersion < 6){
        UITapGestureRecognizer * tipGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouchDownResign:)];
        [enterFieldSecret addGestureRecognizer: tipGesture];
        tipGesture.delegate = self;
    }
    else {
        [self addGesture:enterFieldSecret];
    }
    
    [enterFieldSecret setFrame:CGRectMake(0,
                                          ButtonHeight + labelHeight + centerHeight + ButtonHeight,
                                          screenWidth,
                                          nextStepBtn.frame.origin.y + nextStepBtn.frame.size.height + verticalHeight)];
    
    [scrollView addSubview:enterFieldSecret];
    
    [scrollView setContentSize:CGSizeMake(screenWidth, enterFieldSecret.frame.origin.y + enterFieldSecret.frame.size.height)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"event =%@",event);
}

- (void)reSelect:(UIButton *)btn{
    [scrollView setScrollEnabled:YES];
    phoneEditor.layer.borderColor = FieldNormalColor.CGColor;
    passwordEditor.layer.borderColor = FieldNormalColor.CGColor;
    
    if(readCGXY.selected){
        [self changeMarkState: readCGXY];
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
        triangleView.layer.transform = CATransform3DMakeRotation(M_PI/2, 0,0,1);
        [CATransaction commit];
        [enterFieldSecret setAlpha:0];
        
        [UIView animateWithDuration:.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [detailCenterView setAlpha:1];
                             [detailCenterView setFrame:CGRectMake(0,
                                                                   ButtonHeight + labelHeight + centerHeight + ButtonHeight,
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
                                                                   labelHeight + centerHeight/3 ,
                                                                   screenWidth,
                                                                   detailCenterView.frame.size.height)];
                         }
                         completion:^(BOOL bl){
                             
                         }];
        [scrollView setContentSize:self.view.frame.size];
    }
}

- (void)showMore:(UIButton *)btn{
    if(bKeyBoardShow){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:phoneEditor,passwordEditor, nil]];
        return ;
    }
    [self reSelect:Nil];
    
    if(detailCenterView.alpha == 1){
        [headerBtn setTitle:@"其他银行" forState:UIControlStateNormal];
        [self showMoreAnimation:NO];
    }
    else if(detailCenterView.alpha == 0){
        [headerBtn setTitle:@"收起更多" forState:UIControlStateNormal];
        [self showMoreAnimation:YES];
    }
    else{
        return ;
    }
}

- (void) updateUI{
    if(!self.isViewLoaded){
        return ;
    }
    for (NSDictionary * yhDic in [[SJKHEngine Instance]->cgzd_step_Dic objectForKey:CGYHARR_CGYH]) {
        [YHDM_IDS setObject:@"-1" forKey:[yhDic objectForKey:YHDM_CGYH]];
    }
    
    [self createItemButtons];
    
    if(filterArray.count > 0){
        [UIView animateWithDuration:.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [initCenterView setAlpha:1];
                             [initCenterView setFrame:CGRectMake(0,
                                                                 labelHeight + ButtonHeight ,
                                                                 screenWidth,
                                                                 centerHeight)];
                             if(filterArray.count > 4){
                                 [headerBtn setAlpha:1];
                                 [headerBtn setFrame:CGRectMake(levelSpace,
                                                                labelHeight + centerHeight + ButtonHeight,
                                                                screenWidth - levelSpace,
                                                                44)];
                             }
                         }
                         completion:^(BOOL bl){
                             
                         }];
    }
}

- (void) createItemButtons{
    float itemSpace = 5;
    initCenterView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                             labelHeight - slideOffset,
                                                             screenWidth,
                                                             centerHeight)];
    [initCenterView setBackgroundColor:[UIColor clearColor]];
    [initCenterView setAlpha:0];
    [scrollView addSubview:initCenterView];
    
    detailCenterView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               labelHeight + centerHeight/3,
                                                               screenWidth,
                                                               centerHeight/3)];
    [detailCenterView setBackgroundColor:[UIColor clearColor]];
    [detailCenterView setAlpha:0];
    [scrollView addSubview:detailCenterView];
    
    int itemSetNumber = (filterArray.count+1) /2 + (filterArray.count + 1) %2 ;
    
    if(itemSetNumber == 0){
        return ;
    }
    
    if(itemSetNumber >= 2){
        float inset = 5.5;
        float itemWidth = (screenWidth - 3*itemSpace)/2.0;
        UIButton * vipBtn = [[UIButton alloc]initWithFrame:CGRectMake(itemSpace, 0, itemWidth , itemHeight * 2 + itemSpace)];
        itemIndex ++;
//        NSString * title = [filterArray objectAtIndex:itemIndex ++];
//        UIImage * image = [self getYHIcon:title];
        
        [vipBtn setImage:[UIImage imageNamed:@"icon_bank_gsyh"] forState:UIControlStateNormal];
        vipBtn.layer.cornerRadius = 4;
        vipBtn.layer.masksToBounds = YES;
        UIButton * subBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                                     vipBtn.frame.size.height - 40,
                                                                     vipBtn.frame.size.width,
                                                                     40)];
        subBtn.titleLabel.text = [filterArray firstObject];
        UIButton * upBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                           0,
                                                           vipBtn.frame.size.width,
                                                           vipBtn.frame.size.height - 40)];
        upBtn.titleLabel.text = [filterArray firstObject];
        [subBtn addTarget:self action:@selector(onMoreWonderful:) forControlEvents:UIControlEventTouchUpInside];
        [upBtn addTarget:self action:@selector(itemTouch:) forControlEvents:UIControlEventTouchUpInside];
        [vipBtn addSubview:subBtn];
        [vipBtn addSubview:upBtn];
        
        [initCenterView addSubview:vipBtn];
        
        [initCenterView addSubview:[self onCreateItemButton:0]];
        itemSetIndex ++;
        [initCenterView addSubview:[self onCreateItemButton:1]];
        
        itemSetIndex ++;
        UIView *itemSetView = [self itemSetView:itemSetNumber];
        [itemSetView setFrame:CGRectMake(0, (itemSpace + itemHeight) * 2 , screenWidth, itemHeight)];
        [initCenterView addSubview:itemSetView];
        itemSetIndex ++;
        
        //i代表轮循的次数
        for (int i= 0; i < itemSetNumber - 3 ; i++) {
            UIView *itemSetView = [self itemSetView:itemSetNumber];
            itemSetIndex ++;
            [itemSetView setFrame:CGRectMake(0, (itemSpace + itemHeight) * i , screenWidth, itemHeight)];
            [detailCenterView addSubview:itemSetView];
        }
    }
    
    [detailCenterView setFrame:CGRectMake(0,
                                          labelHeight + centerHeight/3,
                                          screenWidth,
                                          (itemSetNumber - 3)*(centerHeight/3))];
    
    
    if(itemSetNumber == 1){
        itemSetIndex ++;
        [initCenterView addSubview:[self itemSetView:itemSetNumber]];
    }
    
    [scrollView addSubview:initCenterView];
    [scrollView addSubview:detailCenterView];
    
    [scrollView setContentSize:CGSizeMake(screenWidth, detailCenterView.frame.origin.y + detailCenterView.frame.size.height)];
}

- (UIButton *)onCreateItemButton:(int)index{
    int space = 5;
    float itemWidth = (screenWidth - 3*space) / 2.0;
    UIButton * itemBtn = [[UIButton alloc]initWithFrame:CGRectMake (space + (space + itemWidth),
                                                                    (space + itemHeight) * index,
                                                                    itemWidth,
                                                                    itemHeight)];
    NSString * title = [filterArray objectAtIndex:itemIndex++];
    UIImage * image = [self getYHIcon:title];
    
    if(image){
        [itemBtn setImage:image forState:UIControlStateNormal];
        [itemBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [itemBtn setImageEdgeInsets:UIEdgeInsetsMake(5.5, 0, 5.5, 0)];
    }
    else{
        [itemBtn setBackgroundImage:[UIImage imageWithColor:LightGrayTipColor size:itemBtn.frame.size] forState:UIControlStateNormal];
        [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [itemBtn setBackgroundColor:[UIColor whiteColor]];
    [itemBtn setTitle:title forState:UIControlStateNormal];
    
    [PublicMethod publicCornerBorderStyle:itemBtn];
    itemBtn.tag = ITEMBTNTAG + itemIndex;
    
    [itemBtn addTarget:self action:@selector(itemTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return itemBtn;
}

- (UIView *)itemSetView:(int)itemSetNumber{
    int space = 5;
    float itemWidth = (screenWidth - 3*space) / 2.0;
    UIView * itemSetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, itemHeight)];
    [itemSetView setBackgroundColor:[UIColor clearColor]];
    int setNumber = 2;
    
    //(filterArray.count + 1) % 2 != 0  这句 是为了确定当前最后一排只有一个item.
    if((filterArray.count + 1) % 2 != 0 && itemSetIndex == itemSetNumber - 1){
        setNumber = 1;
    }
    
    for (int i= 0; i < setNumber; i++) {
        UIButton * itemBtn = [[UIButton alloc]initWithFrame:CGRectMake (space + (space + itemWidth)*i,
                                                                        0,
                                                                        itemWidth,
                                                                        itemHeight)];
        NSLog(@"item log =%i,%i,%i,%i",setNumber,i,itemIndex,itemSetIndex);
        if (itemIndex >= filterArray.count + 1) {
            break;
        }
        NSString * title = [filterArray objectAtIndex:itemIndex++];
        UIImage * image = [self getYHIcon:title];
        
        if(image){
            [itemBtn setImage:image forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [itemBtn setImageEdgeInsets:UIEdgeInsetsMake(5.5, 0, 5.5, 0)];
        }
        else{
            [itemBtn setBackgroundImage:[UIImage imageWithColor:LightGrayTipColor size:itemBtn.frame.size] forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [itemBtn setBackgroundColor:[UIColor whiteColor]];
        [itemBtn setTitle:title forState:UIControlStateNormal];
        
        [PublicMethod publicCornerBorderStyle:itemBtn];
        itemBtn.tag = ITEMBTNTAG + itemIndex;
        
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
    }else if([mark rangeOfString:@"平安"].length !=0){
        iconName = @"icon_bank_sfzh.jpg";
    }else if([mark rangeOfString:@"光大"].length !=0){
        iconName = @"icon_bank_gdyh.jpg";
    }else if([mark rangeOfString:@"花旗"].length !=0){
        iconName = @"icon_bank_hqyh.jpg";
    }else if([mark rangeOfString:@"进出口"].length !=0){
        iconName = @"icon_bank_jkyh.jpg";
    }else if([mark rangeOfString:@"南京"].length !=0){
        iconName = @"icon_bank_njyh.jpg";
    }else if([mark rangeOfString:@"人民"].length !=0){
        iconName = @"icon_bank_rmyh.jpg";
    }else if([mark rangeOfString:@"中国"].length !=0){
        iconName = @"icon_bank_zgyh.jpg";
    }
    
    if(iconName){
        return [UIImage imageNamed:iconName];
    }
    else{
        return nil;
    }
}

- (void)onMoreWonderful:(UIButton *)btn{
    for (NSDictionary * yhDic in [[SJKHEngine Instance]->cgzd_step_Dic objectForKey:CGYHARR_CGYH]) {
        if([[yhDic objectForKey:YHMC_CGYH] isEqualToString:btn.titleLabel.text]){
            currentDataSource = [yhDic mutableCopy];
        }
    }
    
    htmlFileKey = [NSString stringWithFormat:@"%@%@.html",CGZD_FILE_NAME,[currentDataSource objectForKey:YHDM_CGYH]];
    NSError * error = nil;
    [[SJKHEngine Instance] createCustomAlertView];
    [[SJKHEngine Instance]->_customAlertView toSetTitleLabel:[NSString stringWithFormat:@"%@",btn.titleLabel.text]];
    [self showCustomAlertViewContent:YES htmlString:nil];
    [self loadXYS];
}

- (void)itemTouch:(UIButton *)btn{
    if(bKeyBoardShow){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:phoneEditor,passwordEditor, nil]];
        return ;
    }
    
    [self reSelect:Nil];
    [headerBtn setTitle:@"其他银行" forState:UIControlStateNormal];
    
    for (NSDictionary * yhDic in [[SJKHEngine Instance]->cgzd_step_Dic objectForKey:CGYHARR_CGYH]) {
        if([[yhDic objectForKey:YHMC_CGYH] isEqualToString:btn.titleLabel.text]){
            currentDataSource = [yhDic mutableCopy];
        }
    }
    
    NSString * title = btn.titleLabel.text;
    [_choosedBtn setTitle:title forState:UIControlStateNormal];
    UIImage * image = [self getYHIcon:title];
    if(image){
        if(![title isEqualToString:[filterArray firstObject]]){
            [_choosedBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [_choosedBtn setImage:nil forState:UIControlStateNormal];
            [_choosedBtn setImage:image forState:UIControlStateNormal];
            [_choosedBtn setImageEdgeInsets:UIEdgeInsetsMake(5.5, 0, 5.5, 0)];
        }
        else{
            [_choosedBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [_choosedBtn setImage:nil forState:UIControlStateNormal];
            image = [UIImage imageNamed:@"logo_gsyh_small.png"];
            [_choosedBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
        [_choosedBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
    else{
        [_choosedBtn setImage:nil forState:UIControlStateNormal];
        [_choosedBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_choosedBtn setBackgroundImage:[UIImage imageWithColor:LightGrayTipColor size:_choosedBtn.frame.size] forState:UIControlStateNormal];
        [_choosedBtn setTitle:title forState:UIControlStateNormal];
        [_choosedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if(((NSString *)[currentDataSource objectForKey:@"KHTS"]).length >0){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[currentDataSource objectForKey:@"KHTS"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
    }
    
    warnLab.text = [NSString stringWithFormat:@"%@%@",warnLab,[currentDataSource objectForKey:@"KHTS"]];
    
    NSLog(@"curretnDataSOurce =%@",currentDataSource);
    if ([[currentDataSource objectForKey:CGZDFS_CGYH] rangeOfString:@"1"].length != 0) {
        [phoneEditor setHidden:NO];
        if([[currentDataSource objectForKey:MMSR_CGYH] rangeOfString:@"1"].length == 0){
            [passwordEditor setHidden:YES];
            [self toReposWidgetsPostions:ACCOUNTORSECRETSHOW];
        }
        else {
            [passwordEditor setHidden:NO];
            [self toReposWidgetsPostions:ACCOUNTANDSECRETSHOW];
        }
    }
    else{
        [passwordEditor setHidden:YES];
        [phoneEditor setHidden:YES];
        [self toReposWidgetsPostions:NOFIELDSHOW];
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
                                          enterFieldSecret.frame.origin.y + enterFieldSecret.frame.size.height)];
    [scrollView scrollRectToVisible:CGRectMake(0,
                                               scrollView.contentSize.height - verticalHeight,
                                               screenWidth,
                                               10)
                           animated:YES];
}

- (void)toReposWidgetsPostions:(FIELDSHOWSTATUS)status{
    switch (status) {
        case ACCOUNTANDSECRETSHOW:{
            readCGXY.frame = CGRectMake (levelSpace,
                                         passwordEditor.frame.origin.y + ButtonHeight +verticalHeight ,
                                         screenWidth - 2 * levelSpace,
                                         ButtonHeight);
            nextStepBtn.frame= CGRectMake (levelSpace,
                                           readCGXY.frame.origin.y + readCGXY.frame.size.height + verticalHeight,
                                           screenWidth - 2 * levelSpace,
                                           ButtonHeight);
            break;
        }
        case ACCOUNTORSECRETSHOW:{
            readCGXY.frame = CGRectMake (levelSpace,
                                         passwordEditor.frame.origin.y + ButtonHeight +verticalHeight - (ButtonHeight+verticalHeight),
                                         screenWidth - 2 * levelSpace,
                                         ButtonHeight);
            nextStepBtn.frame= CGRectMake (levelSpace,
                                           readCGXY.frame.origin.y + readCGXY.frame.size.height + verticalHeight,
                                           screenWidth - 2 * levelSpace,
                                           ButtonHeight);
            break;
        }
        case NOFIELDSHOW:{
            readCGXY.frame = CGRectMake (levelSpace,
                                         passwordEditor.frame.origin.y + ButtonHeight +verticalHeight - 2 * (ButtonHeight+verticalHeight),
                                         screenWidth - 2 * levelSpace,
                                         ButtonHeight);
            nextStepBtn.frame= CGRectMake (levelSpace,
                                           readCGXY.frame.origin.y + readCGXY.frame.size.height + verticalHeight,
                                           screenWidth - 2 * levelSpace,
                                           ButtonHeight);
            break;
        }
        
        default:
            break;
    }
}

- (BOOL)cunguanDelegateRequest{
    YEorNO resault = nop;
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,@"/wskh/mobile/query/queryCgxy"];
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
//    resault = [self parseResponseData:theRequest dic:&responseDic];
    bankCGXYDic = nil;
    bankCGXYDic = [responseDic mutableCopy];
    
    if([responseDic objectForKey:ID]){
        [YHDM_IDS setObject:[responseDic objectForKey:ID] forKey:[currentDataSource objectForKey:YHDM_CGYH]];
    }
    else{
        return NO;
    }
    
    NSLog(@"bankCGXYDic =%@",bankCGXYDic);
//    delegateContentString = [[responseDic objectForKey:XYNR] mutableCopy];
    
    return YES;
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
//    NSString * fieldText = [NSString stringWithFormat:@"%@%@", textField.text , string];
//    if(fieldText.length> 18 && textField == phoneEditor){
//        return NO;
//    }
//    if(fieldText.length> 6 && textField == passwordEditor){
//        return NO;
//    }
//    if(fieldText.length> 6 && textField == dialogTextField){
//        return NO;
//    }
    
    return  YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor = FieldNormalColor.CGColor;
    [touchControl setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(bKeyBoardShow){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:textField,nil]];
    }
    return YES;
}

- (void)reposControl{
    int offset = 0;
    //    if([SJKHEngine Instance]->systemVersion < 7){
    //        offset = 0;
    //    }
    offset = 0;
	if (bKeyBoardShow)
	{
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.frame = CGRectMake(0, offset-keyboardOffset - verticalHeight, screenWidth, screenHeight - UpHeight );
        }completion:^(BOOL finish){
            
        }];
	}
	else
	{
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight - UpHeight);
        }completion:^(BOOL finish){
            
        }];
	}
}

- (BOOL)changeMarkState:(UIButton *)btn{
//    return YES;
    
    if(btn){
        UIButton * markBtn = (UIButton *)[btn viewWithTag:MarkBtnTag];
        if(!btn.isSelected){
            [markBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
            [btn setSelected:YES];
            return YES;
        }
        else{
            [markBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_default"] forState:UIControlStateNormal];
            [btn setSelected:NO];
            
            return NO;
        }
    }
    
    return NO;
}

- (void) showCustomAlertViewContent:(BOOL)isShow htmlString:(NSString *)htmlString{
    if(isShow){
        [[SJKHEngine Instance]->_customAlertView setTarget:self withSEL:@selector(showCustomAlertViewContent:htmlString:)];
        [SJKHEngine Instance]->_customAlertView->htmlKey = htmlFileKey;
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:YES htmlString:htmlString];
    }
    else{
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:NO htmlString:nil];
        
    }
}

- (void)onShowAlert:(NSString *)tipMessage{
    UIAlertView* dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setMessage:tipMessage];
    [dialog addButtonWithTitle:@"确定"];
    dialog.tag = 5;
    
    dialog.alertViewStyle = UIAlertViewStyleSecureTextInput;
    dialogTextField = [dialog textFieldAtIndex:0];
    dialogTextField.delegate = self;
    dialogTextField.layer.cornerRadius = 3;
    dialogTextField.layer.masksToBounds = YES;
    dialogTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
    [dialog setTransform: moveUp];
    [dialog show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 5){
        UITextField * textField = [alertView textFieldAtIndex:0];
        NSString * sTextField = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(sTextField.length != 6){
            [self onShowAlert:@"密码长度需要是6位,请重新输入"];
        }
        else{
            [SJKHEngine Instance]->sImportPassword = sTextField;
            [self performSelector:@selector(onGoToRiskEvaluate) withObject:nil afterDelay:0.3];
        }
    }
    else{
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}


- (void)onButtonClick:(UIButton *)btn{
    if(bKeyBoardShow){
        [self beginEdit:NO textFieldArrar:[NSMutableArray arrayWithObjects:phoneEditor,passwordEditor, nil]];
        return ;
    }
    
    if(btn.tag == MarkBtnTag + 1 ){
        if(![self changeMarkState:readCGXY]){
            return ;
        }
        
        htmlFileKey = [NSString stringWithFormat:@"%@%@.html",CGZD_FILE_NAME,[currentDataSource objectForKey:YHDM_CGYH]];
        NSError * error = nil;
        [[SJKHEngine Instance] createCustomAlertView];
        [[SJKHEngine Instance]->_customAlertView toSetTitleLabel:[NSString stringWithFormat:@"%@",_choosedBtn.titleLabel.text]];
        [self showCustomAlertViewContent:YES htmlString:nil];
        [self loadXYS];
        return ;
    }
    if(btn.tag == MarkBtnTag){
        if(!readCGXY.isSelected){
            [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
            [readCGXY  setSelected:YES];
        }
        else{
            [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_default"] forState:UIControlStateNormal];
            [readCGXY setSelected:NO];
        }
        
        return ;
    }
    
    NSString * insertZH = @"";
    if (![passwordEditor isHidden]) {
        insertZH = phoneEditor.text;
        [PublicMethod trimText: &insertZH];
    }
    
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
    if((insertZH.length == 0 || insertZH == nil) && !phoneEditor.isHidden){
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
    
    
    if(!readCGXY.selected){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先阅读存管协议" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
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
    
    if(!((UIButton *)[enterFieldSecret viewWithTag:MarkBtnTag + 1]).isSelected){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"请阅读第三方存管协议" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return ;
    }
    
//    [self onShowAlert:@"请输入证书步骤所设置的密码"];
    [self onGoToRiskEvaluate];
}

- (void)onGoToRiskEvaluate{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CertHandle *certClass = [CertHandle defaultCertHandle];
        certClass.delegate = self;
        [self activityIndicate:YES tipContent:@"证书验证中..." MBProgressHUD:nil target:self.navigationController.view];
        isVailSuccess = [certClass vailCert];
        isVailFinish = YES;
    });
    while (!isVailFinish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    isVailFinish = NO;
    if(!isVailSuccess){
        return ;
    }
    
    NSString * insertZH = @"";
    if (![passwordEditor isHidden]) {
        insertZH = phoneEditor.text;
        [PublicMethod trimText: &insertZH];
    }
    
    NSString * insertMM = @"";
    if (![passwordEditor isHidden]) {
        insertMM = passwordEditor.text;
        [PublicMethod trimText: &insertMM];
    }

    NSDictionary * dic =nil;
    if (bIsRepointPage) {
        [self activityIndicate:YES tipContent:@"存管重新指定中..." MBProgressHUD:nil target:self.navigationController.view];
        [self onRepointBank:[NSArray arrayWithObjects:insertZH,insertMM, nil]];
        return ;
    }
    
    NSMutableArray * cgyhStr = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 insertZH,YHZH_CGYH,
                                                                 [currentDataSource objectForKey:YHDM_CGYH],YHDM_CGYH,
                                                                 @"1",ZZHBZ_CGYH,
                                                                 @"1",BZ_CGYH,
                                                                 insertMM,YHMM_CGYH,
                                                                 nil],nil];
    NSMutableArray * cgxyStr = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"",XYBH_CGYH,
                                                                 [SJKHEngine Instance]->qmlsh,QMLSH_CGYH,[YHDM_IDS objectForKey:[currentDataSource objectForKey:YHDM_CGYH]],HTXY_CGYH, nil],nil];
    
    NSMutableDictionary * saveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     cgxyStr,CGXYSTR_CGYH,
                                     cgyhStr,CGYHSTR_CGYH,nil];
    //        ""cgzd"":{""CGYHSTR"":[{""YHZH"":""555555555555555555"",""YHMM"":""500005500005500005"",""ZZHBZ"":""1"",""BZ"":""1"",""YHDM"":""MSYH""}],""CGXYSTR"":[{""HTXY"":""1"",""XYBH"":"""",""QMLSH"":""2012""}]}
    
    [self sendSaveStepInfo:CGZD_STEP dataDictionary:&dic arrar:saveDic];
    
    while (!bSaveStepFinish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    bSaveStepFinish = NO;
    
    if(bSaveStepSuccess){
        [self activityIndicate:YES tipContent:@"加载风险评测页面信息..." MBProgressHUD:nil target:self.navigationController.view];
        RiskEvaluateViewCtrl * riskVC = [[RiskEvaluateViewCtrl alloc]init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self dispatchRiskEvaluateVC:riskVC];
        });
    }
    else{
        [self activityIndicate:NO tipContent:@"保存失败" MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void)onRepointBank:(NSArray *)ar{
//    NSString * insertZH = [ar objectAtIndex:0];
//    NSString * insertMM = [ar objectAtIndex:1];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([[YHDM_IDS objectForKey:[currentDataSource objectForKey:YHDM_CGYH]] isEqualToString:@"-1"]){
            if(![self cunguanDelegateRequest]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"获取存管银行协议失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertview show];
                    return ;
                });
            }
            else{
                [self rePointBankComponentCode:ar];
            }
        }
        else {
            [self rePointBankComponentCode:ar];
        }
    });
}

- (void)rePointBankComponentCode:(NSArray *)ar{
    NSString * insertZH = [ar objectAtIndex:0];
    NSString * insertMM = [ar objectAtIndex:1];
    CertHandle *certClass = [CertHandle defaultCertHandle];
    certClass.delegate = self;
//    BOOL isVailed = [certClass secVailCertWithXYDic:[bankCGXYDic mutableCopy]];
    if (YES) {
        NSDictionary * dic =nil;
        NSMutableArray * cgxyStr = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"",XYBH_CGYH,
                                                                     [SJKHEngine Instance]->qmlsh,QMLSH_CGYH,
                                                                     [YHDM_IDS objectForKey:[currentDataSource objectForKey:YHDM_CGYH]],HTXY_CGYH, nil],nil];
        
        //            ""cgzd"":{""CGYHSTR"":[{""YHZH"":""555555555555555555"",""YHMM"":""500005500005500005"",""ZZHBZ"":""1"",""BZ"":""1"",""YHDM"":""MSYH""}],""CGXYSTR"":[{""HTXY"":""1"",""XYBH"":"""",""QMLSH"":""2012""}]}
        
        NSMutableArray * cgyhStr = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:insertZH,YHZH_CGYH,
                                                                     [currentDataSource objectForKey:YHDM_CGYH],YHDM_CGYH,
                                                                     @"1",ZZHBZ_CGYH,
                                                                     @"1",BZ_CGYH,
                                                                     insertMM,YHMM_CGYH,
                                                                     nil],nil];
        NSMutableDictionary * saveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         cgxyStr,CGXYSTR_CGYH,
                                         cgyhStr,CGYHSTR_CGYH,
                                         [[SJKHEngine Instance]->khjd_Dic objectForKey:@"bdid"],@"BDID",nil];
        
        if([self saveReCunguanWithJsonDic:saveDic]){
            [self activityIndicate:YES tipContent:@"重新指定成功,跳回开户进度页面" MBProgressHUD:nil target:self.navigationController.view];
            [SJKHEngine Instance]->zhidingstate = NO;
            sleep(1.5);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                [self.navigationController popViewControllerAnimated:YES];
                for (UIViewController * vc in self.navigationController.childViewControllers) {
                    if([vc isMemberOfClass:[LookProcessViewCtrl class]]){
                        [((LookProcessViewCtrl *)vc) kaitongchaxun];
                        break ;
                    }
                }
            });
        }
        else{
            [self activityIndicate:NO tipContent:@"存管重新指定失败" MBProgressHUD:nil target:self.navigationController.view];
        }
    }
}

- (YEorNO)saveReCunguanWithJsonDic:(NSDictionary *)jsonDic{
    NSString * urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,RECGYH];
    if ([NSJSONSerialization isValidJSONObject:jsonDic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString *jsonString = [[NSString alloc]initWithData:tempJsonData encoding:NSUTF8StringEncoding];
        NSLog(@"cunguanzhanghu:%@",jsonString);
        NSURL * URL = [NSURL URLWithString:urlComponent];
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
        bankCGXYDic = [xys mutableCopy];
        if (xys && xys.count > 0 && ok)
        {
            [[xys objectForKey:XYNR] writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:htmlFileKey] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [PublicMethod saveToUserDefaults:[xys objectForKey:ID] key:[currentDataSource objectForKey:YHMC_CGYH]];
            [YHDM_IDS setObject:[NSString stringWithFormat:@"%@",[xys objectForKey:ID]] forKey:[currentDataSource objectForKey:YHDM_CGYH]];
            
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

- (void)dispatchRiskEvaluateVC:(RiskEvaluateViewCtrl *)riskVC{
    NSDictionary * stepDictionary = nil;
    if([self sendSaveCurrentStepKey:FXPC_STEP dataDictionary:&stepDictionary]){
        BOOL ok = [self sendGoToStep:FXPC_STEP dataDictionary:&stepDictionary];
        if(ok){
            [SJKHEngine Instance]->fxpc_step_Dic = [stepDictionary mutableCopy];
//            [stepDictionary writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:FXPC_KEY] atomically:YES];
            
            if ([SJKHEngine Instance]->fxpc_step_Dic &&
                [SJKHEngine Instance]->fxpc_step_Dic.count > 0)
            {
//                currentDataSource = nil;
                
//                [[SJKHEngine Instance]->fxpc_step_Dic writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:FXPC_KEY] atomically:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                    [self.navigationController pushViewController:riskVC animated:YES];
//                    [riskVC updateUI];
                });
            }
            else{
                [self activityIndicate:NO tipContent:@"加载风险评测页面失败" MBProgressHUD:nil target:self.navigationController.view];
            }
        }
        else {
            [self activityIndicate:NO tipContent:@"加载风险评测页面失败" MBProgressHUD:nil target:self.navigationController.view];
//            [[SJKHEngine Instance] dispatchMessage:POP_MESSAGE];
        }
    }
}

- (void)popToLastPage{
    [[SJKHEngine Instance]->_customAlertView removeFromSuperview];
    [SJKHEngine Instance]->_customAlertView = nil;
    
    [phoneEditor resignFirstResponder];
    [passwordEditor resignFirstResponder];
    
    if (bIsRepointPage) {
        [self.navigationController popViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
    }
    else{
        if([SJKHEngine Instance]->mmsz_step_Dic.count == 0 || [SJKHEngine Instance]->mmsz_step_Dic == nil){
            NSArray * ar = self.navigationController.viewControllers;
            BaseViewController * preVC = [ar objectAtIndex:ar.count - 2];
            [[SJKHEngine Instance]->rootVC popToZDPage:MMSZ_STEP preVC:preVC];
        }
        else{
            [self.navigationController popViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
        }
    }
    
    [super popToLastPage];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if(touch.view == readCGXY){
//        return YES;
//    }
//    if ([touch.view isMemberOfClass:[UIButton class]]) {
//        return NO;
//    }
//    else{
//        return YES;
//    }
    
    if(touch.view == scrollView || touch.view == enterFieldSecret){
        return YES;
    }
    else{
        return NO;
    }
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    CGPoint point1 = [gestureRecognizer locationInView:readCGXY];
//    CGPoint point2 = [gestureRecognizer locationInView:nextStepBtn];
//    
//    BOOL bReadCGXYContain = (readCGXY.frame.size.width > point1.x) &&
//    (readCGXY.frame.size.height > point1.y) &&
//    (point1.x > 0) &&
//    (point1.y > 0);
//    BOOL bNestStepContain = (nextStepBtn.frame.size.width > point2.x) &&
//    (nextStepBtn.frame.size.height > point2.y) &&
//    (point2.x > 0) &&
//    (point2.y > 0);
//    
//    if(bReadCGXYContain || bNestStepContain)
//    {
//        return NO;
//    }
//    
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if([ZJMMFirstField valueForKey:@"_clearButton"] || [ZJMMSecondField valueForKey:@"_clearButton"]||
//       touch.view == readCGXY ||
//       touch.view == nextStepBtn)
//    {
//        return NO;
//    }
//    else{
//        return YES;
//    }
//}

- (void)certHandleResault:(NSString *)resaultString{
    if ([resaultString isEqualToString:@"证书验签成功"]) {
        [self activityIndicate:NO tipContent:resaultString MBProgressHUD:nil target:self.navigationController.view];
    }
    else{
        [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
        [self performSelectorOnMainThread:@selector(onShowAlert:) withObject:resaultString waitUntilDone:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc{
    [filterArray removeAllObjects];
    filterArray = nil;
    bankCGXYDic = nil;
    
    [initCenterView removeFromSuperview];
    initCenterView = nil;
    [detailCenterView removeFromSuperview];
    detailCenterView = nil;
    [triangleView removeFromSuperview];
    triangleView = nil;
    [headerBtn removeFromSuperview];
    headerBtn = nil;
    [enterFieldSecret removeFromSuperview];
    enterFieldSecret = nil;
    [phoneEditor removeFromSuperview];
    phoneEditor = nil;
    [passwordEditor removeFromSuperview];
    passwordEditor = nil;
    currentDataSource = nil;
    [readCGXY removeFromSuperview];
    readCGXY = nil;
    [touchControl removeFromSuperview];
    touchControl = nil;
    [warnLab removeFromSuperview];
    warnLab = nil;
    [headerFlowButton removeFromSuperview];
    headerFlowButton = nil;
    [_choosedBtn removeFromSuperview];
    _choosedBtn = nil;
    [markButton removeFromSuperview];
    markButton = nil;
    [YHDM_IDS removeAllObjects];
    YHDM_IDS = nil;
    [dialogTextField removeFromSuperview];
    dialogTextField = nil;
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    NSLog(@"存管银行回收");
}

@end





