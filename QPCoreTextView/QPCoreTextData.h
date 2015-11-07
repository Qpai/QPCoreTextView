//
//  QPCoreTextData.h
//  CoreTextDemo
//
//  QPCoreTextView 数据对象
//
//  应用于预加载过程，可以将这个对象序列化，缓存于本地，以提升显示效率
//
//
//
//  Created by Li Yi on 15/11/7.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPCoreTextData : NSObject<NSCoding>

/**
 *  可变属性字符串
 */
@property (nonatomic,copy) NSAttributedString *dataAttributedString;

/**
 *  视图size
 */
@property (nonatomic,copy) NSString *viewSize;

/**
 *  图片Run数组，用于预加载
 */
@property (nonatomic,copy) NSArray *imageRunArray;

/**
 *  高级style的range字典，用于预加载
 */
@property (nonatomic,copy) NSDictionary *seniorRangeDict;

@end
