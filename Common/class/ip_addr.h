//
//  ip_addr.h
//  iOSApp
//
//  Created by YLCHUN on 2018/5/6.
//

#import <Foundation/Foundation.h>

typedef unsigned int ip_addr_t;//二进制格式

typedef struct {
    const ip_addr_t a;
    const ip_addr_t b;
    const ip_addr_t c;
    const ip_addr_t d;
} ip_addr;

OBJC_EXTERN const ip_addr_t ip_addr_f;
OBJC_EXTERN const ip_addr_t  ip_addr_tf;


OBJC_EXTERN ip_addr ip_addr_from_c(char *addr);
OBJC_EXTERN const char * ip_addr_to_c(ip_addr addr);

OBJC_EXTERN ip_addr ip_addr_from_i(ip_addr_t addr);
OBJC_EXTERN ip_addr_t ip_addr_to_i(ip_addr addr);

OBJC_EXTERN ip_addr_t ip_addr_net(ip_addr_t addr, ip_addr_t mask);
OBJC_EXTERN ip_addr_t ip_addr_bro(ip_addr_t addr, ip_addr_t mask);
