/*
 *  BKNetSession.h
 *  NetServer
 *
 *  Created by cgkim on 2015. 4. 6..
 *  Copyright (c) 2015 cgkim. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface BKNetSession : NSObject <NSStreamDelegate>


- (instancetype)initWithInputStream:(NSInputStream *)aInStream outputStream:(NSOutputStream *)aOutStream;


@end
