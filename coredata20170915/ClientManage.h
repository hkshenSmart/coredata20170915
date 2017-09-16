//
//  ClientManage.h
//  coredata20170915
//
//  Created by hkshen on 2017/9/15.
//  Copyright © 2017年 hkshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ClientManage : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)singletonInstance;

@end
