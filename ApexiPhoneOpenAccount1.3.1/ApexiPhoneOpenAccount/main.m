//
//  main.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-3-2.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicMethod.h"
#import "SJKHAppDelegate.h"
#import "Data_Structure.h"
#import "SimplePing.h"
#import "IPPingManager.h"

//#include <stdio.h>
//#include <string.h>
//#include <stdint.h>

void stacktrace(int sig, siginfo_t *info, void *context)
{
    [PublicMethod saveToUserDefaults:@"1" key:BUploadLog];
    NSMutableArray * traceArray = [NSMutableArray array];
//    [PublicMethod redirectConsoleLogToDocumentFolder];
//    NSLog(@"stacktrace =%i",sig);
    [traceArray addObject:[NSString stringWithFormat:@"%i", sig]];
    
    @try {
        [[NSException exceptionWithName:@"Stack Trace" reason:[NSString stringWithFormat:@"signal %d", sig] userInfo:nil] raise];
    }
    @catch (NSException *e) {
        NSArray *callStackArray = [e callStackReturnAddresses];
        int frameCount = [callStackArray count];
        void *backtraceFrames[frameCount];
        
        for (int i=0; i<frameCount; i++) {
            backtraceFrames[i] = (void *)[[callStackArray objectAtIndex:i] unsignedIntegerValue];
        }
        
//        NSLog(@"deviceMassage =%@",[PublicMethod getDeviceMessage]);
//        NSLog(@"callStackArray =%@",callStackArray);
//        NSLog(@"callStackSymbols = %@", [e callStackSymbols]);
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
        [traceArray addObject:[dateFormatter stringFromDate:[NSDate date]]];
        [traceArray addObject:[PublicMethod getDeviceMessage]];
        [traceArray addObject:callStackArray];
        [traceArray addObject:[e callStackSymbols]];
        [traceArray addObject:[PublicMethod backtrace]];
    }
    
    [traceArray writeToFile:[SJKHEngine Instance]->consoleLogPath atomically:YES];
    [[SJKHEngine Instance]->logFileNames writeToFile:[PublicMethod getFilePath:DOCUMENT_CACHE fileName:LogFilesArray] atomically:YES];
    
    exit(0);
}

int main(int argc, char * argv[])
{
    @autoreleasepool {
        struct sigaction mySigAction;
        mySigAction.sa_sigaction = stacktrace;
        mySigAction.sa_flags = SA_SIGINFO;
        
        sigemptyset(&mySigAction.sa_mask);
        sigaction(SIGQUIT, &mySigAction, NULL);
        sigaction(SIGILL , &mySigAction, NULL);
        sigaction(SIGTRAP, &mySigAction, NULL);
        sigaction(SIGABRT, &mySigAction, NULL);
        sigaction(SIGEMT , &mySigAction, NULL);
        sigaction(SIGFPE , &mySigAction, NULL);
        sigaction(SIGBUS , &mySigAction, NULL);
        sigaction(SIGSEGV, &mySigAction, NULL);
        sigaction(SIGSYS , &mySigAction, NULL);
        sigaction(SIGPIPE, &mySigAction, NULL);
        sigaction(SIGALRM, &mySigAction, NULL);
        sigaction(SIGXCPU, &mySigAction, NULL);
        sigaction(SIGXFSZ, &mySigAction, NULL);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([SJKHAppDelegate class]));
    }
}
