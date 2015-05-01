/*
 *  BKEvent.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKTypes.h"


@interface BKEvent : NSObject


+ (NSString *)className;
- (BKEventType)type;


@end
