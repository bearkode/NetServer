/*
 *  BKPrepareBox.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKTypes.h"
#import "BKVector.h"


@interface BKPrepareBox : NSObject


+ (BOOL)containsPosition:(BKVector *)aPosition;
+ (BKPositionType)typeForPosition:(BKVector *)aPosition;


@end
