//
//  QPCoreTextSeniorStringStyle.h
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/29.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPCoreTextBaseStringStyle.h"

@interface QPCoreTextSeniorStringStyle : QPCoreTextBaseStringStyle


/**
 *  标示这是什么类型的字符串
 */
@property (nonatomic,copy) NSString *specialKey;

/**
 *  是否可以点击
 */
@property (nonatomic,assign) BOOL isEnableClick;

/**
 *  高亮颜色
 */
@property (nonatomic,strong) UIColor *highLightColor;

/**
 *  快速生成链接对象
 *
 *  @param foregroupColor 前景色
 *  @param urlString    链接
 *  @return 高级style对象
 */
+ (instancetype)linkSeniorStyleWithForegroupColor:(UIColor *)foregroupColor urlString:(NSString *)urlString;


/**
 *  快速生成电话号码对象
 *
 *  @param foregroupColor 前景色
 *  @param telephoneString 电话号码
 *  @return 高级style对象
 */
+ (instancetype)telephoneSeniorStyleWithForegroupColor:(UIColor *)foregroupColor telephoneString:(NSString *)telephoneString;
@end
