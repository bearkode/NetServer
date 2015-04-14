/*
 *  BKLeapController.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKHand.h"


@interface BKLeapController : NSObject


- (instancetype)initWithDelegate:(id)aDelegate;


@end


@protocol BKLeapControllerDelegate <NSObject>


- (void)leapController:(BKLeapController *)aLeapController updateHand:(BKHand *)aHand;


@end
