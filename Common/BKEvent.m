/*
 *  BKEvent.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEvent.h"


@implementation BKEvent


+ (NSString *)className
{
    return NSStringFromClass(self);
}


- (BKEventType)type
{
    return BKEventTypeUnknown;
}


@end
