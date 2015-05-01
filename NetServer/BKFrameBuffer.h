/*
 *  BKFrameBuffer.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 28..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKFrame.h"
#import "BKTypes.h"


@interface BKFrameBuffer : NSObject


- (BOOL)addFrame:(BKFrame *)aFrame;
- (void)clear;


- (BKFrame *)lastFrame;
- (BKPositionType)lastPosition;
- (BKPositionType)prevPosition;
- (BOOL)isLastFrameEnabled;


- (void)enumerateFramesUsingBlock:(void (^)(BKFrame *aFrame, BOOL *aStop))aBlock timeout:(NSTimeInterval)aTimeInterval;


@end
