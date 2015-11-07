//
//  QPCacheIntance.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/11/7.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPCacheIntance.h"

@implementation QPCacheIntance

+ (instancetype) share
{
    static QPCacheIntance *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        obj = [[QPCacheIntance alloc] init];
    });
    return obj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _array = [NSMutableArray array];
    }
    return self;
}

@end
