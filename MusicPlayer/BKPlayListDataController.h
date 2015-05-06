/*
 *  BKPlayListDataController.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 5. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface BKPlayListDataController : NSObject


- (NSInteger)numberOfPlaylist;
- (NSString *)playlistTitleAtIndex:(NSUInteger)aIndex;


@end
