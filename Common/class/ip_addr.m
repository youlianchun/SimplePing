//
//  ip_addr.m
//  iOSApp
//
//  Created by YLCHUN on 2018/5/6.
//

#import "ip_addr.h"
#import <arpa/inet.h>

const ip_addr_t ip_addr_f =  0xffffffff;
const ip_addr_t ip_addr_tf = 0xff;

static void strtoks(char *str, char *seg, void(^subcb)(int idx, char* sub))
{
    if (!subcb) return;
    int i = 0;
    char _str[16];
    strncpy(_str, str, strlen(str));
    char *substr= strtok(_str, seg);
    while (substr != NULL) {
        subcb(i++, substr);
        substr = strtok(NULL,seg);
    }
    getchar();
}

ip_addr ip_addr_from_c(char *addr)
{
    static char *seg = ".";
    ip_addr _addr;
    ip_addr_t *p = (ip_addr_t *)&_addr;
    strtoks(addr, seg, ^(int idx, char *sub) {
        if (idx < 4)
            *(p+idx) = (ip_addr_t)atoi(sub);
    });
    return _addr;
}

const char * ip_addr_to_c(ip_addr addr)
{
    char *_addr = malloc(sizeof(char)*16);
    sprintf(_addr, "%u.%u.%u.%u", addr.a, addr.b, addr.c, addr.d);
    return _addr;
}

ip_addr ip_addr_from_i(ip_addr_t addr)
{
    ip_addr _addr;
    ip_addr_t *p = (ip_addr_t *)&_addr;
    *p++ = (addr & 0xff000000) >> 24;
    *p++ = (addr & 0x00ff0000) >> 16;
    *p++ = (addr & 0x0000ff00) >> 8;
    *p =   (addr & 0x000000ff) >> 0;
    return _addr;
}

ip_addr_t ip_addr_to_i(ip_addr addr)
{
    ip_addr_t n = (addr.a << 24) + (addr.b << 16) + (addr.c << 8) + addr.d;
    return n & ip_addr_f;
}

ip_addr_t ip_addr_net(ip_addr_t addr, ip_addr_t mask)
{
    return addr & mask & ip_addr_f;
}

ip_addr_t ip_addr_bro(ip_addr_t addr, ip_addr_t mask)
{
    return (addr | ~mask) & ip_addr_f;
}
