/*
 *  BKNetService.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKNetSession.h"


@interface BKNetService : NSObject <NSNetServiceDelegate>


- (void)addSession:(BKNetSession *)aSession;


- (void)setMousePosition:(NSPoint)aPosition;
- (void)sendJSONObject:(id)aJSONObject;


@end


@interface BKNetService (Singleton)


+ (BKNetService *)sharedService;


@end
