/*
 *  BKNetService+Singleton.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKNetService+Singleton.h"


static BKNetService *gNetService = nil;


@implementation BKNetService (Singleton)


#pragma mark - singleton


+ (BKNetService *)sharedService
{
    static dispatch_once_t sOnceToken;
    
    dispatch_once(&sOnceToken, ^{
        gNetService = [[BKNetService alloc] init];
    });
    
    return gNetService;
}


+ (id)allocWithZone:(NSZone *)aZone
{
    static dispatch_once_t sOnce;
    
    dispatch_once(&sOnce, ^{
        gNetService = [super allocWithZone:aZone];
    });
    
    return gNetService;
}


- (id)copyWithZone:(NSZone *)aZone
{
    return self;
}


- (id)retain
{
    return self;
}


- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}


- (oneway void)release
{
    
}


- (id)autorelease
{
    return self;
}


@end
