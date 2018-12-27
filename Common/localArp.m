//
//  localArp.m
//  SimplePing
//
//  Created by YLCHUN on 2018/5/4.
//

#import "localArp.h"
#import <sys/sysctl.h>
#import <net/if_dl.h>
#import <err.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <netdb.h>
#import "route.h"
#import "if_ether.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "inet_cove.h"

typedef struct {
    in_addr_t address;
    in_addr_t broadcast;
    in_addr_t netmask;
    char * ssid;
    char * bssid;
} EN0;

static void free_en0(EN0* en0)
{
    if (en0) {
        en0->address = 0;
        en0->broadcast = 0;
        en0->netmask = 0;
        free(en0);
    }
}

static EN0* _get_lan_info(void)
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    EN0 *en0 = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if (strstr(temp_addr->ifa_name, "en0")) {
                    if (en0 == NULL)
                        en0 = malloc(sizeof(EN0));

                    en0->address = ((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr.s_addr;
                    en0->broadcast = ((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr.s_addr;
                    en0->netmask = ((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr.s_addr;
                    
                    char *ifa_name = temp_addr->ifa_name;
                    CFStringRef ifaName = CFStringCreateWithCString(NULL, ifa_name, kCFStringEncodingUTF8);
                    NSDictionary *dict = (__bridge_transfer NSDictionary*) CNCopyCurrentNetworkInfo(ifaName);
                    CFRelease(ifaName);
                    en0->ssid = (char *)toUTF8(dict[@"SSID"]);
                    en0->bssid = (char *)toUTF8(dict[@"BSSID"]);
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return en0;
}


NSMutableDictionary * get_lan_info(void)
{
    EN0 *en0 = _get_lan_info();
    NSMutableDictionary *info;
    if (en0) {
        info = [NSMutableDictionary dictionary];
        char * address = addr_to_ntoa(en0->address);
        info[@"address"] = toNSString(address); //free(address);
        char * broadcast = addr_to_ntoa(en0->broadcast);
        info[@"broadcast"] = toNSString(broadcast); //free(broadcast);
        char * netmask = addr_to_ntoa(en0->netmask);
        info[@"netmask"] = toNSString(netmask); //free(netmask);
        info[@"ssid"] = toNSString(en0->ssid);
        info[@"bssid"] = toNSString(en0->bssid);
        free_en0(en0);
    }
    return info;
}


NSMutableArray* get_arps(BOOL lan)
{
    static int nflag;
    int mib[6];
    size_t needed;
    char *host, *lim, *buf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    extern int h_errno;
    struct hostent *hp;
    
    in_addr_t mask = 0;
    in_addr_t netaddr = 0;
    EN0 *en0 = _get_lan_info();
    if (en0) {
        mask = en0->netmask;
        netaddr = net_addr_t(en0->address, mask);
        free_en0(en0);
    }
    
    NSMutableArray *arps = [NSMutableArray array];
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");
        if ((buf = malloc(needed)) == NULL)
            err(1, "malloc");
            if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
                err(1, "actual retrieval of routing table");
                lim = buf + needed;
                for (next = buf; next < lim; next += rtm->rtm_msglen) {
                    rtm = (struct rt_msghdr *)next;
                    sin = (struct sockaddr_inarp *)(rtm + 1);
                    sdl = (struct sockaddr_dl *)(sin + 1);
                    if (lan && mask != 0 && netaddr != 0) {
                        in_addr_t addr = sin->sin_addr.s_addr;
                        if (net_addr_t(addr, mask) != netaddr)
                            continue;

                    }
                    if (nflag == 0)
                        ;
//                        hp = gethostbyaddr((caddr_t)&(sin->sin_addr),
//                                           sizeof sin->sin_addr, AF_INET);
                    else
                        hp = 0;
                    if (hp)
                        ;
//                        host = hp->h_name;
                    else {
                        host = "?";
                        if (h_errno == TRY_AGAIN)
                            nflag = 1;
                    }
                    
                    NSString *hostName ;//= [NSString stringWithUTF8String:host];
                    NSString *address = [NSString stringWithUTF8String:inet_ntoa(sin->sin_addr)];
                    NSString *macAddr;
                    if (sdl->sdl_alen) {
                        u_char *cp = (u_char *)LLADDR(sdl);
                        macAddr = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
                    }
                    [arps addObject:@{@"host":hostName?:@"",
                                      @"addr":address?:@"",
                                      @"mac":macAddr?:@"",
                                      }];
                }
    return arps;
}
