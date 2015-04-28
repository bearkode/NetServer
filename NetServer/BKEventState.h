/*
 *  BKEventState.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 28..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKEvent.h"
#import "BKFrameBuffer.h"


@interface BKEventState : NSObject


- (void)setFrameBuffer:(BKFrameBuffer *)aFrameBuffer;

- (BKEvent *)detectEvent;


- (BOOL)detectOnline;
- (BOOL)detectOffline;
- (BOOL)detectEnterBox;
- (BOOL)detectLeaveBox;
- (BOOL)detectStandby;
- (NSInteger)detectFingerCount;
- (BOOL)detectClasp;


@end
