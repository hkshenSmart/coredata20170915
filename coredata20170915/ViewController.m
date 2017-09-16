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
- (IBAction)doBatchInsert:(id)sender;
- (IBAction)doBatchUpdate:(id)sender;
- (IBAction)doBatchDelete:(id)sender;


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
    
    // 保存
    NSError *error = nil;
    if ([[ClientManage singletonInstance].managedObjectContext hasChanges] && ![[ClientManage singletonInstance].managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (IBAction)doBatchInsert:(id)sender {
    
    for (int i = 0; i < 10; i ++) {
        
        Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[ClientManage singletonInstance].managedObjectContext];
        
        int16_t nameID = arc4random_uniform(9999);
        person.name = [NSString stringWithFormat:@"name-%d", nameID];
        
        [person setValue:[NSNumber numberWithInt:(arc4random_uniform(10) + 10)] forKey:@"age"];
        
        // 保存
        NSError *error = nil;
        if ([[ClientManage singletonInstance].managedObjectContext hasChanges] && ![[ClientManage singletonInstance].managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}

- (IBAction)doBatchUpdate:(id)sender {
    
    // 初始化查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[ClientManage singletonInstance].managedObjectContext];
    
    // 排序方式
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    // 条件过滤
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"hkshen"];
    
    fetchRequest.entity = entityDescription;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //fetchRequest.predicate = predicate;
    
    NSArray *objectArray = [[ClientManage singletonInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if (objectArray) {
        NSLog(@"objectArray:%@", objectArray);
        
        // 1、KVC方式改加载到内存
        //[objectArray setValue:@"iOS" forKey:@"name"];
        //NSLog(@"KVC update:%@", objectArray);
        
        // 2、NSBatchUpdateRequest不加载到内存，直接对本地数据库进行更新，避免内存不足
        NSBatchUpdateRequest *batchUpdateRequest = [[NSBatchUpdateRequest alloc] initWithEntityName:@"Person"];
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age == %@", @(20)];
        //batchUpdateRequest.predicate = predicate;
        batchUpdateRequest.propertiesToUpdate = @{@"name": @"hksheniOS"};
        
        BOOL isSuccess = batchUpdateRequest.resultType;
        if (isSuccess) {
            NSLog(@"isSuccess");
        }
        else {
            NSLog(@"failure");
        }
        NSLog(@"NSBatchUpdateRequest update:%@", objectArray);
    }
    
    // 保存
    NSError *error = nil;
    if ([[ClientManage singletonInstance].managedObjectContext hasChanges] && ![[ClientManage singletonInstance].managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (IBAction)doBatchDelete:(id)sender {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[ClientManage singletonInstance].managedObjectContext];
    fetchRequest.entity = entityDescription;
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"age == %@", @(23)];
    
    NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    batchDeleteRequest.resultType = NSBatchDeleteResultTypeObjectIDs;
    
    NSBatchDeleteResult *batchDeleteResult = [[ClientManage singletonInstance].managedObjectContext executeRequest:batchDeleteRequest error:nil];
    
    NSArray<NSManagedObjectID *> *batchDeleteResultManagedObjectIDArray = batchDeleteResult.result;
    
    // 删除的告诉NSManagedObjectContext
    NSDictionary *batchDeleteResultDict = @{NSDeletedObjectsKey: batchDeleteResultManagedObjectIDArray};
    NSManagedObjectContext *managedObjectContex = [ClientManage singletonInstance].managedObjectContext;
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:batchDeleteResultDict intoContexts:@[managedObjectContex]];
}

@end
