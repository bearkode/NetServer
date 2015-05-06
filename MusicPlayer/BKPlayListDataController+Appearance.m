/*
 *  BKPlayListDataController+Appearance.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 5. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKPlayListDataController+Appearance.h"
#import "BKPlaylist.h"


@implementation BKPlayListDataController (Appearance)


- (UITableViewCellAccessoryType)accessoryTypeForPlaylistAtIndex:(NSUInteger)aIndex
{
    return [[self playlistAtIndex:aIndex] isSelected] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}


@end
