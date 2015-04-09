/*
 *  BKNetService.m
 *  NetServer
 *
 *  Created by cgkim on 2015. 4. 6..
 *  Copyright (c) 2015 cgkim. All rights reserved.
 *
 */

#import "BKNetService.h"
#import <CoreFoundation/CoreFoundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import "BKNetSession.h"


static NSString *const kServiceType = @"_myservice._tcp.";


void BKSocketListeningCallback(CFSocketRef aSocketRef, CFSocketCallBackType aType, CFDataRef aAddress, const void *aData, void *aInfo);


void BKSocketListeningCallback(CFSocketRef aSocketRef, CFSocketCallBackType aType, CFDataRef aAddress, const void *aData, void *aInfo)
{
    NSLog(@"BKSocketListeningCallback");
    
    int              sFileDesc = *(const int *)aData;
    CFReadStreamRef  aReadStream;
    CFWriteStreamRef aWriteStream;
    NSInputStream   *aInputStream;
    NSOutputStream  *aOutputStream;
    
    CFStreamCreatePairWithSocket(NULL, sFileDesc, &aReadStream, &aWriteStream);
    
    aInputStream  = objc_unretainedObject(aReadStream);
    aOutputStream = objc_unretainedObject(aWriteStream);
    
    [aInputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    [aOutputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    
    BKNetSession *sSession = [[BKNetSession alloc] initWithInputStream:aInputStream outputStream:aOutputStream];
    [[BKNetService sharedService] addSession:sSession];
    [sSession release];
    
    CFRelease(aReadStream);
    CFRelease(aWriteStream);
}


@implementation BKNetService
{
    in_port_t       mInPort;
    NSNetService   *mNetService;
    
    NSMutableArray *mSessions;
    
    NSPoint         mMousePosition;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        int sFileDesc = [self listen];
        [self hookUpWithFileDesc:sFileDesc];
        
        mNetService = [[NSNetService alloc] initWithDomain:@"" type:kServiceType name:@"" port:ntohs(mInPort)];
        [mNetService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [mNetService setDelegate:self];
        [mNetService publish];
        
        mSessions = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mNetService stop];
    
    [mNetService release];
    [mSessions release];
    
    [super dealloc];
}


#pragma mark - NetServiceDelegate


- (void)netServiceWillPublish:(NSNetService *)sender
{
    NSLog(@"netServiceWillPublish = %@", sender);
}


- (void)netServiceDidPublish:(NSNetService *)aNetService
{
    NSLog(@"netServiceDidPublish:");
    
    NSString *sName = [aNetService name];
    
    NSLog(@"My name is: %@", sName);
}


- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"Error publishing: %@", errorDict);
}


- (void)netServiceWillResolve:(NSNetService *)sender
{
    NSLog(@"netServiceWillResolve");
}


- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)aErrorDict
{
    NSLog(@"netService:didNotResolve:");
    NSLog(@"aErrorDict = %@", aErrorDict);
}


- (void)netServiceDidResolveAddress:(NSNetService *)aNetService
{
    NSLog(@"netServiceDidResolveAddress");
    NSLog(@"addresses = %@", [aNetService addresses]);
}


- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data
{
    NSLog(@"netService:didUpdateTXTRecordData:");
}


- (void)netServiceDidStop:(NSNetService *)sender
{
    NSLog(@"netServiceDidStop");
}


- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    NSLog(@"netService:didAcceptConnectionWithInputStream:outputStream");
}


- (void)netSessionDidClose:(BKNetSession *)aNetSession
{
    [mSessions removeObject:aNetSession];
}


#pragma mark -


- (void)addSession:(BKNetSession *)aSession
{
    NSParameterAssert(aSession);
    
    [aSession setDelegate:self];
    [mSessions addObject:aSession];
}


- (void)setMousePosition:(NSPoint)aPosition
{
    if (!NSEqualPoints(mMousePosition, aPosition))
    {
        mMousePosition = aPosition;
        
        for (BKNetSession *sSession in mSessions)
        {
            [sSession sendMousePosition:mMousePosition];
        }
    }
}


#pragma mark -


- (int)listen
{
    int                sFileDesc = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in sSockAddrIn;
    socklen_t          sSockAddrLen;
    
    memset(&sSockAddrIn, 0, sizeof(sSockAddrIn));

    sSockAddrIn.sin_family = AF_INET;
    sSockAddrIn.sin_len    = sizeof(sSockAddrIn);
    sSockAddrIn.sin_port   = 0;
    
    int err = bind(sFileDesc, (const struct sockaddr *)&sSockAddrIn, sSockAddrIn.sin_len);
    
    sSockAddrLen = sizeof(sSockAddrIn);
    err = getsockname(sFileDesc, (struct sockaddr *)&sSockAddrIn, &sSockAddrLen);
    err = listen(sFileDesc, 5);
    
    mInPort = sSockAddrIn.sin_port;
    
    return sFileDesc;
}


- (void)hookUpWithFileDesc:(int)aFileDesc
{
    CFSocketContext    sContext = { 0, NULL, NULL, NULL, NULL };
    CFSocketRef        sSocketRef;
    CFRunLoopSourceRef sRunLoopSourceRef;
    
    sSocketRef        = CFSocketCreateWithNative(NULL, aFileDesc, kCFSocketAcceptCallBack, BKSocketListeningCallback, &sContext);
    sRunLoopSourceRef = CFSocketCreateRunLoopSource(NULL, sSocketRef, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), sRunLoopSourceRef, kCFRunLoopCommonModes);
    
    CFRelease(sRunLoopSourceRef);
    CFRelease(sSocketRef);
}


@end
