/*
 *  BKEventDetector.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEventDetector.h"


@implementation BKEventDetector
{
    NSMutableArray *mHands;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mHands = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mHands release];
    
    [super dealloc];
}


- (BOOL)addHand:(BKHand *)aHand
{
    if (!aHand)
    {
        return NO;
    }
    
    BKHand *sLastHand = [mHands lastObject];
    
    if (![aHand isEqualToHand:sLastHand])
    {
        [mHands addObject:aHand];
        
        if ([mHands count] > 100)
        {
            [mHands removeObjectAtIndex:0];
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
