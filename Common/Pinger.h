//
//  Pinger.h
//  SimplePing
//
//  Created by YLCHUN on 2018/5/4.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PingAddrType) {
    PingAddrAny,
    PingAddrIPv4,
    PingAddrIPv6
};

@interface Pinger : NSObject
@property (nonatomic, readonly) NSString *hostName;
- (void)pingHostName:(NSString *)hostName addrType:(PingAddrType)addrType;
- (void)stop;
@end
