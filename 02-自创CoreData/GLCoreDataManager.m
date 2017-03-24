//
//  GLCoreDataManager.m
//  02-自创CoreData
//
//  Created by 钟国龙 on 2017/3/16.
//  Copyright © 2017年 guolong. All rights reserved.
//

#import "GLCoreDataManager.h"

@interface GLCoreDataManager ()

@property (nonatomic, strong)NSManagedObjectContext *managedObjectContextiOS9;

@property (nonatomic, strong)NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation GLCoreDataManager

+ (instancetype)shareManager
{
    static GLCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GLCoreDataManager alloc] init];
    });
    return manager;
}

- (NSPersistentContainer *)persistentContainer
{
    if (_persistentContainer != nil)
    {
        return _persistentContainer;
    }
    
    //创建对象模型文件（使用合并模式）
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //创建存储容器 第一个参数：数据库的文件名 第二个参数是对象模型
    //iOS10之后不能指定数据库的文件存储路径,一定是Library->App Support文件夹中,但是我们可以指定文件名
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:kFileName managedObjectModel:model];
    
    //默认创建的上下文是基于主线程
    NSLog(@"%zd",_persistentContainer.viewContext.concurrencyType);
    
    //加载存储容器（该方法是构建CoreData Stack的核心，此时CoreData Stack三大核心类均由系统自动帮我们创建）
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *des, NSError * error) {
        NSLog(@"存储器描述信息:%@",des);
        NSLog(@"%@",_persistentContainer.viewContext);
        if(error == nil)
        {
            NSLog(@"创建存储容器成功");
        }
    }];
    
    return _persistentContainer;
}

- (NSManagedObjectContext *)managedObjectContext
{
    //CoreData 版本兼容的原理就是在该方法中做一个系统判断,如果是iOS10系统则返回存储容器的上下文,如果是iOs10以前的版本则返回iOS9系统下的上下文
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        return self.persistentContainer.viewContext;
    }
    else
    {
        return self.managedObjectContextiOS9;
    }
    
}

- (NSManagedObjectContext *)managedObjectContextiOS9
{
    if (_managedObjectContextiOS9 != nil)
    {
        return _managedObjectContextiOS9;
    }
    
    //1. 创建管理对象的上下文 参数指的是使用上下文的线程 NSPrivateQueueConcurrencyType 在子线程中操作上下文 子线程会有延迟
    //NSMainQueueConcurrencyType 在主线程中操作上下文 实际开发中一般使用主线程 主线程操作数据库没有延迟
    _managedObjectContextiOS9 = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //2. 设置存储调度器（管理对象上下文的职责是给存储调度器发指令）
    _managedObjectContextiOS9.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    return _managedObjectContextiOS9;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    //1. 创建存储调度器 参数：模型对象
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    //2.给存储调度器添加存储器(真正的存储是由存储器负责的,如果不添加存储器则无法存储数据)
    /**
     第一个参数:存储类型  实际开发中主要是以数据库的形式存储NSSQLiteStoreType
     第二个参数:存储器配置 一般使用系统默认配置即可
     第三个参数:URL:值得是数据库的路径
     第四个参数:参数信息 一般使用系统默认参数信息即可
     第五个参数:是报错信息
     */
    
    //拼接数据库文件名  数据库文件名后缀不能随便写,建议大家使用db格式
    //    NSURL *splitUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject]
    
    NSURL *sqlitUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject URLByAppendingPathComponent:@"sqlit.db"];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlitUrl options:nil error:nil];
    
    return _persistentStoreCoordinator;
}

- (void)save
{
    //数据库的操作是由管理对象上下文来负责的
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error == nil) {
        NSLog(@"保存到数据库成功");
    }
    else
    {
        NSLog(@"保存到数据库失败:%@",error);
    }
}


@end
