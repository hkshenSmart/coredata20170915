//
//  Person+CoreDataProperties.m
//  coredata20170915
//
//  Created by hkshen on 2017/9/15.
//  Copyright © 2017年 hkshen. All rights reserved.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic name;
@dynamic age;
@dynamic card;

@end
