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
#import "BKPlaylist.h"


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


- (BKPlaylist *)playlistAtIndex:(NSUInteger)aIndex
{
    return [mPlaylists objectAtIndex:aIndex];
}


- (NSString *)playlistTitleAtIndex:(NSUInteger)aIndex
{
    return [[mPlaylists objectAtIndex:aIndex] title];
}


- (void)selectPlaylistAtIndex:(NSUInteger)aIndex
{
    [mPlaylists makeObjectsPerformSelector:@selector(deselect)];
    [[mPlaylists objectAtIndex:aIndex] setSelected:YES];
}


- (BOOL)isSelectedPlaylistAtIndex:(NSUInteger)aIndex
{
    return [[mPlaylists objectAtIndex:aIndex] isSelected];
}


#pragma mark -


- (void)updatePlaylists
{
    NSArray *sPlaylists = [[MPMediaQuery playlistsQuery] collections];
    
    for (MPMediaPlaylist *sMediaPlaylist in sPlaylists)
    {
        BKPlaylist *sPlaylist = [[[BKPlaylist alloc] initWithPlaylist:sMediaPlaylist] autorelease];
        [mPlaylists addObject:sPlaylist];
    }
}


@end
