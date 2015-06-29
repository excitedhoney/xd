//
//  PostWebForm.m
//  CoWork
//
//  Created by mac  on 13-8-15.
//  Copyright (c) 2013年 ApexSoft. All rights reserved.
//

#import "PostWebForm.h"


#define SEPARATE_STRING @"VTeR1d3szCy8rzJIKows3LFOu5HSuKUcnJ"

@implementation PostWebForm

@synthesize request = _request,responseData = _responseData ;

-(id)initWithPostURL:(NSURL *)postURL target:(id)_target{
    self=[super init];
    if(self){
        self.request=[NSMutableURLRequest requestWithURL:postURL];
        _responseData=[[NSMutableData alloc]init];
        _data=[[NSMutableData alloc]init];
        [_data appendData:[[NSString stringWithFormat:@"--%@\r\n",SEPARATE_STRING] dataUsingEncoding:NSUTF8StringEncoding]];
        target = _target;
    }
    return self;
}

-(void)addFileElement:(NSString *)name value:(NSData *)data{
    NSString *tmp=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",name,[name stringByAppendingString:@".jpg"]];
        [_data appendData:[tmp dataUsingEncoding:NSASCIIStringEncoding]];
    [_data appendData:data];
    [_data appendData:[@"\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
    [_data appendData:[[NSString stringWithFormat:@"--%@",SEPARATE_STRING] dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)addTextElement:(NSString *)name value:(NSString *)value{
    NSString *tmp = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\nContent-Type: text/plain;charset=US-ASCII\r\nContent-Transfer-Encoding: 8bit\r\n\r\n%@\r\n",name,value];
    
    [_data appendData:[tmp dataUsingEncoding:NSASCIIStringEncoding]];
    [_data appendData:[[NSString stringWithFormat:@"--%@",SEPARATE_STRING] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)addReturn{
    [_data appendData:[@"\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)commitFormAsynchronous{
    [_data appendData:[@"--\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
	[_request setHTTPMethod:@"POST"];
    [_request setValue:[NSString stringWithFormat:@"%d", [_data length]] forHTTPHeaderField:@"Content-Length"];
	[_request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",SEPARATE_STRING] forHTTPHeaderField:@"Content-Type"];
    NSString *hostStr=[NSString stringWithFormat:@"%@",_request.URL];
    NSString *finalHost=[hostStr substringWithRange:NSMakeRange(7,hostStr.length-8)];
	[_request setValue:finalHost forHTTPHeaderField:@"Host"];
    [_request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [_request setValue:@"Apache-HttpClient/UNAVAILABLE (java 1.4)" forHTTPHeaderField:@"User-Agent"];
    
    [_request setHTTPBody:_data];
    
    [NSURLConnection connectionWithRequest:_request delegate:target];
}


- (void)dealloc{
    _responseData = nil;
    target = nil;
    _request = nil;
    _data = nil;
}

@end


