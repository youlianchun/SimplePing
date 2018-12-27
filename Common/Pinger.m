//
//  Pinger.m
//  SimplePing
//
//  Created by YLCHUN on 2018/5/4.
//

#import "Pinger.h"
#import "SimplePing.h"

@interface Pinger() <SimplePingDelegate>
{
    SimplePing *_pinger;
    NSTimer *_sendTimer;
}
@end

@implementation Pinger

static dispatch_queue_t pingQueue()
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("ping", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

-(NSString *)hostName
{
    return _pinger.hostName;
}

- (void)stop
{
    [_sendTimer invalidate];
    _sendTimer = nil;
    _pinger.delegate = nil;
    [_pinger stop];
    _pinger = nil;
}

-(void)start
{
    dispatch_async(pingQueue(), ^{
        [self->_pinger start];
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (self->_pinger != nil);
    });
}

- (void)pingHostName:(NSString *)hostName addrType:(PingAddrType)addrType
{
    [self stop];
    _pinger = [[SimplePing alloc] initWithHostName:hostName];
    _pinger.addressStyle = (SimplePingAddressStyle)addrType;
    _pinger.delegate = self;
    [self start];
}

-(void)ping
{
    [_pinger sendPingWithData:nil];
}

-(void)sendPing
{
    [self ping];
    _sendTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ping) userInfo:nil repeats:YES];
}

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    #pragma unused(address)
    [self pingLog:@"pinging %@", pinger.hostName];
    [self sendPing];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
    [self pingLog:@"failed %@: %@", pinger.hostName, error.description];
    [self stop];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    #pragma unused(packet)
    [self pingLog:@"#%u sent %@", sequenceNumber, pinger.hostName];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{
    #pragma unused(packet)
    [self pingLog:@"#%u send %@ failed: %@", sequenceNumber, pinger.hostName, error.description];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    [self pingLog:@"#%u received %@, size=%zu", sequenceNumber, pinger.hostName, packet.length];
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    [self pingLog:@"unexpected packet %@, size=%zu", pinger.hostName, packet.length];
}

-(void)pingLog:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
#if DEBUG
    if (!format) return;
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
#else
    #pragma unused(format)
#endif
}

@end
