//
//  UploadImageViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-7.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "UploadImageViewCtrl.h"
#import "ClientInfoViewCtrl.h"
#import "RootModelViewCtrl.h"
#import "KHRequestOrSearchViewCtrl.h"
#import "UIImage+custom_.h"
#import "PostWebForm.h"
#import "VideoWitnessViewCtrl.h"
#import "CUIImagePickerController.h"
//#import "UIKit+Tools.h"
#import "CusObject.h"

#define SFZBUTTONTAG 1021
#define IMAGECONTENTTAG 2132

@interface UploadImageViewCtrl (){
    UIImage * selectedImage;
    int currentCameraIndex;                 //当前点击的是正面还是背面拍照的按钮
    int uploadFailBtnTag;
    NSMutableDictionary * imageUploadSign;
//    MBProgressHUD * hud;
    NSMutableArray * images;
    PECropViewController *controller;
    BOOL bImagePickerCropOK;
    NSData * postImageFileData;
    BOOL bUploadFail;
    BOOL bHaveUpdatedUI;                   //已经更新了图片
//    NSString * imagePathKey;
    
    UILabel * requestZRS;
    NSString *HTXYID;
    
    UIButton * frontButton;
    UIButton * backButton;
    UIButton * frontImageView;
    UIButton * backImageView;
    UIDeviceOrientation deviceOrientation;
    
}
@end

@implementation UploadImageViewCtrl

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

- (void) viewWillAppear:(BOOL)animated{
    if([SJKHEngine Instance]->systemVersion >= 7){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    
    [super viewWillAppear:animated];
//    self.navigationController.title = @"影像采集";
}

- (void) viewDidLayoutSubviews{
//    self.view.bounds = CGRectMake(0, -20, screenWidth, screenHeight - UpHeight );
//    [[SJKHEngine Instance] setWindowHeaderView:YES];
}

- (void) viewDidAppear:(BOOL)animated{
    NSArray * arr = [[SJKHEngine Instance]->yxcj_step_Dic objectForKey:SZZRSARR];
    if (arr.count > 0 ) {
        NSDictionary * dic = [arr objectAtIndex:0];
        HTXYID = [dic objectForKey:ID];
    }
    
    if(bReEnter ){
        [self updateUI];
        bReEnter = false;
    }
}

- (void) InitConfig{
    [self.view setBackgroundColor:PAGE_BG_COLOR];
    
    NSArray * arr = [[SJKHEngine Instance]->yxcj_step_Dic objectForKey:SZZRSARR];
    if (arr.count > 0) {
        NSDictionary * dic = [arr objectAtIndex:0];
        HTXYID = [dic objectForKey:ID];
    }
    
    imageUploadSign = [[NSMutableDictionary alloc] init];
    
    currentCameraIndex = 0;
    bUploadFail = NO;
    
    if([SJKHEngine Instance]->systemVersion < 7){
        self.view.bounds = CGRectMake(0, 0, screenWidth, screenHeight);
    }
    
    [self.navigationItem setHidesBackButton:YES];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector (orientationChanged:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(cameraIsReady:)
//                                                 name:AVCaptureSessionDidStartRunningNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(cameraIsReady2:)
//                                                 name:AVCaptureSessionDidStopRunningNotification object:nil];
//    
//    self.view.frame = CGRectMake(0, UpHeight, screenWidth, screenHeight - UpHeight);
//    [super InitConfig];
}

//- (void)orientationChanged:(NSNotification *)noti{
//    NSLog(@"currentOrient = %i",[UIDevice currentDevice].orientation);
////    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//}

- (void) InitWidgets{
//    int viewHeight = screenHeight - UpHeight;
    [self InitScrollView];
    
    int labelHeight = (screenWidth - 300 - 6)/2;
    float avatarWidth = 300;
    float avatarHeight = 175;
    images = [NSMutableArray arrayWithObjects:[UIImage imageNamed:BTN_CERCARD_IMG],[UIImage imageNamed:BTN_CERCARD_IMG2],nil];
    
    int i = 0;
    for (; i < 2; i++) {
        CGFloat top = 0; // 顶端盖高度
        CGFloat bottom = 0 ; // 底端盖高度
        CGFloat left = 0; // 左端盖宽度
        CGFloat right = 0; // 右端盖宽度
        
//        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        
        UIButton * btn = [PublicMethod CreateButton:nil
                                          withFrame:CGRectMake(levelSpace,
                                                               labelHeight+(avatarHeight + labelHeight)*i + FLOWVIEW_BUTTOM + 40,
                                                               avatarWidth,
                                                               avatarHeight)
                                                tag:SFZBUTTONTAG + i
                                             target:scrollView];
        UIImage * image = [images objectAtIndex:i];
//        [btn setImage:[image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        btn.selected = NO;
        [btn addTarget: self action:@selector(onButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        btn.backgroundColor = CLEAR_COLOR;
        btn.layer.borderColor = TEXTFEILD_BOLD_DEFAULT_COLOR.CGColor;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2;
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderWidth = 0.7 ;
        
        CGRect frame = btn.frame;
        frame.origin.x += 72;
        frame.origin.y += 48;
        frame.size.width = 156;
        frame.size.height = 98;
        UIButton *imageView= [[UIButton alloc] initWithFrame:frame];
        imageView.userInteractionEnabled = NO;
//        imageView.contentMode = UIViewContentModeCenter;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.tag = SFZBUTTONTAG * 2 + i;
        [imageUploadSign setObject:@"0" forKey:[NSString stringWithFormat:@"%i",SFZBUTTONTAG * 2 + i]];
        [scrollView addSubview:imageView];
        
        switch (i) {
            case 0:
                frontButton = btn;
                frontImageView = imageView;
                break;
            
            case 1:
                backButton = btn;
                backImageView = imageView;
                break;
        }
    }
    
    int originY = labelHeight+(avatarHeight + labelHeight) + avatarHeight + FLOWVIEW_BUTTOM + 40;
    
    NSMutableArray * options = [NSMutableArray array];
    [options addObject:@"readZRS"];
    NSString * title = @"阅读并同意签署:数字证书申请责任书";
//    float readZRSHeight = [super getHeightForHeaderString:title size:CGSizeMake(screenWidth - 2 * levelSpace - 30 , CGFLOAT_MAX)];
    float readZRSHeight = 44;
    
    requestZRS = [[UILabel alloc]initWithFrame:CGRectMake(5,
                                                                  originY,
                                                                  screenWidth - 5 ,
                                                                   readZRSHeight)];
    requestZRS.font = [UIFont systemFontOfSize:16];
    requestZRS.backgroundColor = CLEAR_COLOR;
    requestZRS.text = title;
    
    [requestZRS presentCertTitleClickToTarget:self andSEL:@selector(CertTitleClicked:) WithSepString:@":"];
    UIButton * markBtn = (UIButton *)[requestZRS viewWithTag:MarkBtnTag];
//    [markBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
    [markBtn setSelected:NO];
    [scrollView addSubview:requestZRS];
//
//    requestZRS = [PublicMethod InitReadXYWithAttributeLabel:title
//                                                  withFrame:CGRectMake(levelSpace,
//                                                                       originY,
//                                                                       screenWidth - 2 * levelSpace ,
//                                                                       readZRSHeight)
//                                                        tag: 2105 // JBZL_VIEW_TAG + i
//                                                     target:self
//                                                    options:options
//                                                  superView:scrollView];
//    
//    
//    CGRect rect = ((TTTAttributedLabel *)[requestZRS viewWithTag:TTTLabelTag]).frame;
//    
//    ((TTTAttributedLabel *)[requestZRS viewWithTag:TTTLabelTag]).frame =
//                                                                CGRectMake(rect.origin.x,
//                                                                           rect.origin.y + 11,
//                                                                           rect.size.width,
//                                                                           rect.size.height);
    
    [self InitNextStepButton:CGRectMake (levelSpace, originY  + requestZRS.frame.size.height , screenWidth - 2*levelSpace , ButtonHeight) tag:SFZBUTTONTAG + i title:@"下一步"];
    
    [scrollView addSubview:nextStepBtn];
    
    [scrollView setContentSize:CGSizeMake(screenWidth, originY + ButtonHeight*2 + verticalHeight)];
    
    [self.view addSubview:scrollView];
    
    [super InitWidgets];
    
    flowView.image = [UIImage imageNamed:@"flow_1"];
    [scrollView addSubview:flowView];
    
    UILabel *la=[[UILabel alloc]initWithFrame: CGRectMake(levelSpace, 40, screenWidth - 2*levelSpace, 40)];
	la.backgroundColor = [UIColor clearColor];
    [la setText:@"建议您在光线良好的环境下,横向拍摄照片,以便工作人员清晰辨识您的证件信息"];
	[la setFont: PublicBoldFont];
    la.textAlignment = NSTextAlignmentLeft;
	[la setTextColor: [UIColor blackColor]];
    la.numberOfLines = 0;
    la.lineBreakMode = NSLineBreakByWordWrapping;
    [scrollView addSubview:la];
    
    scrollView.delegate=self;
}

- (void)CertTitleClicked:(UITapGestureRecognizer *)tgr{
//    [self chageNextStepButtonStype:YES];
    
    //待调试。要改下
    NSError * error = nil;
//    NSString * htmlString = [NSString stringWithContentsOfFile:
//                            [PublicMethod getFilePath:DOCUMENT_CACHE
//                                              fileName:XYZRS_NAME]
//                                              encoding:[SJKHEngine Instance]->stringEncode
//                                                 error:&error];
    
//    if(htmlString == nil || htmlString.length == 0){
        [self showCustomAlertViewContent:YES htmlString:nil];
        [self loadTaskBook];
//    }
//    else{
//        [self showCustomAlertViewContent:YES htmlString:htmlString];
//    }
    
    if([tgr.view isMemberOfClass:[UILabel class]]){
        [[SJKHEngine Instance]->_customAlertView toSetTitleLabel:((UILabel *)tgr.view).text];
    }
}

- (void)stepInfoRequest{
    NSDictionary * stepResponseDic = nil;
    if ([self sendGoToStep:YXCJ_STEP dataDictionary:&stepResponseDic]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self activityIndicate:NO tipContent:Nil MBProgressHUD:hud target:self.navigationController.view];
            NSArray * arr = (NSArray *)[stepResponseDic objectForKey:YXSZ];
            [SJKHEngine Instance]->yxData = [arr mutableCopy];
            [SJKHEngine Instance]->jbzl_step_Dic = [stepResponseDic mutableCopy];
            NSArray * arrr = [[SJKHEngine Instance]->jbzl_step_Dic objectForKey:SZZRSARR];
            if (arr.count > 0) {
                NSDictionary * dic = [arrr objectAtIndex:0];
                HTXYID = [[dic objectForKey:ID] copy];
                return ;
            }
            [self activityIndicate:NO tipContent:@"加载数据失败" MBProgressHUD:hud target:self.navigationController.view];
        });
    }
    else{
        [self activityIndicate:NO tipContent:@"加载数据失败" MBProgressHUD:hud target:self.navigationController.view];
    }
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    UIButton * markBtn = (UIButton *)[requestZRS viewWithTag:MarkBtnTag];
    if(!markBtn.selected){
        markBtn.selected = YES;
        [self chageNextStepButtonStype:YES];
    }
    
    NSError * error = nil;
    NSString * htmlString = [NSString stringWithContentsOfFile:
                             [PublicMethod getFilePath:DOCUMENT_CACHE fileName:XYZRS_NAME]
                                                      encoding:[SJKHEngine Instance]->stringEncode
                                                         error:&error];
    if(htmlString == nil || htmlString.length == 0){
        [self showCustomAlertViewContent:YES htmlString:nil];
        [self loadTaskBook];
    }
    else{
        [self showCustomAlertViewContent:YES htmlString:htmlString];
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

- (void) showCustomAlertViewContent:(BOOL)isShow htmlString:(NSString *)htmlString{
    if(isShow){
        [[SJKHEngine Instance] createCustomAlertView];
        [SJKHEngine Instance]->_customAlertView->htmlKey = XYZRS_NAME;
        [[SJKHEngine Instance]->_customAlertView setTarget:self withSEL:@selector(showCustomAlertViewContent:htmlString:)];
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:YES htmlString:htmlString];
        
        //        int location = [_customAlertView->httpString rangeOfString:@"</p>"].location;
        //        NSString * HttpString = [_customAlertView->httpString substringFromIndex: location + 4];
        //        NSString *htmlString =[NSString stringWithFormat:@"<font face='GothamRounded-Bold' size='30'>%@", HttpString];
        //
        //        NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
        //                                       "<head> \n"
        //                                       "<style type=\"text/css\"> \n"
        //                                       "body {font-family: \"%@\"; font-size: %@;}\n"
        //                                       "</style> \n"
        //                                       "</head> \n"
        //                                       "<body>%@</body> \n"
        //                                       "</html>", @"helvetica", [NSNumber numberWithInt:25], HttpString];
        
    }
    else{
        [[SJKHEngine Instance] JBZLCustomAlertViewXYZRS:NO htmlString:nil];
    }
}

#pragma mark Upsite_____________________________________________________HaoyeeAlert
#pragma mark
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openEditor:(id)sender
{
    [self performSelector:@selector(SetWindowShow) withObject:nil afterDelay:0.2];
//    [[SJKHEngine Instance] setWindowHeaderView:NO];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [navigationController.navigationBar setBackgroundImage:[UIImage
                                                            imageWithColor:NAV_BG_COLOR
                                                            size:CGSizeMake(screenWidth, NAV_HEIGHT)]
                                             forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)_controller{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    controller = nil;
}

- (void)cropViewController:(PECropViewController *)_controller didFinishCroppingImage:(UIImage *)croppedImage
{
    if(!bImagePickerCropOK){
        return ;
    }
    
    bImagePickerCropOK = NO;
//    dispatch_async(dispatch_get_main_queue(), ^{
        [controller dismissViewControllerAnimated:YES completion:^{
            UIButton * btn =((UIButton *)[self.view viewWithTag:currentCameraIndex]);
//            [btn setImage:[UIImage imageWithColor:[UIColor whiteColor] size:btn.frame.size] forState:UIControlStateNormal];
//            [btn setImage:croppedImage];
            [btn setBackgroundColor:[UIColor whiteColor]];
            NSLog(@"btn =%@",btn);
            
//            [btn setContentStretch:CGRectZero];
            [btn setContentMode:UIViewContentModeScaleToFill];
            [self setImageInset:btn image:[croppedImage createGrayImage]];
//            [btn setImage:[croppedImage createGrayImage] forState:UIControlStateNormal];
//            [btn setClipsToBounds:YES];
//        [btn setImage:[croppedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch]];
//            [btn setImage:[[croppedImage createGrayImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
//            [btn setImage:[[croppedImage imageByResizingToSize:btn.frame.size] createGrayImage]];
            [self cropFinishToCompressImage:croppedImage];
        }];
//    });
    
    controller = nil;
}

- (NSData *)reduceImageSize:(UIImage *)croppedImage{
    NSData * cropImageData = UIImageJPEGRepresentation(croppedImage, 1);
    float size = cropImageData.length / 1024.0;
    
    if(size > 3000){
        cropImageData = UIImageJPEGRepresentation(croppedImage, 0.01);
    }
    else if(size > 1000 && size <= 3000){
        cropImageData = UIImageJPEGRepresentation(croppedImage, 0.05);
    }
    else if(size > 500 && size <= 1000){
        cropImageData = UIImageJPEGRepresentation(croppedImage, 0.1);
    }
    else if(size > 150 && size <= 500){
        cropImageData = UIImageJPEGRepresentation(croppedImage, 0.2);
    }
    else{
        cropImageData = UIImageJPEGRepresentation(croppedImage, 0.5);
    }
    
    return cropImageData;
}

- (IBAction)cameraButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Photo Album", nil), nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Camera", nil)];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [actionSheet showFromBarButtonItem:self.cameraButton animated:YES];
    }
    else {
        [actionSheet showFromToolbar:self.navigationController.toolbar];
    }
}

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self performSelector:@selector(SetWindowShow) withObject:nil afterDelay:0.2];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        if (self.popover.isPopoverVisible) {
//            [self.popover dismissPopoverAnimated:NO];
//        }
//
//        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
//        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
//                             permittedArrowDirections:UIPopoverArrowDirectionAny
//                                             animated:YES];
    }
    else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void) SetWindowShow{
    [[SJKHEngine Instance] setWindowHeaderView:NO];
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    [self performSelector:@selector(SetWindowShow) withObject:nil afterDelay:0.2];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //        if (self.popover.isPopoverVisible) {
        //            [self.popover dismissPopoverAnimated:NO];
        //        }
        //
        //        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        //        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
        //                             permittedArrowDirections:UIPopoverArrowDirectionAny
        //                                             animated:YES];
    }
    else {
//        [[SJKHEngine Instance]->rootVC vcOperation:controller];
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * titleInIndex = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([titleInIndex isEqualToString:@"打开相册"]){
        [self openPhotoAlbum];
    }
    else if ([titleInIndex isEqualToString:@"拍照"]){
        [self showCamera];
    }
    else if([titleInIndex isEqualToString:@"重新上传"]){
        [self ServerAuthenticate:TPSC_REQUEST];
    }
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker1 {
    [picker1 dismissModalViewControllerAnimated:YES];
//    picker1 = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    @autoreleasepool {
        if(controller == Nil){
            controller = [[PECropViewController alloc] init];
            controller.delegate = self;
            controller.image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(autoWidth(280), autoHeight(373))];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self openEditor:nil];
        }
        else {
            [picker dismissViewControllerAnimated:YES completion:^{
                [self openEditor:nil];
            }];
        }
        [controller.navigationItem.rightBarButtonItem setEnabled:NO];
        
        while (!controller.cropView) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        UIImage * cropImage1 = info[UIImagePickerControllerOriginalImage];
        
//    [self cropImage:[cropImage fixOrientation]];
        
//    UIImage * cropImage = [cropImage1 fixOrientation];
        
//    CGImageRef cgRef = cropImage1.CGImage;
//    UIImage * cropImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationDown];
        
//    UIGraphicsBeginImageContextWithOptions(cropImage1.size, NO, cropImage1.scale);
//    [cropImage1 drawInRect:(CGRect){0, 0, cropImage1.size}];
//    UIImage * cropImage= UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
        
        UIImage * cropImage = [self scaleAndRotateImage:cropImage1];
        NSLog(@"orien =%i,%i",cropImage1.imageOrientation,cropImage.imageOrientation);
        
        [self cropImage:cropImage];
//    }
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    NSLog(@"boudns image =%@",NSStringFromCGRect(bounds));
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    
    switch(orient) {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
//        default:
//            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (BOOL)cropImage:(UIImage *)image
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * imgData = UIImageJPEGRepresentation(image, 1);
        NSLog(@"size =%f",imgData.length/1024.0);
        
        imgData = [self reduceImageSize:image];
        
        NSLog(@"size 1=%f",imgData.length/1024.0);
        
        NSString * selectImagePath = [PublicMethod getFilePath:DOCUMENT_CACHE fileName:SelectedImageData];
        if([[NSFileManager defaultManager]fileExistsAtPath:selectImagePath]){
            NSError * er = nil;
            [[NSFileManager defaultManager]removeItemAtPath:selectImagePath error:&er];
        }
        [imgData writeToFile:selectImagePath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:nil];
            //            UIImage * image = [UIImage imageWithContentsOfFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:SelectedImageData]];
            
            UIImage * img = [UIImage imageWithData:imgData];
            controller.image = img;
            controller.cropView.image = img;
            [controller.navigationItem.rightBarButtonItem setEnabled:YES];
            bImagePickerCropOK = YES;
            NSLog(@"controller cropview =%@,%@,%@",controller,controller.cropView,img);
        });
    });
    return YES;
}

- (void)cropFinishToCompressImage:(UIImage *)image
{
//    @autoreleasepool {
        [self activityIndicate:YES tipContent:@"裁剪图片..." MBProgressHUD:nil target:self.navigationController.view];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * postImageData = nil;
            
            postImageData = [self reduceImageSize:image];
            
            NSLog(@"postImageData =%f",postImageData.length / 1024.0);
            postImageData = [self reduceImageSize:[UIImage imageWithData:postImageData]];
            NSLog(@"postImageData after =%f",postImageData.length / 1024.0);
            
//            UIImage * scaleImage = [UIImage imageWithData:postImageData];
//            float size = postImageData.length / 1024.0;
//            if(size > 500){
//                postImageData = UIImageJPEGRepresentation(scaleImage, 0.2);
//            }
//            else if(size <= 500 && size > 300){
//                postImageData = UIImageJPEGRepresentation(scaleImage, 0.5);
//            }
//            else if (size<= 300 && size >100){
//                postImageData = UIImageJPEGRepresentation(scaleImage, 0.6);
//            }
//            else if (size<= 100 && size >20){
////                scaleImage = [scaleImage imageByResizingToSize:CGSizeMake(200, 200)];
//                postImageData = UIImageJPEGRepresentation(scaleImage, 0.7);
//            }
            
            NSString * selectImagePath = [PublicMethod getFilePath:DOCUMENT_CACHE fileName:CropImageData];
            if([[NSFileManager defaultManager]fileExistsAtPath:selectImagePath]){
                NSError * er = nil;
                [[NSFileManager defaultManager]removeItemAtPath:selectImagePath error:&er];
                NSLog(@"存在,error = %@",er);
            }
            BOOL ok = [postImageData writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:CropImageData] atomically:YES];
            NSLog(@"postImageData after1 =%f,%i",postImageData.length / 1024.0,ok);
            
//        postImageData = nil;
//        postImageFileData = postImageData;
            
//        sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                [self ServerAuthenticate:TPSC_REQUEST];
            });
        });
//   }
}

- (NSString *)getUploadImageDataPath:(UIButton *)imageView{
    if (imageView == frontImageView) {
        return [PublicMethod getFilePath:DOCUMENT_CACHE fileName:[NSString stringWithFormat:@"uploadImage_%@_1",[SJKHEngine Instance]->SJHM]];
    }
    else{
        return [PublicMethod getFilePath:DOCUMENT_CACHE fileName:[NSString stringWithFormat:@"uploadImage_%@_2",[SJKHEngine Instance]->SJHM]];
    }
}

- (void)dealloc{
    selectedImage = nil;
    [imageUploadSign removeAllObjects];
    imageUploadSign = nil;
    [images removeAllObjects];
    images = nil;
    controller = nil;
    postImageFileData = nil;
    [requestZRS removeFromSuperview];
    requestZRS = nil;
    [frontButton removeFromSuperview];
    frontButton = nil;
    [backButton removeFromSuperview];
    backButton = nil;
    [frontImageView removeFromSuperview];
    frontImageView = nil;
    [backImageView removeFromSuperview];
    backImageView = nil;
    
    NSLog(@"图片上传回收");
}

- (void)onButtonClick:(UIButton *)btn{
    //阅读责任书按钮
    if(btn.tag == 2015){
        UIButton * markBtn = (UIButton *)[btn viewWithTag:MarkBtnTag];
        if(!markBtn.isSelected){
            NSError * error = nil;
            NSString * htmlString = [NSString stringWithContentsOfFile:
                                     [PublicMethod getFilePath:DOCUMENT_CACHE fileName:XYZRS_NAME]
                                                              encoding:[SJKHEngine Instance]->stringEncode
                                                                 error:&error];
            if(htmlString == nil || htmlString.length == 0){
                [self showCustomAlertViewContent:YES htmlString:nil];
                
                [self loadTaskBook];
            }
            else{
                [self showCustomAlertViewContent:YES htmlString:htmlString];
            }
            
            [markBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
            [markBtn setSelected:YES];
            [self chageNextStepButtonStype:YES];
        }
        else{
            [markBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_default"] forState:UIControlStateNormal];
            [markBtn setSelected:NO];
            [self chageNextStepButtonStype:NO];
        }
        return;
    }
    
    else if(btn.tag == MarkBtnTag){
        if(btn.selected){
            [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_default"] forState:UIControlStateNormal];
            btn.selected = NO;
        }
        else{
            [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
            btn.selected = YES;
        }
        return;
    }
    __autoreleasing UIActionSheet *actionSheet = nil;
    if(bUploadFail && btn.tag == uploadFailBtnTag){
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle: Nil
                       delegate: self
                       cancelButtonTitle: @"取消"
                       destructiveButtonTitle: Nil
                       otherButtonTitles:@"重新上传",@"打开相册",@"拍照",Nil];
    }
    else{
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle: Nil
                       delegate: self
                       cancelButtonTitle: @"取消"
                       destructiveButtonTitle: Nil
                       otherButtonTitles:@"打开相册",@"拍照",Nil];
        
    }
    if(btn == frontButton || btn == backButton){
        if(btn == frontButton){
            frontButton.layer.borderColor = TEXTFEILD_BOLD_HIGHLIGHT_COLOR.CGColor;
            backButton.layer.borderColor = TEXTFEILD_BOLD_DEFAULT_COLOR.CGColor;
        }
        else{
            frontButton.layer.borderColor = TEXTFEILD_BOLD_DEFAULT_COLOR.CGColor;
            backButton.layer.borderColor = TEXTFEILD_BOLD_HIGHLIGHT_COLOR.CGColor;
        }
        
        currentCameraIndex = btn.tag + SFZBUTTONTAG;
        [actionSheet showInView:self.view];
        
        return ;
    }
    //下一步
    else {
        NSEnumerator* keyEnumerator = [imageUploadSign keyEnumerator];
        id key;
//        bool upload_all_image = YES;
        
        while ((key = [keyEnumerator nextObject]) != nil)
        {
            if([[imageUploadSign objectForKey:key] isEqualToString:@"0"]){
//                upload_all_image = NO;
            }
        }
//        [NSString stringWithFormat:@"%i",SFZBUTTONTAG * 2 + i]
        if([[imageUploadSign objectForKey:[NSString stringWithFormat:@"%i",SFZBUTTONTAG * 2]] intValue] == 0){
//            upload_all_image = NO;
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证正面未上传" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            
            return ;
        }
        else if ([[imageUploadSign objectForKey:[NSString stringWithFormat:@"%i",SFZBUTTONTAG * 2 + 1]] intValue] == 0){
//            upload_all_image = NO;
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证背面未上传" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            
            return ;
        }
        else{
            [self ServerAuthenticate:BCDQBZKEY_REQUEST];
        }
    }
    
}

- (void) ServerAuthenticate:(REQUEST_TYPE)request_type{
    @autoreleasepool {
        NSString * urlComponent = nil;
        
        switch (request_type) {
            case TPSC_REQUEST:
                urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,TPSH];
                break;
                
            case BCDQBZKEY_REQUEST:
                urlComponent= [NSString stringWithFormat:@"%@://%@%@%@", [SJKHEngine Instance]->isHttps?@"https":@"http",[SJKHEngine Instance]->doMain,[SJKHEngine Instance]->port,BCDQBZKEY];
                break;
                
            default:
                break;
        }
        NSURL * URL = [NSURL URLWithString:urlComponent];
        
        ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:[PublicMethod suburlString:URL]];
        [theRequest setValidatesSecureCertificate:NO];
        [theRequest setClientCertificateIdentity:[SJKHEngine Instance]->identify];
        [theRequest setRequestMethod:@"POST"];
//        [theRequest setAllowCompressedResponse:NO];
        [theRequest setTimeOutSeconds:15];
        switch (request_type) {
            case BCDQBZKEY_REQUEST:{
                if (!HTXYID || !((UIButton *)[requestZRS viewWithTag:MarkBtnTag]).selected) {
                    NSLog(@"%d",((UIButton *)[requestZRS viewWithTag:MarkBtnTag]).selected);
                    NSLog(@"HTXYID = %@",HTXYID);
                    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:Nil message:@"请先阅读下方责任书" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertview show];
                    break;
                }
                [self activityIndicate:YES tipContent:@"加载客户信息..." MBProgressHUD:nil target:self.navigationController.view];
                ClientInfoViewCtrl * clientInfoCtrl = [[ClientInfoViewCtrl alloc]init];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self goJBJLPage:clientInfoCtrl];
                    
                    if ([SJKHEngine Instance]->jbzl_step_Dic != nil &&
                        clientInfoCtrl->jbzl_step_OCR_Dic != nil)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [clientInfoCtrl updateUI];
                        });
                    }
                });
            }
                break;
            case TPSC_REQUEST:{
                NSArray *ar = [PublicMethod convertURLToArray:[URL absoluteString]];
                
                [self activityIndicate:YES tipContent:@"正在上传图片..." MBProgressHUD:nil target:self.navigationController.view];
                theRequest.request_type = TPSC_REQUEST;
                [theRequest setPostValue:[SJKHEngine Instance]->SJHM forKey:[ar firstObject]];
                
                [theRequest setFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:CropImageData] forKey:[ar objectAtIndex:1]];
                
                NSLog(@"data =%@,%@",[[[SJKHEngine Instance]->yxData objectAtIndex:currentCameraIndex - SFZBUTTONTAG*2] objectForKey:YXLX_KEY],[[[SJKHEngine Instance]->yxData objectAtIndex:currentCameraIndex - SFZBUTTONTAG*2] objectForKey:YXLXMC_KEY]);
                
                [theRequest setPostValue:[[[SJKHEngine Instance]->yxData objectAtIndex:currentCameraIndex - SFZBUTTONTAG*2] objectForKey:YXLX_KEY] forKey:[ar objectAtIndex:2]];
                [theRequest setPostValue:[[[SJKHEngine Instance]->yxData objectAtIndex:currentCameraIndex - SFZBUTTONTAG*2] objectForKey:YXLXMC_KEY] forKey:[ar objectAtIndex:3]];
                
                [theRequest setShouldAttemptPersistentConnection:NO];
                [theRequest setShouldStreamPostDataFromDisk:YES];
                [theRequest setPostValue:HTXYID forKey:@"htxy"];
                [theRequest setDelegate:self];
                [theRequest setUploadProgressDelegate:self];
                [theRequest setDidFailSelector:@selector(httpFailed:)];
                [theRequest setDidFinishSelector:@selector(httpFinished:)];
                
                bUploadFail = NO;
                [theRequest startAsynchronous];
            }
                break;
                
            default:
                
                break ;
        }
    }
}

//- (BOOL) connection: (NSURLConnection *)connection canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace
//{
//    NSLog(@"protectionSpace =%@",protectionSpace);
//    return [protectionSpace.authenticationMethod isEqualToString: NSURLAuthenticationMethodServerTrust] ||
//           [protectionSpace.authenticationMethod isEqualToString: NSURLAuthenticationMethodClientCertificate] ;
//}
//
//- (void) connection: (NSURLConnection *)connection didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
//{
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//	{
//		[challenge.sender useCredential: [NSURLCredential credentialForTrust: challenge.protectionSpace.serverTrust]
//			 forAuthenticationChallenge: challenge];
//    }
//    //为服务器信任客户端所做的操作。只写了代码,待调试
//    else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]){
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
////        SecCertificateRef myCert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)PKCS12Data);
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
//    [challenge.sender continueWithoutCredentialForAuthenticationChallenge: challenge];
//}

//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    NSLog(@"receive data=%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] );
//}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [imageUploadSign setObject:@"1" forKey:[NSString stringWithFormat:@"%i",currentCameraIndex]];
    UIButton * btn =((UIButton *)[self.view viewWithTag:currentCameraIndex]);
    UIImage * cropImage = [UIImage imageWithContentsOfFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:CropImageData]];
    [btn setImage:cropImage forState:UIControlStateNormal];
    [self activityIndicate:NO tipContent:Nil MBProgressHUD:hud target:self.navigationController.view];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIButton * btn =((UIButton *)[self.view viewWithTag:currentCameraIndex]);
    [btn setImage:nil forState:UIControlStateNormal];
    [btn setImage:[images objectAtIndex:currentCameraIndex - SFZBUTTONTAG*2] forState:UIControlStateNormal];
    [self activityIndicate:NO tipContent:@"上传失败,您可重新上传" MBProgressHUD:hud target:self.navigationController.view];
}

//是否是jpeg格式
-(BOOL)dataIsValidJPEG:(NSData *)data
{
    if (!data || data.length < 2) return NO;
    
    NSInteger totalBytes = data.length;
    const char *bytes = (const char*)[data bytes];
    
    return (bytes[0] == (char)0xff &&
            bytes[1] == (char)0xd8 &&
            bytes[totalBytes-2] == (char)0xff &&
            bytes[totalBytes-1] == (char)0xd9);
}

- (void)goJBJLPage:(ClientInfoViewCtrl *)vc{
    NSDictionary * stepDictionary = nil;
    if([self sendSaveCurrentStepKey:JBZL_STEP dataDictionary:&stepDictionary]){
        [SJKHEngine Instance]->jbzl_step_Dic = nil;
        BOOL ok = [self sendGoToStep:JBZL_STEP dataDictionary:&stepDictionary];
        if(ok){
            [SJKHEngine Instance]->jbzl_step_Dic = [stepDictionary mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self activityIndicate:NO tipContent:nil MBProgressHUD:nil target:self.navigationController.view];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
//            if([self sendOCRInfo: &stepDictionary]){
//                vc->jbzl_step_OCR_Dic = [stepDictionary mutableCopy];
//            }
//            else{
////                [[SJKHEngine Instance] dispatchMessage:GET_OCR_FAIL_POP_MESSAGE];
//                [self activityIndicate:NO tipContent:@"获取图像识别数据失败" MBProgressHUD:nil target:self.navigationController.view];
//            }
        }
        else {
            [self activityIndicate:NO tipContent:@"加载客户页面失败" MBProgressHUD:nil target:self.navigationController.view];
//            [[SJKHEngine Instance] dispatchMessage:POP_MESSAGE];
        }
    }
    else {
         [self activityIndicate:NO tipContent:@"保存页面数据失败" MBProgressHUD:nil target:self.navigationController.view];
    }
}

//上传失败时发生的情况，一是出现两次newLength方法；一个是上传的bytes为负数。
- (void) httpFailed:(ASIHTTPRequest *)http{
    [super httpFailed:http];
    NSData *responseData = [http responseData];
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Server response:%@", response);
    NSLog(@"http fail =%@,%@",http,http.error);
    bUploadFail = YES;
    uploadFailBtnTag = [scrollView viewWithTag:currentCameraIndex].tag;
    
    if(http.request_type == TPSC_REQUEST){
        if([[responseDictionary objectForKey:SUCCESS] intValue] == 0){
            NSLog(@"[responseDictionary objectForKey:NOTE] =%@",[responseDictionary objectForKey:NOTE]);
            [self activityIndicate:NO tipContent:@"上传失败,您可重新上传" MBProgressHUD:hud target:self.navigationController.view];
        }
        
        if(http.responseData.length == 0){
            [self activityIndicate:NO tipContent:@"上传失败,您可重新上传" MBProgressHUD:hud target:self.navigationController.view];
        }
    }
}

- (void) httpFinished:(ASIHTTPRequest *)http{
    [super httpFinished:http];
    NSLog(@"http finish =%@,%@",http,http.error);
    
    if(http.request_type == TPSC_REQUEST){
        if([[responseDictionary objectForKey:SUCCESS] intValue] == 1){
            [imageUploadSign setObject:@"1" forKey:[NSString stringWithFormat:@"%i",currentCameraIndex]];
            //此imageview对象为嵌入到方框中的图片对象。
            UIButton * btn =((UIButton *)[self.view viewWithTag:currentCameraIndex]);
            UIImage * cropImage = [UIImage imageWithContentsOfFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:CropImageData]];
            [btn setImage:nil forState:UIControlStateNormal];
            
            [self setImageInset:btn image:cropImage];
            
            [self activityIndicate:NO tipContent:Nil MBProgressHUD:hud target:self.navigationController.view];
//            if(bReEnter){
                [SJKHEngine Instance]->bReUploadImage = YES;
//            }
            
            if(currentCameraIndex == 2 * SFZBUTTONTAG){
                [PublicMethod fileManageCopyFileFromPath:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:CropImageData] toPath:[self getUploadImageDataPath:frontImageView]];
            }
            if(currentCameraIndex == 2 * SFZBUTTONTAG + 1){
                [PublicMethod fileManageCopyFileFromPath:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:CropImageData] toPath:[self getUploadImageDataPath:backImageView]];
            }
        }
        else{
            UIButton * btn =((UIButton *)[self.view viewWithTag:currentCameraIndex]);
            [btn setImage:nil forState:UIControlStateNormal];
            [self setImageInset:btn image:[images objectAtIndex:currentCameraIndex - SFZBUTTONTAG*2]];
//            [btn setImage:[images objectAtIndex:currentCameraIndex - SFZBUTTONTAG*2] forState:UIControlStateNormal];
            [self activityIndicate:NO tipContent:@"上传失败,您可重新上传" MBProgressHUD:hud target:self.navigationController.view];
        }
    }
    
    http = nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    UINavigationItem *ipcNavBarTopItem;
//
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Photos"
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:self
//                                                                  action:@selector(saveImages:)];
//    
//    UINavigationBar *bar = navigationController.navigationBar;
//    [bar setHidden:NO];
//    ipcNavBarTopItem = bar.topItem;
//    ipcNavBarTopItem.title = @"Photos";
//    ipcNavBarTopItem.rightBarButtonItem = doneButton;
    
//    if([viewController isMemberOfClass:[UIImagePickerController class]]){
    
    //对相机的自定义顶部栏的操作，以后再做
//    UINavigationBar *bar =
    [navigationController.navigationBar setBackgroundImage:[UIImage
                            imageWithColor:NAV_BG_COLOR
                            size:CGSizeMake(screenWidth, NAV_HEIGHT)]
                                             forBarMetrics:UIBarMetricsDefault];
//    UILabel * localtipLabel = [PublicMethod initLabelWithFrame:CGRectMake(screenWidth/2 - 100/2, 0 , 100, ButtonHeight)
//                                                         title:navigationController.navigationItem.title
//                                                        target:nil];
//    localtipLabel.font = [UIFont boldSystemFontOfSize:22];
//    [localtipLabel setTextColor:[UIColor whiteColor]];
//    localtipLabel.textAlignment = NSTextAlignmentCenter;
//    navigationController.navigationItem.titleView = localtipLabel;
  
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],UITextAttributeTextColor,
                                               [UIColor blackColor], UITextAttributeTextShadowColor,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset,
                                               [UIFont boldSystemFontOfSize:22],UITextAttributeFont, nil];
    
    [navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    
    
//    [navigationController.navigationBar setTintColor:NAV_BG_COLOR];
    
//    for(UINavigationItem *item in bar.items){
//        NSLog(@"title view =%@,%@", item.title,item.titleView);
//        [item.rightBarButtonItem setTitleTextAttributes:@{
//                                                                    UITextAttributeFont:TipFont,
//                                                                    UITextAttributeTextColor:[UIColor whiteColor],
//                                                                    UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]
//                                                                    }
//                                                                forState:UIControlStateNormal];
//        [item.leftBarButtonItem setTitleTextAttributes:@{
//                                                          UITextAttributeFont:TipFont,
//                                                          UITextAttributeTextColor:[UIColor whiteColor],
//                                                          UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]
//                                                          }
//                                               forState:UIControlStateNormal];
//    }
}

- (void)popToLastPage{
    [[SJKHEngine Instance]->_customAlertView removeFromSuperview];
    [SJKHEngine Instance]->_customAlertView = nil;
    
    [[SJKHEngine Instance] onClearKaihuData];
    [self.navigationController popViewControllerAnimated:[SJKHEngine Instance]->bPopAnimate];
    [super popToLastPage];
}

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes{
    NSLog(@"上传bytes = %lli",bytes);
}

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength{
    NSLog(@"newlength =%lli",newLength);
}

- (void)setImageInset:(UIButton *)btn image:(UIImage *)cropImage{
    float InsetWidth = 0;
    if(cropImage.size.width < cropImage.size.height){
        CGSize size = cropImage.size;
        float ratio = size.height / size.width;
        InsetWidth = (btn.frame.size.width - btn.frame.size.height / ratio)/2;
    }
    [btn setImage:cropImage forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, InsetWidth, 0, InsetWidth);
}

- (void) updateUI{
    __block UIImage * frontImage = nil;
    __block UIImage * backImage = nil;
    frontImage = [UIImage imageWithContentsOfFile: [self getUploadImageDataPath:frontImageView]];
    backImage = [UIImage imageWithContentsOfFile: [self getUploadImageDataPath:backImageView]];
    
    if (frontImage) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type = kCATransitionFade;
        [frontImageView.layer addAnimation:transition forKey:@"transition"];
//        [frontImageView setImage:nil forState:UIControlStateNormal];
//        [frontImageView setImage:[UIImage imageWithColor:[UIColor whiteColor] size:frontImageView.frame.size] forState:UIControlStateNormal];
        [frontImageView setImage:nil forState:UIControlStateNormal];
        [frontImageView setBackgroundColor:[UIColor whiteColor]];
        [self setImageInset:frontImageView image:frontImage];
        [imageUploadSign setObject:@"1" forKey:[NSString stringWithFormat:@"%i",SFZBUTTONTAG * 2 ]];
    }
    if (backImage) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type = kCATransitionFade;
        [backImageView.layer addAnimation:transition forKey:@"transition"];
//        [backImageView setImage:[UIImage imageWithColor:[UIColor whiteColor] size:backImageView.frame.size] forState:UIControlStateNormal];
        [backImageView setBackgroundColor:[UIColor whiteColor]];
        [self setImageInset:backImageView image:backImage];
        [imageUploadSign setObject:@"1" forKey:[NSString stringWithFormat:@"%i",SFZBUTTONTAG * 2 + 1]];
    }
    else if(frontImage == nil || backImage == nil){
        [self activityIndicate:YES tipContent:@"获取图像数据..." MBProgressHUD:nil target:self.navigationController.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary * stepResponseDic = nil;
            if([self sendGetStepInfo:YXCJ_STEP dataDictionary:&stepResponseDic]){
                [self toLoadImageData:stepResponseDic index:0];
                [self toLoadImageData:stepResponseDic index:1];
            }
            else{
                [self activityIndicate:NO tipContent:@"获取数据失败" MBProgressHUD:nil target:self.navigationController.view];
            }
        });
    }

    [self.view setNeedsDisplay];
    [self.view setNeedsLayout];
}

- (void) toLoadImageData:(NSDictionary *)stepResponseDic index:(int)index{
    NSString * tip = @"";
    __block UIButton * imageView = nil;
    
    if(index == 0){
        imageView = frontImageView;
    }
    if(index == 1){
        imageView = backImageView;
    }
    
    NSString * filepath = [[[[stepResponseDic objectForKey:YXCJ_STEP] objectForKey:@"YXSTR"] objectAtIndex:index] objectForKey:FILEPATH_YXCJ];
    if(filepath){
        NSData * data = [self toSendYXCJTPXZ:&stepResponseDic sourceArray:[NSArray arrayWithObjects:filepath, nil]];
        [self activityIndicate:NO tipContent:nil MBProgressHUD:Nil target:self.navigationController.view];
        if(data){
            [self performSelectorOnMainThread:@selector(updateImageView:) withObject:[NSArray arrayWithObjects:data,[NSNumber numberWithInt:index],imageView, nil] waitUntilDone:YES];
        }
        else{
            switch (index) {
                case 0:
                    tip = @"正面图像获取失败";
                    break;
                    
                case 1:
                    tip = @"背面图像获取失败";
                    break;
            }
            [self activityIndicate:NO tipContent:tip MBProgressHUD:nil target:self.navigationController.view];
        }
    }
    else{
        switch (index) {
            case 0:
                tip = @"正面图像路径获取失败";
                break;
                
            case 1:
                tip = @"背面图像路径获取失败";
                break;
        }
        [self activityIndicate:NO tipContent:tip MBProgressHUD:nil target:self.navigationController.view];
    }
}

- (void)updateImageView:(NSArray *)ar{
    int index = [[ar objectAtIndex:1] intValue];
    UIButton * imageView = [ar objectAtIndex:2];
    UIImage * image = [UIImage imageWithData:[ar objectAtIndex:0]];
    
    [imageView.layer addAnimation:[self getTransition] forKey:@"transition"];
    [self setImageInset:imageView image:image];
    [imageUploadSign setObject:@"1" forKey:[NSString stringWithFormat:@"%i",SFZBUTTONTAG * 2 + index ]];
}

- (CATransition *)getTransition{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionFade;
    
    return transition;
}

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration{
    NSLog(@"illChangeStatusBarOrientatio");
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation{
    NSLog(@"didChangeStatusBarOrientation");

}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame{
    NSLog(@" willChangeStatusBarFrame:");
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame{
    NSLog(@"didChangeStatusBarFrame");
}


@end


















