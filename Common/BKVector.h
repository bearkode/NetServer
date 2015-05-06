/*
 *  BKVector.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Foundation/Foundation.h>
#endif


@interface BKVector : NSObject
{
    CGFloat mX;
    CGFloat mY;
    CGFloat mZ;
}


@property (nonatomic, readonly) CGFloat x;
@property (nonatomic, readonly) CGFloat y;
@property (nonatomic, readonly) CGFloat z;


- (instancetype)initWithX:(CGFloat)aX y:(CGFloat)aY z:(CGFloat)aZ;
- (instancetype)initWithJSONObject:(id)aJSONObject;


- (BOOL)isEqualToVector:(BKVector *)aVector;


- (NSDictionary *)JSONObject;


@end
