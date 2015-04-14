/*
 *  BKStandbyEvent.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKStandbyEvent.h"


@implementation BKStandbyEvent


#pragma mark -


- (BKEventType)type
{
    return BKEventTypeStandby;
}


@end
