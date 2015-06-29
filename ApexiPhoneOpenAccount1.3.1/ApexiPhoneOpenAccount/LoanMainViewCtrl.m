//
//  LoanMainViewCtrl.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-6.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "LoanMainViewCtrl.h"
#import "SJKHEngine.h"
#import "UIImage+custom_.h"
#import "LoanBaseViewCtrl.h"
#import "LoginViewCtrl.h"

@interface LoanMainViewCtrl ()

@end

@implementation LoanMainViewCtrl

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
    
    [SJKHEngine Instance]->loanMainVC = self;
    bTouchFirstPage = NO;
        
    [self initTabbar];
    [self initWidget];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) initWidget{
//    CGRect rectScreen = [[UIScreen mainScreen] applicationFrame];
	me_RedCycleButton = [UIButton buttonWithType: UIButtonTypeCustom];
	me_RedCycleButton.frame = CGRectMake (screenWidth - 30, 2, 10, 10);
	UIImage *imageButtokBk = [UIImage imageNamed: @"point"];
	me_RedCycleButton.titleLabel.font = [UIFont systemFontOfSize: 12];
	[me_RedCycleButton setBackgroundImage: imageButtokBk forState: UIControlStateNormal];
	[me_RedCycleButton setBackgroundImage: imageButtokBk forState: UIControlStateHighlighted];
	[me_RedCycleButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
	[me_RedCycleButton setTitleColor: [UIColor whiteColor] forState: UIControlStateHighlighted];
	[me_RedCycleButton setHidden: YES];
	[self.tabBar addSubview: me_RedCycleButton];
    
	jk_RedCycleButton = [UIButton buttonWithType: UIButtonTypeCustom];
	jk_RedCycleButton.frame = CGRectMake (screenWidth/4*3.0 - 30, 2, 10, 10);
	jk_RedCycleButton.titleLabel.font = [UIFont systemFontOfSize: 12];
	[jk_RedCycleButton setBackgroundImage: imageButtokBk forState: UIControlStateNormal];
	[jk_RedCycleButton setBackgroundImage: imageButtokBk forState: UIControlStateHighlighted];
	[jk_RedCycleButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
	[jk_RedCycleButton setTitleColor: [UIColor whiteColor] forState: UIControlStateHighlighted];
	[jk_RedCycleButton setHidden: YES];
	[self.tabBar addSubview: jk_RedCycleButton];
}

- (void)initTabbar{
    UIImage * tabbarImage = [[UIImage imageNamed:@"SmallLoanBundle.bundle/images/bg_menu"] imageByResizingToSize:CGSizeMake(screenWidth, self.tabBar.frame.size.height)];
    [self.tabBar setBackgroundImage:tabbarImage];
    
    UIImage * image = nil;
    UIImage * hightLightImage = nil;
    NSMutableArray * ar = [NSMutableArray arrayWithObjects:@"home",@"jk",@"hk",@"me", nil];
    
    for (int i=0 ; i<self.viewControllers.count ; i++){
        NSString * imageName = [NSString stringWithFormat:@"menu_%@_",[ar objectAtIndex:i]];
        image = [UIImage imageNamed:[imageName stringByAppendingString:@"default"]];
        image = [image imageByResizingToSize:CGSizeMake(image.size.width/3*2.0, image.size.height/3*2.0)];
        
        hightLightImage = [UIImage imageNamed:[imageName stringByAppendingString:@"active"]];
        hightLightImage = [hightLightImage imageByResizingToSize:CGSizeMake(hightLightImage.size.width/3*2.0, hightLightImage.size.height/3*2.0)];
        
        UITabBarItem *item = ((UINavigationController *)[self.viewControllers objectAtIndex:i]).tabBarItem ;
        
        if([SJKHEngine Instance]->systemVersion >= 7){
            hightLightImage = [hightLightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [item setSelectedImage:hightLightImage];
            [item setImage:image];
        }
        else {
            [item setFinishedSelectedImage:hightLightImage withFinishedUnselectedImage:image];
        }
        
//        UIImage * im =[[UIImage imageNamed:@"bg_menu_active"] imageByResizingToSize: CGSizeMake(screenWidth/4,49)];
//        [self.tabBar setSelectionIndicatorImage:im];
    }
    
    for(UITabBarItem *item in self.tabBar.items){
        [item setTitleTextAttributes:@{
                                       UITextAttributeTextColor:[UIColor colorWithRed:1 green:199.0/255 blue:29.0/255 alpha:1],
                                       } forState:UIControlStateHighlighted];
        [item setTitleTextAttributes:@{
                                       UITextAttributeFont:[UIFont boldSystemFontOfSize:12]
                                       } forState:UIControlStateNormal];
        
//        [item setImageInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
//        [item setTitlePositionAdjustment:UIOffsetMake(0, -2)];
        
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    UINavigationController * loanVC = nil;
    self.selectedIndex = item.tag;
    
    loanVC = [self.viewControllers objectAtIndex:self.selectedIndex];
    LoanBaseViewCtrl * rootLoanVC = [loanVC.viewControllers firstObject];
    NSLog(@"cangobarkc =%i,%i,%i",rootLoanVC->webView.canGoBack,rootLoanVC->webView.isLoading,item.tag);
    
    rootLoanVC.urlConnection = nil;
    [rootLoanVC->webView stopLoading];
    rootLoanVC.cancelTimer = nil;
    
    [rootLoanVC toLoadWebPage:YES];
    
    
//    if([SJKHEngine Instance]->bHaveLogined){
//        if(!(rootLoanVC->webView.isLoading)){
//            [rootLoanVC toLoadWebPage:YES];
//        }
//    }
//    else{
//        if(item.tag != 0){
//            [self onLoadLoginVC:rootLoanVC naviVC:loanVC];
//        }
//    }
}

- (void)onLoadLoginVC:(LoanBaseViewCtrl *)rootLoanVC naviVC:(UINavigationController *)loanVC{
    LoginViewCtrl * loginVC = [[LoginViewCtrl alloc]initWithNibName:@"LoginView" bundle:nil];
//    loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    loginVC->handleLoanBaseVC = rootLoanVC;
    [loanVC presentViewController:loginVC animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [PublicMethod setStatusBarStyle];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    //    self.tabBarItem
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)onPopMessageOperation:(UIViewController *)vc popToRoot:(BOOL)bRoot{
    if(bRoot){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        if(vc){
            [self.navigationController popToViewController:vc animated:YES];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)dealloc{
    self.viewControllers = nil;
    NSLog(@"loadMain回收");
}


@end
