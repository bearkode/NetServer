/*
 *  BKNetSession.m
 *  NetServer
 *
 *  Created by cgkim on 2015. 4. 6..
 *  Copyright (c) 2015 cgkim. All rights reserved.
 *
 */

#import "BKNetSession.h"


@implementation BKNetSession
{
    NSInputStream  *mInStream;
    NSOutputStream *mOutStream;
    
    NSMutableData  *mInputBuffer;
}


- (instancetype)initWithInputStream:(NSInputStream *)aInStream outputStream:(NSOutputStream *)aOutStream
{
    self = [super init];
    
    if (self)
    {
        mInStream  = [aInStream retain];
        mOutStream = [aOutStream retain];
        
        [mInStream setDelegate:self];
        [mOutStream setDelegate:self];
        
        [mInStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [mOutStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        [mInStream open];
        [mOutStream open];
        
        mInputBuffer = [[NSMutableData alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mInStream release];
    [mOutStream release];
    
    [mInputBuffer release];
    
    [super dealloc];
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)aStreamEvent
{
    if (aStream == mInStream)
    {
        [self inputStreamHandleEvent:aStreamEvent];
    }
    else if (aStream == mOutStream)
    {
        [self outputStreamHandleEvent:aStreamEvent];
    }
}


- (void)inputStreamHandleEvent:(NSStreamEvent)aStreamEvent
{
    if (aStreamEvent == NSStreamEventNone)
    {
        NSLog(@"in NSStreamEventNone");
    }
    else if (aStreamEvent == NSStreamEventOpenCompleted)
    {
        NSLog(@"in NSStreamEventOpenCompleted");
    }
    else if (aStreamEvent == NSStreamEventHasBytesAvailable)
    {
        uint8_t   sBuffer[1024];
        NSInteger sReadBytes = [mInStream read:sBuffer maxLength:1024];
        
        if (sReadBytes)
        {
            [mInputBuffer appendBytes:sBuffer length:sReadBytes];
        }
        
        [self parseInputPackets];
    }
    else if (aStreamEvent == NSStreamEventHasSpaceAvailable)
    {
        NSLog(@"in NSStreamEventHasSpaceAvailable");
    }
    else if (aStreamEvent == NSStreamEventErrorOccurred)
    {
        NSLog(@"in NSStreamEventErrorOccurred");
    }
    else if (aStreamEvent == NSStreamEventEndEncountered)
    {
        NSLog(@"in NSStreamEventEndEncountered");
    }
}


- (void)outputStreamHandleEvent:(NSStreamEvent)aStreamEvent
{
    if (aStreamEvent == NSStreamEventNone)
    {
        NSLog(@"out NSStreamEventNone");
    }
    else if (aStreamEvent == NSStreamEventOpenCompleted)
    {
        NSLog(@"out NSStreamEventOpenCompleted");
    }
    else if (aStreamEvent == NSStreamEventHasBytesAvailable)
    {
        NSLog(@"out NSStreamEventHasBytesAvailable");
    }
    else if (aStreamEvent == NSStreamEventHasSpaceAvailable)
    {
        NSLog(@"out NSStreamEventHasSpaceAvailable");
    }
    else if (aStreamEvent == NSStreamEventErrorOccurred)
    {
        NSLog(@"out NSStreamEventErrorOccurred");
    }
    else if (aStreamEvent == NSStreamEventEndEncountered)
    {
        NSLog(@"out NSStreamEventEndEncountered");
    }
}


- (void)parseInputPackets
{
    BOOL sWait = NO;

    while ([mInputBuffer length] && sWait == NO)
    {
        uint16_t sLength  = 0;
        NSData  *sPayload = nil;
        
        [mInputBuffer getBytes:&sLength length:2];
        
        sLength  = ntohs(sLength);
        NSInteger sHandledLength = sLength + 2;
        
        if ([mInputBuffer length] >= sHandledLength)
        {
            sPayload = [mInputBuffer subdataWithRange:NSMakeRange(2, sLength)];
            [mInputBuffer replaceBytesInRange:NSMakeRange(0, sHandledLength) withBytes:NULL length:0];
            
            id sJSONObject = [NSJSONSerialization JSONObjectWithData:sPayload options:0 error:NULL];
        }
        else
        {
            sWait = YES;
        }
    }
}


@end
