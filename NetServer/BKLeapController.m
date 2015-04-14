/*
 *  BKLeapController.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKLeapController.h"
#import "LeapObjectiveC.h"
#import "BKHand+LeapAddtions.h"


@implementation BKLeapController
{
    LeapController *mLeapController;
    id              mDelegate;
}


- (instancetype)initWithDelegate:(id)aDelegate
{
    self = [super init];
    
    if (self)
    {
        mLeapController = [[LeapController alloc] init];
        [mLeapController addListener:self];
        
        mDelegate = aDelegate;
    }
    
    return self;
}


- (void)dealloc
{
    [mLeapController release];
    
    [super dealloc];
}


#pragma mark -


- (void)onInit:(NSNotification *)aNotification
{
    NSLog(@"onInit");
}


- (void)onConnect:(NSNotification *)aNotification
{
    NSLog(@"onConnect");
}


- (void)onDeviceChange:(NSNotification *)aNotification
{
    NSLog(@"onDeviceChange");
}


- (void)onDisconnect:(NSNotification *)aNotification
{
    NSLog(@"onDisconnect");
}


- (void)onExit:(NSNotification *)aNotification
{
    NSLog(@"onExit");
}


- (void)onFocusGained:(NSNotification *)aNotification
{
    NSLog(@"onFocusGained");
}


- (void)onFocusLost:(NSNotification *)aNotification
{
    NSLog(@"onFocusLost");
}


- (void)onFrame:(NSNotification *)aNotification
{
    LeapHand *sHand= [self firstHand];
    
    if (sHand)
    {
        //        LeapVector *sHandDir     = [sHand direction];
        //        LeapVector *sHandNormal  = [sHand palmNormal];
        //        LeapVector *sHandPositon = [sHand palmPosition];
        
        //        NSLog(@"position = %1.2f, %1.2f, %1.2f", [sHandPositon x], [sHandPositon y], [sHandPositon z]);
        
        //        NSLog(@"%2.1f, %2.1f, %2.1f - %2.1f, %2.1f, %2.1f", [sHandDir x], [sHandDir y], [sHandDir z], [sHandNormal x], [sHandNormal y], [sHandNormal z]);
        //
        //        NSMutableString *sLog     = [NSMutableString stringWithString:@"["];
        //        NSArray         *sFingers = [sHand fingers];
        //
        //        for (LeapFinger *sFinger in sFingers)
        //        {
        //            LeapVector *sDir   = [sFinger direction];
        //            float       sAngle = [sHandDir angleTo:sDir];
        //
        //            [sLog appendFormat:@"%2.1f ", sAngle];
        //        }
        //        [sLog appendString:@"]"];
        //        
        //        NSLog(@"angle = %@", sLog);
    }
    
//    [self setMotion:[sHand motion]];
    if ([mDelegate respondsToSelector:@selector(leapController:didUpdateHand:)])
    {
        [mDelegate leapController:self didUpdateHand:[BKHand handWithLeapHand:sHand]];
    }
}


- (void)onImages:(NSNotification *)aNotification
{
    NSLog(@"onImages");
}


- (void)onServiceConnect:(NSNotification *)aNotification
{
    NSLog(@"onServiceConnect");
}


- (void)onServiceDisconnect:(NSNotification *)aNotification
{
    NSLog(@"onServiceDisconnect");
}


- (LeapHand *)firstHand
{
    LeapFrame *sFrame = [mLeapController frame:0];
    
    return [[sFrame hands] firstObject];
}


@end
