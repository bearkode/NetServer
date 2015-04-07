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
    
    aInputStream  = [NSMakeCollectable(aReadStream) autorelease];
    aOutputStream = [NSMakeCollectable(aWriteStream) autorelease];
    
    [aInputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    
    BKNetSession *sSession = [[[BKNetSession alloc] initWithInputStream:aInputStream outputStream:aOutputStream] autorelease];
    [[BKNetService sharedService] addSession:sSession];
}


@implementation BKNetService
{
    in_port_t       mInPort;
    NSNetService   *mNetService;
    
    NSMutableArray *mSessions;
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


- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"netServiceDidPublish:");
    
    NSString *name = [sender name];
    NSLog(@"My name is: %@", name);
}


- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"Error publishing: %@", errorDict);
}


- (void)netServiceWillResolve:(NSNetService *)sender
{
    NSLog(@"netServiceWillResolve");
}


- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"netService:didNotResolve:");
}


- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSLog(@"netServiceDidResolveAddress");
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


#pragma mark -


- (void)addSession:(BKNetSession *)aSession
{
    NSParameterAssert(aSession);
    
    [mSessions addObject:aSession];
    
    NSLog(@"addSession = %@", mSessions);
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
    
    NSLog(@"err = %d", (int)err);
    NSLog(@"inport = %d", (int)mInPort);
    
    return sFileDesc;
}


- (void)hookUpWithFileDesc:(int)aFileDesc
{
    NSLog(@"filedesc = %d", (int)aFileDesc);
    
    CFSocketContext    sContext = { 0, NULL, NULL, NULL, NULL };
    CFSocketRef        sSocketRef;
    CFRunLoopSourceRef sRunLoopSourceRef;
    
    sSocketRef        = CFSocketCreateWithNative(NULL, aFileDesc, kCFSocketAcceptCallBack, BKSocketListeningCallback, &sContext);
    sRunLoopSourceRef = CFSocketCreateRunLoopSource(NULL, sSocketRef, 0);
    
    NSLog(@"sScoketRef        = %p", sSocketRef);
    NSLog(@"sRunLoopSourceRef = %p", sRunLoopSourceRef);

    CFRunLoopAddSource(CFRunLoopGetCurrent(), sRunLoopSourceRef, kCFRunLoopCommonModes);
    
    NSLog(@"current run loop = %p", CFRunLoopGetCurrent());
    
    CFRelease(sRunLoopSourceRef);
    CFRelease(sSocketRef);
}


@end
