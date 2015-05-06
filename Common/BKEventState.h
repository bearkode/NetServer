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


- (BKEvent *)detectEventFromBuffer:(BKFrameBuffer *)aFrameBuffer;


@end
