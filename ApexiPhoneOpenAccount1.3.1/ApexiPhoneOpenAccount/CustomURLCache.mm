//
//  CustomURLCache.m
//  LocalCache
//
//  Created by tan on 13-2-12.
//  Copyright (c) 2013年 adways. All rights reserved.
//

#import "CustomURLCache.h"
#import "Data_Structure.h"
#import "PublicMethod.h"
//#import "../../NetWork/NetWork/NetReachability.h"
//#import "../../aximApi_IOS_XMPP_12_19/axim/webconnect/Reachability.h"
#import "Reachability.h"

@interface CustomURLCache(){
    
}
- (NSString *)cacheFolder;
- (NSString *)cacheFilePath:(NSString *)file;
- (NSString *)cacheRequestFileName:(NSString *)requestUrl;
- (NSString *)cacheRequestOtherInfoFileName:(NSString *)requestUrl;
- (NSCachedURLResponse *)dataFromRequest:(NSURLRequest *)request;
- (void)deleteCacheFolder;

@end

@implementation CustomURLCache

@synthesize cacheTime = _cacheTime;
@synthesize diskPath = _diskPath;
@synthesize responseDictionary = _responseDictionary;
@synthesize webViewKey=_webViewKey;
@synthesize hasLoadBools=_hasLoadBools;

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime {
    if (self = [self initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) {
        self.cacheTime = cacheTime;
        self.webViewKey = path;
        
        self.diskPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        self.responseDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        storeDic = [[NSMutableDictionary alloc]init];
        offlineCacheDic = [[NSMutableDictionary alloc]init];
        NSLog(@"storeDic allkeys =%@,%@",[storeDic allKeys],_webViewKey);
    }
    return self;
}

- (void)dealloc {
    
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    if ([request.HTTPMethod compare:@"GET"] != NSOrderedSame) {
        return [super cachedResponseForRequest:request];
    }
    NSLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
    
    if([request.URL.absoluteString rangeOfString:@".js"].length!=0 ||
        [request.URL.absoluteString rangeOfString:@".css"].length!=0)
    {
        return [self dataFromRequest:request];
    }
    
    return [super cachedResponseForRequest:request];
}
//====================================================================================//
- (void)removeAllCachedResponses {
    [super removeAllCachedResponses];
    
    [self deleteCacheFolder];
}
//====================================================================================//
- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    [super removeCachedResponseForRequest:request];
}
//====================================================================================//
#pragma mark - custom url cache
- (NSString *)cacheFolder {
    return @"URLCACHE";
}

- (void)deleteCacheFolder {
    
}

- (NSString *)cacheFilePath:(NSString *)file {
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.diskPath, [self cacheFolder]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        
    }
    else {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [NSString stringWithFormat:@"%@/%@", path, file];
}

- (NSString *)cacheRequestFileName:(NSString *)requestUrl {
    return [PublicMethod md5Hash:requestUrl];
}

- (NSString *)cacheRequestOtherInfoFileName:(NSString *)requestUrl {
    return [PublicMethod md5Hash:[NSString stringWithFormat:@"%@-otherInfo", requestUrl]];
}

- (NSCachedURLResponse *)OfflineCacheFromRequest:(NSURLRequest *)request CurrentNetStatus:(NetworkStatus)status{
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString* filePath = [self cacheFilePath:fileName];
    NSString* otherInfoPath = [self cacheFilePath:otherInfoFileName];
    NSDate *date = [NSDate date];
    
    if (status == NotReachable) {
        NSDictionary *otherInfo = [offlineCacheDic objectForKey:otherInfoPath];
        BOOL expire = false;
        if (self.cacheTime > 0) {
            NSInteger createTime = [[otherInfo objectForKey:@"time"] intValue];
            NSLog(@"createTime , self.cacheTime ,since70 =%i,%i,%f", createTime,
            self.cacheTime,
            [date timeIntervalSince1970]);
            
            if (createTime + self.cacheTime < [date timeIntervalSince1970]) {
                expire = true;
            }
        }
        
        
        if (expire == false) {
            NSLog(@"data from cache offline");
            
            NSData *data = [offlineCacheDic objectForKey:filePath];
            //            NSData* data = [NSData dataWithContentsOfFile:filePath];
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                                MIMEType:[otherInfo objectForKey:@"MIMEType"]
                                                   expectedContentLength:data.length
                                                        textEncodingName:[otherInfo objectForKey:@"textEncodingName"]];
            NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            return cachedResponse;
        }
    }
    
    __block NSCachedURLResponse *cachedResponse = nil;
    id boolExsite = [self.responseDictionary objectForKey:url];
    if (boolExsite == nil) {
        [self.responseDictionary setValue:[NSNumber numberWithBool:TRUE] forKey:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *da,NSError *error)
         {
             [self.responseDictionary removeObjectForKey:url];
             
             if (error) {
                 NSLog(@"error : %@", error);
                 NSLog(@"not cached: %@", request.URL.absoluteString);
                 cachedResponse = nil;
             }
             
             NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]], @"time",
                                   response.MIMEType, @"MIMEType",
                                   response.textEncodingName, @"textEncodingName", nil];
             [offlineCacheDic setValue:dict forKey:otherInfoPath];
             [offlineCacheDic setValue:da forKey:filePath];
             
             cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:da];
         }];
        return cachedResponse;
    }
    return nil;
}

- (NSCachedURLResponse *)dataFromRequest:(NSURLRequest *)request {
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString* filePath = [self cacheFilePath:fileName];
//    b81540e589ce1477bd8730a04d4b946d
    NSString* otherInfoPath = [self cacheFilePath:otherInfoFileName];
    NSDate *date = [NSDate date];
    
    if ([storeDic objectForKey:filePath]) {
        BOOL expire = false;
        NSDictionary *otherInfo = [storeDic objectForKey:otherInfoPath];
        
        if (self.cacheTime > 0) {
            NSInteger createTime = [[otherInfo objectForKey:@"time"] intValue];
            if (createTime + self.cacheTime < [date timeIntervalSince1970]) {
                expire = true;
            }
        }
        
        if (expire == false) {
            NSData *data = [storeDic objectForKey:filePath];
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                                MIMEType:[otherInfo objectForKey:@"MIMEType"]
                                                   expectedContentLength:data.length
                                                        textEncodingName:[otherInfo objectForKey:@"textEncodingName"]];
            NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            return cachedResponse;
        }
    }
    
    __block NSCachedURLResponse *cachedResponse = nil;
    id boolExsite = [self.responseDictionary objectForKey:url];
    if (boolExsite == nil) {
        [self.responseDictionary setValue:[NSNumber numberWithBool:TRUE] forKey:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *da,NSError *error)
        {
            [self.responseDictionary removeObjectForKey:url];
            
            if (error) {
                cachedResponse = nil;
            }
            
            if([request.URL.absoluteString rangeOfString:@".js"].length!=0){
                
            }
            if([request.URL.absoluteString rangeOfString:@".css"].length!=0){
                
            }
            
            NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]], @"time",
                                  response.MIMEType, @"MIMEType",
                                  response.textEncodingName, @"textEncodingName", nil];
            
            [storeDic setValue:dict forKey:otherInfoPath];
            [storeDic setValue:da forKey:filePath];
            
            NSLog(@"response js =%@",[[NSString alloc]initWithData:da encoding:NSUTF8StringEncoding]);
            
            cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:da];
        }];
        
        return cachedResponse;
        
    }
    return nil;
}

- (void) StoreFile {
    
}

- (bool) isRequestHasLoaded{
    bool hasLoaded=true;
    
    if(_hasLoadBools.count > 0){
        NSEnumerator* keyEnumerator = [_hasLoadBools keyEnumerator];
        id key;
        while ((key = [keyEnumerator nextObject]) != nil)
        {
            if([[_hasLoadBools objectForKey:key] isEqualToString:@"0"]){
                hasLoaded=false;
            }
        }
        return hasLoaded;
    }
    
    return false;
}

@end
