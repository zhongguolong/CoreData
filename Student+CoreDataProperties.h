//
//  Student+CoreDataProperties.h
//  02-自创CoreData
//
//  Created by 钟国龙 on 2017/3/16.
//  Copyright © 2017年 guolong. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
