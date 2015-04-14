/*
 *  AppDelegate.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject <NSApplicationDelegate>


@property (nonatomic, assign) IBOutlet NSWindow    *window;

@property (nonatomic, assign) IBOutlet NSTextField *prevLabel;
@property (nonatomic, assign) IBOutlet NSTextField *nextLabel;
@property (nonatomic, assign) IBOutlet NSTextField *statusLabel;
@property (nonatomic, assign) IBOutlet NSTextField *upLabel;
@property (nonatomic, assign) IBOutlet NSTextField *downLabel;


@end

