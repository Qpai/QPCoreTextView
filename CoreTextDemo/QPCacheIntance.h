//
//  QPCacheIntance.h
//  CoreTextDemo
//
//  Created by Li Yi on 15/11/7.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPCacheIntance : NSObject

@property (nonatomic,strong) NSMutableArray *array;

+ (instancetype) share;

@end
