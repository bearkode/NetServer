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
{
    double mX;
    double mY;
    double mZ;
}


@property (nonatomic, readonly) double x;
@property (nonatomic, readonly) double y;
@property (nonatomic, readonly) double z;


- (instancetype)initWithX:(double)aX y:(double)aY z:(double)aZ;
- (instancetype)initWithJSONObject:(id)aJSONObject;


- (BOOL)isEqualToVector:(BKVector *)aVector;


- (NSDictionary *)JSONObject;


@end
