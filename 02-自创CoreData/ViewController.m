//
//  ViewController.m
//  02-自创CoreData
//
//  Created by 钟国龙 on 2017/3/16.
//  Copyright © 2017年 guolong. All rights reserved.
//

#import "ViewController.h"

#import "GLCoreDataManager.h"
#import "Student+CoreDataClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", NSHomeDirectory());
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    Student *s = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:kGLCoreDataManager.managedObjectContext];
    
    s.name = @"张三";
    
    [kGLCoreDataManager save];
}

@end
