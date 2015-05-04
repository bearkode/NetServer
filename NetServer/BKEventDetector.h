/*
 *  BKEventDetector.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKFrame.h"
#import "BKEvent.h"


@interface BKEventDetector : NSObject


@property (nonatomic, assign) id delegate;


- (BOOL)addFrame:(BKFrame *)aFrame;


@end


@protocol BKEventDetectorDelegate <NSObject>


- (void)eventDetector:(BKEventDetector *)aDetector didDetectEvent:(BKEvent *)aEvent;


@end