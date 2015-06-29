//
//  UITextField+Tools.h
//  ApexiPhoneOpenAccount
//
//  Created by haoliuyang on 14-5-23.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface UIScrollView (Tools)
//
//- (void)dealloc;
//
//@end

@interface UITextField (Tools)

- (void)positSpace:(YEorNO)isCreate;

@end

@interface UILabel (Tools)

- (void)presentCertTitleClickToTarget:(id)target andSEL:(SEL)selector WithSepString:(NSString *)sepStr;

@end

@interface UIImagePickerController(Tools)

@end

@interface UIView (Tools)


@end

@interface UIButton (Tools)


@end

@interface NSString (Tools)

- (YEorNO)isMailAddress;

@end
