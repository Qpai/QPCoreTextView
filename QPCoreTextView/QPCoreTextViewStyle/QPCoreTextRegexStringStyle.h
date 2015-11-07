//
//  QPCoreTextRegexStringStyle.h
//  CoreTextDemo
//  正则表达式style
//  Created by Li Yi on 15/9/29.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPCoreTextSeniorStringStyle.h"

@interface QPCoreTextRegexStringStyle : QPCoreTextSeniorStringStyle<NSCopying>

/**
 *  正则表达式
 */
@property (nonatomic,copy) NSString *regexString;


/**
 *  快速生成链接对象
 *  [a-zA-z]+://[^\s]*
 *  @param foregroupColor 前景色
 *
 *  @return 高级style对象
 */
+ (instancetype)linkRegexStyleWithForegroupColor:(UIColor *)foregroupColor;


/**
 *  快速生成电话号码对象
 *  1[3|5|7|8|][0-9]{9}
 *  @param foregroupColor 前景色
 *
 *  @return 高级style对象
 */
+ (instancetype)telephoneRegexStyleWithForegroupColor:(UIColor *)foregroupColor;
@end
