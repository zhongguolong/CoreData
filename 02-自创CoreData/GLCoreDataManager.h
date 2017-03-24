//
//  GLCoreDataManager.h
//  02-自创CoreData
//
//  Created by 钟国龙 on 2017/3/16.
//  Copyright © 2017年 guolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

#define kGLCoreDataManager [GLCoreDataManager shareManager]

//数据库文件名
#define kFileName @"sqlit"

@interface GLCoreDataManager : NSObject

+ (instancetype)shareManager;

/**
 CoreData Stack  技术栈堆(CoreData核心),本质上是三个对象
 NSManagedObjectContext:管理对象上下文
 NSManagedObjectModel:对象模型
 NSPersistentStoreCoordinator:存储调度器
 */

//存储容器（内部封装了CoreData Stack）
@property (nonatomic, strong)NSPersistentContainer *persistentContainer;

@property (nonatomic, strong, readonly)NSManagedObjectContext *managedObjectContext;

- (void)save;

@end
