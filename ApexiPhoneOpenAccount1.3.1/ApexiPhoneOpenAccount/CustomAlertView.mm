//
//  CustomAlertView.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-9.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "CustomAlertView.h"
#import "MBProgressHUD.h"
#import "PublicMethod.h"
#import "UIImage+custom_.h"

@interface CustomAlertView(){
    UILabel * titleLabel;
    UIButton * closeButton;
    UISearchBar * searchBar ;
}

@end

@implementation CustomAlertView

#define  SelfFrameWidth self.frame.size.width
#define  SelfFrameHeight self.frame.size.height

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
        [self initWidgets];
    }
    return self;
}

- (void)setTarget:(id)_target withSEL:(SEL)_select{
    target = _target;
    disMissCustomAlertViewSEL = _select;
}

- (void) initConfig{
    bCanSearch = NO;
    selfTipIndex = -1;
    filterSourceArray = nil;
    selectData = [NSMutableArray array];
}

- (void) initWidgets{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    float spaceW = 2;
    float spaceH = 40;
    
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,SelfFrameWidth, spaceH)];
//    titleLab.text = _title;
//    titleLab.backgroundColor = [UIColor darkGrayColor];
//    titleLab.textColor = [UIColor whiteColor];
//    [self addSubview:titleLab];
    
    {
        alertNavigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, SelfFrameWidth, ButtonHeight)];
        
        titleLabel = [PublicMethod initLabelWithFrame:CGRectMake(0, 0, screenWidth, 44) title:nil target:alertNavigationBar];
        [titleLabel setTextColor:[UIColor whiteColor]];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        
        closeButton = [PublicMethod CreateButton:@"关闭" withFrame:CGRectMake(SelfFrameWidth - 60, 0, 60, ButtonHeight) tag:0 target:alertNavigationBar];
        [closeButton addTarget:self action:@selector(onOKClick:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        
        [alertNavigationBar setBackgroundImage:[[UIImage imageNamed:@"SmallLoanBundle.bundle/images/bg_menu"] clipImagefromRect:CGRectMake(0, 8, screenWidth, 20)]
                                 forBarMetrics:UIBarMetricsDefault];
        [self addSubview:alertNavigationBar];
    }
    
    {
        searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, ButtonHeight, SelfFrameWidth, ButtonHeight)];
        [searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:searchBar.frame.size]];
        searchBar.translucent = NO;
        searchBar.delegate = self;
        [searchBar setHidden:YES];
        
        [self addSubview:searchBar];
    }
    
    //    screenWidth - 2 * levelSpace  screenHeight - 20 - verticalHeight * 2
    int space = 2;
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(space,ButtonHeight , SelfFrameWidth - 2* space , SelfFrameHeight - 44 - space)];
    
    //    webView = [[UIWebView alloc]initWithFrame:CGRectMake(spaceW,spaceH , SelfFrameWidth - 2* spaceW , SelfFrameHeight - 44 - spaceH)];
    webView.layer.cornerRadius = 2;
    webView.scalesPageToFit = YES;
	webView.backgroundColor = [UIColor whiteColor];
	webView.opaque = NO;
    webView.delegate = self;
    [webView setHidden:YES];
    [self addSubview:webView];
    
    selectView = [[UITableView alloc]initWithFrame:CGRectMake(0, spaceH, SelfFrameWidth, SelfFrameHeight - 44 - spaceH) style:UITableViewStylePlain];
    
    UIView * backView = [[UIView alloc]initWithFrame:selectView.frame];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [selectView setBackgroundView:backView];
    
    selectView.delegate=self;
    selectView.dataSource=self;
    [selectView setHidden:YES];
    
    [selectView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [PublicMethod hideGradientBackground:webView];
    
    [self addSubview:selectView];
}

- (void) setSelfTipIndex{
    switch (data_type) {
        case ZHIYE_DATA_TYPE:
            selfTipIndex = [SJKHEngine Instance]->currentTipZhiYeIndex;
            break;
            
        case XUELI_DATA_TYPE:
            selfTipIndex = [SJKHEngine Instance]->currentTipXueLiIndex ;
            break;
    }
    
    if(selfTipIndex != -1){
        [selectData replaceObjectAtIndex:selfTipIndex withObject:[NSNumber numberWithInt:1]];
    }
}

- (void) setShowSearchAndRelayoutSubviews:(NSString *)sSearchBarPlaceHolder{
    bCanSearch = YES;
    [searchBar setHidden:NO];
    [searchBar setPlaceholder:sSearchBarPlaceHolder];
    
    selectView.frame = CGRectMake(0,
                                  selectView.frame.origin.y + ButtonHeight,
                                  SelfFrameWidth,
                                  selectView.frame.size.height - ButtonHeight);
}

- (void) setOKHidden:(BOOL)hidden{
    if(hidden){
        [okButton setHidden:YES];
        CGRect rect = selectView.frame;
        [selectView setFrame:CGRectMake(rect.origin.x,
                                     rect.origin.y,
                                     rect.size.width,
                                     rect.size.height + 44)];
    }
    else{
        [okButton setHidden:NO];
    }
}

- (void) setTitle:(NSString *)title{
    if (_title) {
        _title = nil;
    }
    _title = title;
}

- (void) toSetTitleLabel:(NSString *)title{
    float width = [PublicMethod getStringWidth:title font:[UIFont boldSystemFontOfSize:18]];
    titleLabel.frame = CGRectMake(SelfFrameWidth/2 - width/2, 0, width, ButtonHeight);
    [titleLabel setText:title];
    if (title.length >= 10) {
        titleLabel.frame = CGRectMake(5, 0, width, ButtonHeight);
    }

//    okButton = [[UIButton alloc]initWithFrame:CGRectMake(SelfFrameWidth*3/4, 0, SelfFrameWidth/4, spaceH)];
//    [okButton setBackgroundImage:[UIImage imageWithColor:LightGrayTipColor size:okButton.frame.size] forState:UIControlStateNormal];
//    [okButton setBackgroundImage:[UIImage imageWithColor:GrayTipColor_Wu size:okButton.frame.size] forState:UIControlStateHighlighted];
//    [okButton addTarget: self action: @selector(onOKClick:) forControlEvents: UIControlEventTouchUpInside];
//    [okButton setTitle:@"关闭" forState:UIControlStateNormal];
//    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    okButton.layer.cornerRadius = 1;
//    okButton.layer.masksToBounds = YES;
//    [self addSubview:okButton];
}

- (void) updateUIThread:(BOOL)isOK{
    NSError *error = nil;
    
    NSString * htmlString = [NSString stringWithContentsOfFile:
                             [PublicMethod getFilePath:DOCUMENT_CACHE fileName:htmlKey]
                                                      encoding:[SJKHEngine Instance]->stringEncode
                                                         error:&error];
    if(isOK){
        htmlString = [NSString stringWithFormat:@"<!DOCTYPE html> \n"
                      "<html>"
                      "<head><meta http-equiv=Content-Type content=textml;charset=UTF-8 /> \n"
                      "<meta name=viewport content=width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no/> \n"
                      "<meta http-equiv=Cache-Control content=no-cache/>"
                      "</head>"
                      "<body>%@</body> \n"
                      "</html>",htmlString];
        [webView loadHTMLString:htmlString baseURL:nil];
        [alertHUD hide:YES];
        alertHUD = nil;
    }
    else{
        alertHUD.labelText = @"加载失败";
        alertHUD.mode = MBProgressHUDModeText;
    }
}

- (NSString *)addDiv:(NSString *)str{
//    <div style="font-size:16px;"></div>
    NSMutableString *str1 = [NSMutableString stringWithFormat:str];
    [str1 insertString:@"<div style='font-size:16px';>" atIndex:0];
    [str1 appendString:@"</div>"];
    return [NSString stringWithFormat:str1];
}

- (void)dismissHUD{
    [alertHUD setHidden:YES];
    [self sendSubviewToBack:alertHUD];
    [alertHUD removeFromSuperview];
    alertHUD = nil;
}

- (void) createMBProgress{
    alertHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    alertHUD.animationType = MBProgressHUDAnimationZoomOut;
    [alertHUD setHidden:YES];
    [alertHUD setOpaque:YES];
}

- (void) onOKClick:(UIButton *)button{
    if([target respondsToSelector:disMissCustomAlertViewSEL]){
        NSString * param = nil;
        if(selfTipIndex != -1){
//            NSIndexPath *indexPATH = [NSIndexPath indexPathForRow:selfTipIndex inSection:0];
//            param = [selectView cellForRowAtIndexPath:indexPATH].textLabel.text;
            NSDictionary * itemDic = [filterArray objectAtIndex:selfTipIndex];
            param = [NSString stringWithFormat:@"%@&%@",[itemDic objectForKey:UPNOTE],[itemDic objectForKey:IBM]];
            [target performSelector:disMissCustomAlertViewSEL withObject:NO withObject:param];
        }
        else{
            [target performSelector:disMissCustomAlertViewSEL withObject:NO withObject:nil];
        }
    }
}

#pragma tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"filterArray  =%@",filterArray );
    return filterArray ? filterArray.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"tableViewCellIdentify";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
        cell.backgroundColor = [UIColor whiteColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tableViewCell" owner:self options:nil] objectAtIndex: 0];
        [tableView registerNib:[UINib nibWithNibName:@"tableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
	}
    
    UIView *seperateLine = [cell.contentView viewWithTag:SeperateLineTag];
    if(seperateLine){
        [seperateLine removeFromSuperview];
    }
    
    [cell.textLabel setText:Nil];
    NSDictionary * itemDic = [filterArray objectAtIndex:indexPath.row];
    
    if(itemDic){
        [cell.textLabel setText:[itemDic objectForKey:UPNOTE]];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:[PublicMethod getSepratorLine:CGRectMake(0, 50-1, cell.frame.size.width, 1) alpha:0.5]];
    
    if([[selectData objectAtIndex:indexPath.row] intValue] == 1){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *ce=[tableView cellForRowAtIndexPath:indexPath];
    [ce setSelected:NO];
    
    int index=indexPath.row;
//    int section = indexPath.section;
    
    if([selectData objectAtIndex:index] == [NSNumber numberWithInt:0]){
        ce.accessoryType=UITableViewCellAccessoryCheckmark;
        
        for (int i=0;i< selectData.count; i++) {
            NSNumber * sign = ([selectData objectAtIndex:i]);
            if([sign intValue] == 1){
//                NSIndexPath *indexPATH=[NSIndexPath indexPathForItem:i inSection:section];
//                [tableView cellForRowAtIndexPath:indexPATH].accessoryType=UITableViewCellAccessoryNone;
                [selectData replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
            }
        }
        
        switch (data_type) {
            case ZHIYE_DATA_TYPE:
                [SJKHEngine Instance]->currentTipZhiYeIndex = index;
                break;
                
            case XUELI_DATA_TYPE:
                [SJKHEngine Instance]->currentTipXueLiIndex = index;
                break;
        }
        
        selfTipIndex = index;
        
        [selectData replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
    }
    else{
        [selectData replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
        ce.accessoryType=UITableViewCellAccessoryNone;
    }
    
    [selectView reloadData];
    
    [self onOKClick:nil];
}

#pragma webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"];
    
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize=%f",80.0];
//    [webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//	filterArray = [[SJKHEngine Instance]getFilterData:filterArray originString:searchText];
//    [selectView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) _searchBar
{
// 	[self endSearchMode];
//    [searchBar setShowsCancelButton: YES animated: YES];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
//    [searchBar setShowsCancelButton: YES animated: YES];
//    if([SJKHEngine Instance]->systemVersion >= 7){
//        [self ChangeCancelButton:[[searchBar subviews] objectAtIndex:0]];
//    }
//    else {
//        [self ChangeCancelButton:searchBar];
//    }
}

- (void) ChangeCancelButton:(UIView *)view{
    for(id subView in [view subviews])
    {
        if([subView isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton *)subView;
            [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];
            [cancelButton setTitleShadowColor:nil forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if([SJKHEngine Instance]->systemVersion < 7){
                [cancelButton setTintColor:PAGE_BG_COLOR];
            }
            break ;
        }
    }
}

- (void)endSearchMode{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
//    filterArray = initSourceArray;
}

- (void)dealloc{
    NSLog(@"提醒框回收");
    
    target = nil;
    [selectView removeFromSuperview];
    selectView = nil;
    [filterResultView removeFromSuperview];
    filterResultView = nil;
    [webView removeFromSuperview];
    webView = nil;
    [okButton removeFromSuperview];
    okButton = nil;
    [alertNavigationBar removeFromSuperview];
    alertNavigationBar = nil;
    [filterArray removeAllObjects];
    filterArray = nil;
    [filterSourceArray removeAllObjects];
    filterSourceArray = nil;
    [selectData removeAllObjects];
    selectData = nil;
    [alertHUD removeFromSuperview];
    alertHUD = nil;
    htmlKey = nil;
}

@end















