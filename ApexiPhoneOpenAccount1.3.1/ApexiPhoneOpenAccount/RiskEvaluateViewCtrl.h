//
//  RiskEvaluateViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-13.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"

#define TipLabelTag 444
#define HEADERBUTTONTAG 344

@interface RiskEvaluateViewCtrl : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * tipMark;
    UITableView * table_view;
    NSMutableArray * tmRecords;
    NSMutableArray * bzRecords;
    NSMutableArray * cellTexts;
    UIView * resultView;
    UIImageView * rootImageView;
    NSString * tmdacNSString;
    int tableHeight;
    NSMutableArray * cellConditioins;           //每个cell的点击状态
    UIView * headerView;
    UILabel * tip;
    int textWidth;
}

- (int) pointForCell:(int)section row:(int)row tmdac:(NSString **)subTmdac;

- (void) hiddenMainView;

- (int)getSmallestScoreIndex:(NSString *)sScore;

@end
