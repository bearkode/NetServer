/*
 *  BKEventManager.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKHand.h"


@interface BKEventManager : NSObject


@property (nonatomic, assign)                             id   delegate;
@property (nonatomic, assign, getter=isNetServiceEnabled) BOOL netServiceEnabled;


@end


@protocol BKEventManagerDelegate <NSObject>


- (void)eventManager:(BKEventManager *)aEventManager didUpdateHand:(BKHand *)aHand;


@end
