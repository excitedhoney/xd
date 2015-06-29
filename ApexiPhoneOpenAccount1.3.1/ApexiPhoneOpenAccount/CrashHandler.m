//
//  CrashHandler.m
//  CrashHandler
//
//  Created by Arshad on 10/11/11.
//  Copyright 2011 Ab'initio. All rights reserved.
//

#import "CrashHandler.h"
#import "PublicMethod.h"
#import <Parse/Parse.h>


#define UNCAUGHT_EXCEPTION @"uncaught exception"
#define WAIT_TIME 5

static BOOL _shouldEnableCrashHandler = NO;

@implementation CrashHandler

+ (void) setupLogging:(BOOL)shouldEnableCrashHandler{
	NSSetUncaughtExceptionHandler (&CrashHandlerExceptionHandler);
	_shouldEnableCrashHandler = shouldEnableCrashHandler;
}

// Method to get device info
//+ (NSMutableDictionary *) getDeviceInfo {
//	NSMutableDictionary *deviceInfo = [[NSMutableDictionary alloc] init];
//	[deviceInfo setValue:[[UIDevice currentDevice] model] forKey:MODEL];
//	[deviceInfo setValue:[[UIDevice currentDevice] name] forKey:NAME];
//	[deviceInfo setValue:[[UIDevice currentDevice] systemVersion] forKey:VERSION];
//	return deviceInfo;
//}

// Method which send crash report to Parse server
+(void) reportCrash:(NSString *) name andReason:(NSString *)reason andStackTrace:(NSString *)stackTrace {
	NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionaryWithDictionary:[PublicMethod getDeviceMessage]];
	PFObject *crash = [PFObject objectWithClassName:@"CrashReport"];
	crash[@"Name"] = name;
	crash[@"Reason"] = reason;
	crash[@"Stack_trace"] = stackTrace;
	crash[@"Model"] = [deviceInfo valueForKey:DEVICEMODEL];
	crash[@"Device"] = [deviceInfo valueForKey:DEVICENAME];
	crash[@"Os_version"] = [deviceInfo valueForKey:OSVERSION];
    
	[crash saveEventually];
}
#pragma mark #
@end

void CrashHandlerExceptionHandler(NSException *exception) {
    NSMutableArray * traceArray = [NSMutableArray array];
    
    NSArray *callStackArray = [exception callStackReturnAddresses];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
    [traceArray addObject:[dateFormatter stringFromDate:[NSDate date]]];
    [traceArray addObject:[PublicMethod getDeviceMessage]];
    [traceArray addObject:callStackArray];
    [traceArray addObject:[exception callStackSymbols]];
    [traceArray addObject:[PublicMethod backtrace]];
    NSLog(@"[exception callStackSymbols] = %@",[exception callStackSymbols]);
    
    [PublicMethod saveToUserDefaults:@"1" key:BUploadLog];
    [traceArray writeToFile:[SJKHEngine Instance]->consoleLogPath atomically:YES];
    [[SJKHEngine Instance]->logFileNames writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:LogFilesArray] atomically:YES];
    
	NSArray *arr = [exception callStackSymbols];
	NSString *report = [arr componentsJoinedByString:@"\n"];
    
	if (_shouldEnableCrashHandler) {
		[CrashHandler reportCrash:exception.name andReason:exception.reason andStackTrace:report];
	}
    
    
//	NSDate *date = [[NSDate date] dateByAddingTimeInterval:WAIT_TIME];
//	while ([date compare:[NSDate date]] == NSOrderedDescending) {
//		
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
//	}
}

BOOL parseResponseData(ASIFormDataRequest * theRequest , NSDictionary ** stepResponseDic){
    if(theRequest.responseData){
        *stepResponseDic = [NSJSONSerialization JSONObjectWithData:theRequest.responseData options:NSJSONReadingMutableContainers error:Nil];
        
        if(*stepResponseDic && [[*stepResponseDic objectForKey:SUCCESS] intValue] == 1){
            return yep;
        }
        else{
            return nop;
        }
    }
    
    return YES;
}

