/*
 *  BKNetSession.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface BKNetSession : NSObject <NSStreamDelegate>


@property (nonatomic, assign) id delegate;


- (instancetype)initWithInputStream:(NSInputStream *)aInStream outputStream:(NSOutputStream *)aOutStream;


- (void)sendJSONObject:(id)aJSONObject;


@end


@protocol BKNetSessionDelegate <NSObject>


- (void)netSessionDidClose:(BKNetSession *)aNetSession;


@end
