/*
 *  BKMotionManager.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKMotionManager.h"
#import "BKLeapController.h"
#import "BKEventDetector.h"


@implementation BKMotionManager
{
    BKLeapController *mLeapController;
    BKEventDetector  *mEventDetector;
    BKHand         *mMotion;
    id                mDelegate;
}


@synthesize delegate = mDelegate;


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mLeapController = [[BKLeapController alloc] initWithDelegate:self];
        mMotion  = [[BKHand alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mLeapController release];
    [mMotion release];
    
    [super dealloc];
}


#pragma mark -


- (void)leapController:(BKLeapController *)aLeapController updateMotion:(BKHand *)aMotion
{
    [self setMotion:aMotion];
}


#pragma mark -


- (void)setMotion:(BKHand *)aMotion
{
    if (mMotion && aMotion)
    {
        if (![aMotion isEqualToHand:mMotion])
        {
            [mMotion autorelease];
            mMotion = [aMotion retain];
            
            [self didChangeMotion];
        }
    }
}


- (void)didChangeMotion
{
    if ([mDelegate respondsToSelector:@selector(motionManager:didUpdateHand:)])
    {
        [mDelegate motionManager:self didUpdateHand:mMotion];
    }
}


@end
