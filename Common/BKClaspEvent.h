/*
 *  BKClaspEvent.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEvent.h"


@interface BKClaspEvent : BKEvent


@property (nonatomic, readonly) NSInteger count;


+ (instancetype)claspEventWithCount:(NSInteger)aCount;


@end
