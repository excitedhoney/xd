//
//  PostWebForm.h
//  CoWork
//
//  Created by mac  on 13-8-15.
//  Copyright (c) 2013年 ApexSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PostWebForm;


@protocol PPPostWebFormDelegate

-(void)postWebForm:(PostWebForm*)form  didReceivedAsynchronousData:(NSData*)data;

@end



@interface PostWebForm : NSObject {
	NSMutableData *_data;
	NSMutableURLRequest *_request;
	NSMutableData *_responseData;
    id target;
//	id<PPPostWebFormDelegate>delegate;
}


-(id)initWithPostURL:(NSURL *)postURL target:(id)_target;
-(void)addTextElement:(NSString*)name value:(NSString*)value;
- (void)addFileElement:(NSString*)name value:(NSData*)data;
-(NSData*)commitFormSynchronous;
-(void)commitFormAsynchronous;
-(void)addReturn;


//@property(nonatomic,retain) id<PPPostWebFormDelegate> delegate;
@property(nonatomic,retain) NSMutableURLRequest *request;
@property(nonatomic,retain) NSData *responseData;




@end











