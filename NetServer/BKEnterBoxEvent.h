/*
 *  BKEnterboxEvent.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEvent.h"


@interface BKEnterBoxEvent : BKEvent


+ (instancetype)enterBoxEventWithEntrancePosition:(BKPositionType)aPosition;


@end
