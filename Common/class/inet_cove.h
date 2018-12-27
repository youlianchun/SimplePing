//
//  inet_cove.h
//  iOSApp
//
//  Created by YLCHUN on 2018/5/6.
//

#import <Foundation/Foundation.h>
#import "ip_addr.h"

OBJC_EXTERN ip_addr_t iaddr_from_caddr(char* addr);
OBJC_EXTERN const char* iaddr_to_caddr(ip_addr_t addr);

OBJC_EXTERN ip_addr_t iaddr_from_addr(in_addr_t addr);
OBJC_EXTERN in_addr_t iaddr_to_addr(ip_addr_t iaddr);

OBJC_EXTERN BOOL is_addr_t(ip_addr_t addr);
OBJC_EXTERN BOOL is_mask(in_addr_t addr);

OBJC_EXTERN in_addr_t net_addr_t(in_addr_t addr, in_addr_t mask);
OBJC_EXTERN in_addr_t bro_addr_t(in_addr_t addr, in_addr_t mask);
OBJC_EXTERN unsigned int net_addrs_count(in_addr_t mask);

OBJC_EXTERN unsigned int mask_to_bit(in_addr_t mask);
OBJC_EXTERN in_addr_t mask_from_bit(int bit);

OBJC_EXTERN in_addr_t addr_from_ntoa(const char * ntoa_t);
OBJC_EXTERN char* addr_to_ntoa(in_addr_t addr_t);

OBJC_EXTERN NSString* toNSString(char* utf8);
OBJC_EXTERN const char* toUTF8(NSString* str);
