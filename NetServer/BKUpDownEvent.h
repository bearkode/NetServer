/*
 *  BKUpDownEvent.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEvent.h"


@interface BKUpDownEvent : BKEvent


+ (instancetype)upDownEventWithPosition:(BKPositionType)aPosition;


- (BOOL)isUp;
- (BOOL)isDown;


@end
