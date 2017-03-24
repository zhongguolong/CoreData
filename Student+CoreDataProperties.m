//
//  Student+CoreDataProperties.m
//  02-自创CoreData
//
//  Created by 钟国龙 on 2017/3/16.
//  Copyright © 2017年 guolong. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Student"];
}

@dynamic name;

@end
