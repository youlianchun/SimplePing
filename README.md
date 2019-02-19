# SimplePing
SimplePing

## api 介绍
### ipv4 地址换算
```
OBJC_EXTERN int get_addrs_count(NSString *mask);
//子网掩码位数转掩码地址
OBJC_EXTERN int get_mask_bit(NSString *mask);

//子网掩码地址转掩码位
OBJC_EXTERN NSString* get_mask_addr(int bit);

//获取广播地址
OBJC_EXTERN NSString* get_broadcast_addr(NSString *addr, NSString *mask);

//获取网络地址
OBJC_EXTERN NSString* get_net_addr(NSString *addr, NSString *mask);

//获取网络所有ip地址
OBJC_EXTERN NSArray* get_net_addrs(NSString *addr, NSString *mask);

```

### pinger
```
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
```

### local arp
```
OBJC_EXTERN NSDictionary* get_lan_info(void);

OBJC_EXTERN NSArray* get_arps(BOOL lan);
```
