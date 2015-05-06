/*
 *  BKPlaylist.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 5. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKPlaylist.h"


@implementation BKPlaylist
{
    MPMediaPlaylist *mPlaylist;
    BOOL             mSelected;
}


@synthesize selected = mSelected;


- (instancetype)initWithPlaylist:(MPMediaPlaylist *)aPlaylist
{
    self = [super init];
    
    if (self)
    {
        mPlaylist = [aPlaylist retain];
    }
    
    return self;
}


- (void)dealloc
{
    [mPlaylist release];
    
    [super dealloc];
}


- (NSString *)title
{
    return [mPlaylist valueForProperty:MPMediaPlaylistPropertyName];
}


- (void)deselect
{
    mSelected = NO;
}


//        NSLog (@"Playlist :%@", [sPlaylist valueForProperty:MPMediaPlaylistPropertyName]);
//            NSArray *songs = [playlist items];
//            for (MPMediaItem *song in songs) {
//                NSString *strSongTitle =
//                [song valueForProperty: MPMediaItemPropertyTitle];
//                NSLog (@"Title : %@", strSongTitle);
//            }

@end
