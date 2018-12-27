//
//  ViewController.m
//  iOSApp
//
//  Created by YLCHUN on 2018/5/4.
//

#import "ViewController.h"
#import "Pinger.h"
#import "localArp.h"
#import "ipv4Convert.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *info = get_lan_info();
    
    int b = get_mask_bit(info[@"netmask"]);
    
    int count = get_addrs_count(@"255.255.252.0");

    NSArray *arr = get_net_addrs(@"172.40.123.255", @"255.255.252.0");
    
    Pinger *pinger = [[Pinger alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pinger stop];
        NSArray *arps = get_arps(true);
        NSLog(@"");
    });
    [pinger pingHostName:info[@"broadcast"] addrType:PingAddrAny];
    NSLog(@"");


    
}

@end
