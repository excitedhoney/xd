//
//  CustomURLCache.h
//  LocalCache
//
//  Created by tan on 13-2-12.
//  Copyright (c) 2013年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomURLCache : NSURLCache{
    __block NSMutableDictionary *storeDic;
    NSMutableDictionary *fileDic;
    NSMutableDictionary *offlineCacheDic;
    NSString* offlineCacheName;
}

@property(nonatomic, assign) NSInteger cacheTime;
@property(nonatomic, retain) NSString *diskPath;
@property(nonatomic, retain) NSMutableDictionary *responseDictionary;
@property(retain) NSString* webViewKey;
@property(nonatomic, retain) NSMutableDictionary *hasLoadBools;

- (bool) isRequestHasLoaded;
- (void) StoreFile;
- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime;

@end
