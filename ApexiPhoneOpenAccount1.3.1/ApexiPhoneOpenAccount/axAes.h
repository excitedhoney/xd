//
//  axAes.h
//  axAes
//
//  Created by jeffguo on 14-6-12.
//  Copyright (c) 2014年 apexsoft. All rights reserved.
//

#include <string>
using namespace std;

@interface AxAES : NSObject

+ (NSString *)Encode:(NSString *)plainText;
+ (NSString *)Decode:(NSString *)chiperText;

@end




