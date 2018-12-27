//
//  ipv4Convert.m
//  SimplePing
//
//  Created by YLCHUN on 2018/5/4.
//

#import "ipv4Convert.h"
#import "inet_cove.h"
#import <arpa/inet.h>

//子网掩码位数转掩码地址
int get_mask_bit(NSString *mask)
{
    in_addr_t addr = addr_from_ntoa(toUTF8(mask));
    return (int)mask_to_bit(addr);
}

//子网掩码地址转掩码位
NSString* get_mask_addr(int bit)
{
    in_addr_t mask = mask_from_bit(bit);
    if (mask == 0) return @"";
    return toNSString(addr_to_ntoa(mask));
}


//获取广播地址
NSString* get_broadcast_addr(NSString *addr, NSString *mask)
{
    in_addr_t in_addr = addr_from_ntoa(toUTF8(addr));
    in_addr_t in_mask = addr_from_ntoa(toUTF8(mask));
    in_addr_t in_bAddr = bro_addr_t(in_addr, in_mask);
    return toNSString(addr_to_ntoa(in_bAddr));
}

//获取网络地址
NSString* get_net_addr(NSString *addr, NSString *mask)
{
    in_addr_t in_addr = addr_from_ntoa(toUTF8(addr));
    in_addr_t in_mask = addr_from_ntoa(toUTF8(mask));
    in_addr_t in_nAddr = net_addr_t(in_addr, in_mask);
    return toNSString(addr_to_ntoa(in_nAddr));
}

//获取网络所有ip地址
NSArray* get_net_addrs(NSString *addr, NSString *mask)
{
    ip_addr_t in_addr = iaddr_from_caddr((char *)toUTF8(addr));
    ip_addr_t in_mask = iaddr_from_caddr((char *)toUTF8(mask));
    
    ip_addr_t inAddr = ip_addr_net(in_addr, in_mask);
    ip_addr_t ibAddr = ip_addr_bro(in_addr, in_mask);
    
    NSMutableArray *array = [NSMutableArray array];
    ip_addr_t x = inAddr;
    while (++x < ibAddr) {
        [array addObject:toNSString((char *)iaddr_to_caddr(x))];
    }
    return array;
}

int get_addrs_count(NSString *mask)
{
    return (int)net_addrs_count(inet_addr(toUTF8(mask)));
}
