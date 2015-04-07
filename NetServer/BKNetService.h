/*
 *  BKNetService.h
 *  NetServer
 *
 *  Created by cgkim on 2015. 4. 6..
 *  Copyright (c) 2015 cgkim. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKNetSession.h"


@interface BKNetService : NSObject <NSNetServiceDelegate>


- (void)addSession:(BKNetSession *)aSession;


@end


@interface BKNetService (Singleton)


+ (BKNetService *)sharedService;


@end
