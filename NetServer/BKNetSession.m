/*
 *  BKNetSession.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKNetSession.h"
#import "BKStream.h"


@implementation BKNetSession
{
    BKStream *mStream;
    id        mDelegate;
}


@synthesize delegate = mDelegate;


- (instancetype)initWithInputStream:(NSInputStream *)aInStream outputStream:(NSOutputStream *)aOutStream
{
    self = [super init];
    
    if (self)
    {
        mStream = [[BKStream alloc] initWithInputStream:aInStream outputStream:aOutStream delegate:self];
        [mStream open];
    }
    
    return self;
}


- (void)dealloc
{
    [mStream close];
    [mStream release];
    
    [super dealloc];
}


- (void)streamDidOpen:(BKStream *)aStream
{

}


- (void)streamDidClose:(BKStream *)aStream
{
    if ([mDelegate respondsToSelector:@selector(netSessionDidClose:)])
    {
        [mDelegate netSessionDidClose:self];
    }
}


- (void)stream:(BKStream *)aStream didWriteData:(NSData *)aData
{

}


- (void)stream:(BKStream *)aStream didReadData:(NSData *)aData
{
    [mStream handleDataUsingBlock:^NSInteger(NSData *aData) {
        NSInteger sResult = 0;
        
        if ([aData length] > 2)
        {
            uint16_t sLength  = 0;
            NSData  *sPayload = nil;
            
            [aData getBytes:&sLength length:2];
            
            sLength = ntohs(sLength);
            NSInteger sHandledLength = sLength + 2;
            
            if ([aData length] >= sHandledLength)
            {
                sPayload = [aData subdataWithRange:NSMakeRange(2, sLength)];
                
                id sJSONObject = [NSJSONSerialization JSONObjectWithData:sPayload options:0 error:NULL];
                NSLog(@"sJSONObject = %@", sJSONObject);
                
                sResult = sHandledLength;
            }
        }
        
        return sResult;
    }];
}



#pragma mark -


- (void)sendMousePosition:(NSPoint)aPosition
{
    NSDictionary  *sDict = @{ @"type" : @"mousePosition",
                              @"x"    : [NSNumber numberWithFloat:aPosition.x],
                              @"y"    : [NSNumber numberWithFloat:aPosition.y] };

    [self sendJSONObject:sDict];
}


- (void)sendJSONObject:(id)aJSONObject
{
    NSData        *sPayload = [NSJSONSerialization dataWithJSONObject:aJSONObject options:0 error:nil];
    uint16_t       sLength  = htons([sPayload length]);
    NSMutableData *sPacket  = [NSMutableData data];
    
    [sPacket appendBytes:&sLength length:2];
    [sPacket appendData:sPayload];
    
    [mStream writeData:sPacket];
}


@end
