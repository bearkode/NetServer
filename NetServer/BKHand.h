/*
 *  BKHand.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKVector.h"


@interface BKHand : NSObject
{
    NSTimeInterval mTimeInterval;
    BOOL           mEnabled;
    NSInteger      mExtendedFingerCount;
    BKVector      *mPalmPosition;
    BKVector      *mPalmNormal;
}


@property (nonatomic, readonly)                   NSTimeInterval timeInterval;
@property (nonatomic, readonly, getter=isEnabled) BOOL           enabled;
@property (nonatomic, readonly)                   NSInteger      extenedFingerCount;
@property (nonatomic, readonly)                   BKVector      *palmPosition;
@property (nonatomic, readonly)                   BKVector      *palmNormal;


- (BOOL)isEqualToHand:(BKHand *)aHand;

- (NSDictionary *)JSONObject;


@end
