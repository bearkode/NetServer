/*
 *  BKPlaylist.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 5. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface BKPlaylist : NSObject


@property (nonatomic, assign, getter=isSelected) BOOL selected;


- (instancetype)initWithPlaylist:(MPMediaPlaylist *)aPlaylist;


- (NSString *)title;
- (void)deselect;


@end
