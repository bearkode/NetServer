/*
 *  BKPlayListDataController.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 5. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKPlayListDataController.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation BKPlayListDataController
{
    NSMutableArray *mPlaylists;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        MPMusicPlayerController *sPlayer = [MPMusicPlayerController applicationMusicPlayer];
        
        [sPlayer setQueueWithQuery:[MPMediaQuery songsQuery]];
        [sPlayer play];

        mPlaylists = [[NSMutableArray alloc] init];
        
        [self updatePlaylists];
    }
    
    return self;
}


- (void)dealloc
{
    [mPlaylists release];
    
    [super dealloc];
}


- (NSInteger)numberOfPlaylist
{
    return [mPlaylists count];
}


- (NSString *)playlistTitleAtIndex:(NSUInteger)aIndex
{
    MPMediaPlaylist *sPlaylist = [mPlaylists objectAtIndex:aIndex];
    
    return [sPlaylist valueForProperty:MPMediaPlaylistPropertyName];
}


- (void)updatePlaylists
{
    MPMediaQuery *sQuery     = [MPMediaQuery playlistsQuery];
    NSArray      *sPlaylists = [sQuery collections];
    
    for (MPMediaPlaylist *sPlaylist in sPlaylists)
    {
        [mPlaylists addObject:sPlaylist];
        NSLog (@"Playlist :%@", [sPlaylist valueForProperty:MPMediaPlaylistPropertyName]);
        
        //            NSArray *songs = [playlist items];
        //            for (MPMediaItem *song in songs) {
        //                NSString *strSongTitle =
        //                [song valueForProperty: MPMediaItemPropertyTitle];
        //                NSLog (@"Title : %@", strSongTitle);
        //            }
    }
}


@end
