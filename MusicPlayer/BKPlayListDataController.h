/*
 *  BKPlayListDataController.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 5. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BKPlaylist.h"


@interface BKPlayListDataController : NSObject


- (NSInteger)numberOfPlaylist;

- (BKPlaylist *)playlistAtIndex:(NSUInteger)aIndex;
- (NSString *)playlistTitleAtIndex:(NSUInteger)aIndex;

- (void)selectPlaylistAtIndex:(NSUInteger)aIndex;
- (BOOL)isSelectedPlaylistAtIndex:(NSUInteger)aIndex;


@end
