/*
 *  BKMotionManager.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKHand.h"


@interface BKMotionManager : NSObject


@property (nonatomic, assign) id delegate;


@end


@protocol BKMotionManagerDelegate <NSObject>

- (void)motionManager:(BKMotionManager *)aMotionManager didUpdateHand:(BKHand *)aHand;

@end
