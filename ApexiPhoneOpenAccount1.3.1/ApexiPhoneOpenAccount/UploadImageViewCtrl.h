//
//  UploadImageViewCtrl.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-7.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "BaseViewController.h"
#import "../../ImageClipTool/ImageClipTool/PECropViewController.h"
#import "TTTAttributedLabel.h"


@interface UploadImageViewCtrl : BaseViewController<PECropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate, TTTAttributedLabelDelegate>
{
    
}


@end
