//
//  LogProperties.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-6-16.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "LogProperties.h"
//#include <runtime.h>
#include <objc/runtime.h>

@implementation LogProperties

- (void) logProperties {
    @autoreleasepool {
        unsigned int numberOfProperties = 0;
        objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
        for (NSUInteger i = 0; i < numberOfProperties; i++) {
            objc_property_t property = propertyArray[i];
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            NSLog(@"Property %@ Value: %@", name, [self valueForKey:name]);
        }
        free(propertyArray);
    }
    NSLog(@"-----------------------------------------------");
}

@end
