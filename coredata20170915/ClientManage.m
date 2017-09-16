//
//  ClientManage.m
//  coredata20170915
//
//  Created by hkshen on 2017/9/15.
//  Copyright © 2017年 hkshen. All rights reserved.
//

#import "ClientManage.h"

static ClientManage *clientManage = nil;

@implementation ClientManage

+ (instancetype)singletonInstance {
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (clientManage == nil) {
//            clientManage = [[ClientManage alloc] init];
//        }
//    });
//    return clientManage;
    
    @synchronized (self) {
        if (clientManage == nil) {
            clientManage = [[ClientManage alloc] init];
        }
        return clientManage;
    }
}

@end
