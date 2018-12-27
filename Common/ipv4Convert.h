//
//  ipv4Convert.h
//  SimplePing
//
//  Created by YLCHUN on 2018/5/4.
//

#import <Foundation/Foundation.h>

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
