/*
 *  BKVector.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface BKVector : NSObject


@property (nonatomic, readonly) CGFloat x;
@property (nonatomic, readonly) CGFloat y;
@property (nonatomic, readonly) CGFloat z;


- (instancetype)initWithX:(CGFloat)aX y:(CGFloat)aY z:(CGFloat)aZ;


- (BOOL)isEqualToVector:(BKVector *)aVector;


- (NSDictionary *)JSONObject;


@end
