/*
 *  BKSwipeEvent.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEvent.h"


@interface BKSwipeEvent : BKEvent


+ (instancetype)swipeEventWithPosition:(BKPositionType)aPosition;


- (BOOL)isNext;
- (BOOL)isPrev;


@end
