/*
 *  BKFrameBuffer+Detector.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 29..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKFrameBuffer.h"
#import "BKEvent.h"


@interface BKFrameBuffer (Detector)


- (BKEvent *)detectEvents:(NSArray *)aEvents;


- (BKEvent *)detectOnlineEvent;
- (BKEvent *)detectOfflineEvent;
- (BKEvent *)detectEnterBoxEvent;
- (BKEvent *)detectLeaveBoxEvent;
- (BKEvent *)detectStandbyEvent;
- (BKEvent *)detectFingerCountEvent;
- (BKEvent *)detectClaspEvent;


@end
