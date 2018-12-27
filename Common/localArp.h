//
//  localArp.h
//  SimplePing
//
//  Created by YLCHUN on 2018/5/4.
//

#import <Foundation/Foundation.h>

OBJC_EXTERN NSDictionary* get_lan_info(void);

OBJC_EXTERN NSArray* get_arps(BOOL lan);
