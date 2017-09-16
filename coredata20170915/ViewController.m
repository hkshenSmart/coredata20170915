//
//  ViewController.m
//  coredata20170915
//
//  Created by hkshen on 2017/9/15.
//  Copyright © 2017年 hkshen. All rights reserved.
//

#import "ViewController.h"
#import "Person+CoreDataClass.h"
#import "ClientManage.h"
#import "Card+CoreDataClass.h"
#import "AppDelegate.h"

@interface ViewController ()

- (IBAction)doCoreDataCheck:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    // 增
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[ClientManage singletonInstance].managedObjectContext];
    //person.age = [NSNumber numberWithInteger:40];
    [person setValue:[NSNumber numberWithInt:27] forKey:@"age"];
    person.name = @"hkshen";
    
    Card *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:[ClientManage singletonInstance].managedObjectContext];
    card.no = @"123456";
    
    person.card = card;
    card.person = person;
    
    // 保存
    NSError *error = nil;
    if ([[ClientManage singletonInstance].managedObjectContext hasChanges] && ![[ClientManage singletonInstance].managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button functions

// 查
- (IBAction)doCoreDataCheck:(id)sender {
    
    // 初始化查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[ClientManage singletonInstance].managedObjectContext];
    
    // 排序方式
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    // 条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"hkshen"];
    
    fetchRequest.entity = entityDescription;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    fetchRequest.predicate = predicate;
    
    NSArray *objectArray = [[ClientManage singletonInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if (objectArray) {
        NSLog(@"objectArray:%@", objectArray);
        
        // 改
        Person *checkedPerson = [objectArray objectAtIndex:0];
        checkedPerson.name = @"wanglanman";
        NSLog(@"CheckedPerson:%@", checkedPerson);
        
        // 删
        //[[ClientManage singletonInstance].managedObjectContext deleteObject:checkedPerson];
    }
}

@end
