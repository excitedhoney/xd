//
//  UINavigationBar+Frame.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-19.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "UINavigationBar+Frame.h"
#import "Data_Structure.h"
#import "SJKHEngine.h"

@implementation UINavigationBar (customNav)
- (CGSize)sizeThatFits:(CGSize)size {
//    if([SJKHEngine Instance]->initNavigationBar){
//        [SJKHEngine Instance]->initNavigationBar = NO;
//        return CGSizeMake(screenWidth,UpHeightInset);;
//    }
    if([self viewWithTag:FigureButtonTag + 1] != nil){
        CGSize newSize = CGSizeMake(screenWidth,UpHeightInset);
//        NSLog(@"size fits=%@",NSStringFromCGSize(size));
        return newSize;
    }
    else{
        return CGSizeMake(screenWidth,44);
    }
}

@end