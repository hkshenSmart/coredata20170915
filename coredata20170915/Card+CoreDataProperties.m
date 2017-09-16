//
//  Card+CoreDataProperties.m
//  coredata20170915
//
//  Created by hkshen on 2017/9/15.
//  Copyright © 2017年 hkshen. All rights reserved.
//

#import "Card+CoreDataProperties.h"

@implementation Card (CoreDataProperties)

+ (NSFetchRequest<Card *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Card"];
}

@dynamic no;
@dynamic person;

@end
