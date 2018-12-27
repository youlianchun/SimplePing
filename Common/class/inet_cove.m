//
//  inet_cove.m
//  iOSApp
//
//  Created by YLCHUN on 2018/5/6.
//

#import "inet_cove.h"
#import <arpa/inet.h>

ip_addr_t iaddr_from_caddr(char* addr)
{
    return ip_addr_to_i(ip_addr_from_c(addr));
}

const char* iaddr_to_caddr(ip_addr_t addr)
{
    return ip_addr_to_c(ip_addr_from_i(addr));
}

ip_addr_t iaddr_from_addr(in_addr_t addr)
{
    return iaddr_from_caddr(inet_ntoa((struct in_addr){addr}));
}

in_addr_t iaddr_to_addr(ip_addr_t addr)
{
    return inet_addr(iaddr_to_caddr(addr));
}


BOOL is_addr_t(ip_addr_t addr)
{
    return addr <= ip_addr_f /*&& addr >= 0*/;
}

BOOL is_mask(in_addr_t addr)
{
    ip_addr_t _addr = iaddr_from_addr(addr);
    if (is_addr_t(_addr)) {
        return false;
    }
    ip_addr_t b = _addr;
    b = (~b + 1) & ip_addr_f;
    if((b & (b - 1))) {
        return false;
    }
    return true;
}

in_addr_t net_addr_t(in_addr_t addr, in_addr_t mask)
{
    return addr & mask;
}

in_addr_t bro_addr_t(in_addr_t addr, in_addr_t mask)
{
    in_addr_t b = (in_addr_t)((int)addr | ~(int)mask);
    return b & ip_addr_f;
}

unsigned int net_addrs_count(in_addr_t mask)
{
    long b = (long)mask_to_bit(mask);
    return (unsigned int)pow(2, 32-b) - 2;
}

unsigned int mask_to_bit(in_addr_t mask)
{
    char * _mask = inet_ntoa((struct in_addr){mask});
    ip_addr_t m = ip_addr_to_i(ip_addr_from_c(_mask));
    unsigned int mask_bit = 0;
    do {
        m = (m << 1) & ip_addr_f;
        mask_bit++;
    } while (m);
    return mask_bit;
}

in_addr_t mask_from_bit(int bit)
{
    if (bit <= 0 || bit >= 32)  return 0;
    ip_addr_t m = (ip_addr_f << (32 - bit)) & ip_addr_f;
    return iaddr_to_addr(m);
}


in_addr_t addr_from_ntoa(const char * ntoa_t)
{
    return inet_addr(ntoa_t);
}

char* addr_to_ntoa(in_addr_t addr_t)
{
    return inet_ntoa((struct in_addr){addr_t});;
//    char *addr = inet_ntoa((struct in_addr){addr_t});
//    size_t size = sizeof(char) * 16; //15: xxx.xxx.xxx.xxx
//    char *strp = (char *)malloc(size);
//    strlcpy(strp, addr, size);
//    return strp;
}

NSString* toNSString(char* utf8)
{
    if (!utf8) return nil;
    return [NSString stringWithUTF8String:utf8];
}

const char* toUTF8(NSString* str)
{
    if (!str) return NULL;
    return [str UTF8String];
}



