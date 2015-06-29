//
//  PECropViewController.m
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "PECropViewController.h"
#import "PECropView.h"
#import "../../ApexiPhoneOpenAccount1.3.1/ApexiPhoneOpenAccount/Data_Structure.h"
#import "../../ApexiPhoneOpenAccount1.3.1/ApexiPhoneOpenAccount/UIImage+custom_.h"
//#import "../../ApexiPhoneOpenAccount1.3.1/ApexiPhoneOpenAccount/SJKHEngine.h"

@interface PECropViewController () <UIActionSheetDelegate>{
    int currentRotateLeftDegree;
    int currentRotateRightDegree;
    int systemVersion ;
    UIToolbar * editorToolbar;
}

@property (nonatomic) UIActionSheet *actionSheet;

@end

@implementation PECropViewController

@synthesize tag;

+ (NSBundle *)bundle
{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"PEPhotoCropEditor" withExtension:@"bundle"];
        bundle = [[NSBundle alloc] initWithURL:bundleURL];
    });
    
    return bundle;
}

static inline NSString *PELocalizedString(NSString *key, NSString *comment)
{
    return [[PECropViewController bundle] localizedStringForKey:key value:nil table:@"Localizable"];
}

//- (id)init{
//    self = [super init];
//    if(self){
//        
//    }
//    return self;
//}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.backgroundColor = [UIColor blackColor];
    self.view = contentView;
    
    self.cropView = [[PECropView alloc] initWithFrame:contentView.bounds];
    [contentView addSubview:self.cropView];
    
//    contentView.frame = CGRectMake(0, 0, screenWidth, screenHeight - UpHeight - ButtonHeight);

    currentRotateLeftDegree = 0;
    currentRotateRightDegree = 0;
    systemVersion = [[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(done:)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
//    UIBarButtonItem *constrainButton = [[UIBarButtonItem alloc] initWithTitle:PELocalizedString(@"Constrain", nil)
//                                                                        style:UIBarButtonItemStyleBordered
//                                                                       target:self
//                                                                       action:@selector(constrain:)];
    UIBarButtonItem *constrainButton = [[UIBarButtonItem alloc] initWithTitle:@"缩放"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(constrain:)];
    
//    UIBarButtonItem * rotateLeftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"rotate_left"] imageByResizingToSize:CGSizeMake(30, 30)] style: UIBarButtonItemStylePlain target:self action:@selector(rotateLeft:)];
//    UIBarButtonItem * rotateRightButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"rotate_right"] imageByResizingToSize:CGSizeMake(30, 30)] style: UIBarButtonItemStylePlain target:self action:@selector(rotateRight:)];
    
//    self.toolbarItems = ;
//    self.navigationController.toolbarHidden = YES;
    
    UIButton * rotateLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotateLeftButton setImage:[[UIImage imageNamed:@"rotate_left"] imageByResizingToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    rotateLeftButton.frame = CGRectMake(screenWidth/3.0 - 44/2, 0, 44, 44);
    [rotateLeftButton addTarget:self action:@selector(rotateLeft:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * rotateRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotateRightButton setImage:[[UIImage imageNamed:@"rotate_right"] imageByResizingToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    rotateRightButton.frame = CGRectMake(screenWidth/3.0*2 - 44/2, 0, 44, 44);
    [rotateRightButton addTarget:self action:@selector(rotateRight:) forControlEvents:UIControlEventTouchUpInside];
    
    editorToolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - ButtonHeight, screenWidth, ButtonHeight)];
//    [editorToolbar setBackgroundColor: ;
    [editorToolbar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] size:CGSizeMake(screenWidth, ButtonHeight)]
                   forToolbarPosition:0
                           barMetrics:UIBarMetricsDefault];
//    editorToolbar.items = @[rotateLeftButton,rotateRightButton];
    [editorToolbar addSubview:rotateLeftButton];
    [editorToolbar addSubview:rotateRightButton];
    
    [self.view addSubview:editorToolbar];
    
//    _cropView.frame = CGRectMake(0, 0, screenWidth, screenHeight - UpHeight - ButtonHeight);
    
    self.cropView.image = self.image;
}

- (void)viewWillAppear:(BOOL)animated{
//    for (UIBarButtonItem * item in self.navigationController.navigationBar.items) {
//        NSLog(@"item =%@",item);
    
//    [self.navigationItem.leftBarButtonItem setBackButtonBackgroundImage:[UIImage imageWithColor: [UIColor colorWithRed:0 green:123.0/255 blue:218.0/255 alpha:1] size:CGSizeMake(60, ButtonHeight)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [self.navigationItem.rightBarButtonItem setBackButtonBackgroundImage:[UIImage imageWithColor: [UIColor colorWithRed:0 green:123.0/255 blue:218.0/255 alpha:1] size:CGSizeMake(60, ButtonHeight)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    }
    
    if(systemVersion < 7){
        //    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:0 green:123.0/255 blue:218.0/255 alpha:1]];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1.0]];
        _cropView.frame = CGRectMake(0, 0, screenWidth, screenHeight - UpHeight - ButtonHeight);
        editorToolbar.frame = CGRectMake(0, self.view.frame.size.height - ButtonHeight, screenWidth, ButtonHeight);
    }
    else {
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        _cropView.frame = CGRectMake(0, 0, screenWidth, screenHeight- ButtonHeight - UpHeight);
        editorToolbar.frame = CGRectMake(0, self.view.frame.size.height - ButtonHeight, screenWidth, ButtonHeight);
    }
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0]];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)rotateLeft:(id)barButtonItem{
    currentRotateLeftDegree ++;
//    CGAffineTransform transform = CGAffineTransformRotate(_cropView.imageView.transform, currentRotateLeftDegree);
//    _cropView.imageView.transform = transform
    _cropView.imageView.transform = CGAffineTransformMakeRotation( -M_PI/2 * currentRotateLeftDegree);;
    
    /*
     向右转90 _cropView.imageView.transform = [0, -1, 1, 0, 0, 0]
     向右转180 [-1, 0, -0, -1, 0, 0]
     向右转270 [0, 1, -1, 0, 0, 0]
     转回原来方向 正方向 [1, 0, -0, 1, 0, 0]
     */
    
//    NSLog(@"_cropView.imageView.transform = %@",NSStringFromCGAffineTransform(_cropView.imageView.transform));
//    CGSize size =  _cropView.croppedImage.size;
//    if(size.width < size.height && currentRotateLeftDegree%2 == 1){
//        _cropView.cropRectView.frame = CGRectMake(_cropView.cropRectView.frame.origin.x,
//                                                  _cropView.cropRectView.frame.origin.y,
//                                                  size.height >= screenWidth ? screenWidth : size.height,
//                                                  _cropView.cropRectView.frame.size.height);
//    }
}

- (void)rotateRight:(id)barButtonItem{
    currentRotateRightDegree ++;
    _cropView.imageView.transform = CGAffineTransformMakeRotation( M_PI/2 * currentRotateRightDegree);;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.cropView.image = image;
}

- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewControllerDidCancel:)]) {
        [self.delegate cropViewControllerDidCancel:self];
    }
}

- (void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:)]) {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage];
    }
}

- (void)constrain:(id)sender
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:PELocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:
                        PELocalizedString(@"Original", nil),
                        PELocalizedString(@"Square", nil),
                        PELocalizedString(@"3 x 2", nil),
                        PELocalizedString(@"3 x 5", nil),
                        PELocalizedString(@"4 x 3", nil),
                        PELocalizedString(@"4 x 6", nil),
                        PELocalizedString(@"5 x 7", nil),
                        PELocalizedString(@"8 x 10", nil),
                        PELocalizedString(@"16 x 9", nil), nil];
    [self.actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CGRect cropRect = self.cropView.cropRect;
        CGSize size = self.cropView.image.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        CGFloat ratio;
        if (width < height) {
            ratio = width / height;
            cropRect.size = CGSizeMake(CGRectGetHeight(cropRect) * ratio, CGRectGetHeight(cropRect));
        } else {
            ratio = height / width;
            cropRect.size = CGSizeMake(CGRectGetWidth(cropRect), CGRectGetWidth(cropRect) * ratio);
        }
        self.cropView.cropRect = cropRect;
    } else if (buttonIndex == 1) {
        self.cropView.aspectRatio = 1.0f;
    } else if (buttonIndex == 2) {
        self.cropView.aspectRatio = 2.0f / 3.0f;
    } else if (buttonIndex == 3) {
        self.cropView.aspectRatio = 3.0f / 5.0f;
    } else if (buttonIndex == 4) {
        CGFloat ratio = 3.0f / 4.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetHeight(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    } else if (buttonIndex == 5) {
        self.cropView.aspectRatio = 4.0f / 6.0f;
    } else if (buttonIndex == 6) {
        self.cropView.aspectRatio = 5.0f / 7.0f;
    } else if (buttonIndex == 7) {
        self.cropView.aspectRatio = 8.0f / 10.0f;
    } else if (buttonIndex == 8) {
        CGFloat ratio = 9.0f / 16.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetHeight(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    }
}

- (void)dealloc{
    NSLog(@"裁剪回收");
    _delegate = nil;
    _image = nil;
    _cropView = nil;
    editorToolbar = nil;
}

@end
