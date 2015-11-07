//
//  QPCoreTextSeniorStringStyle.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/29.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPCoreTextSeniorStringStyle.h"
#import "QPCoreTextConstant.h"
@implementation QPCoreTextSeniorStringStyle


/**
 *  快速生成链接对象
 *
 *  @param foregroupColor 前景色
 *  @param urlString    链接
 *  @return 高级style对象
 */
+ (instancetype)linkSeniorStyleWithForegroupColor:(UIColor *)foregroupColor urlString:(NSString *)urlString
{
    QPCoreTextSeniorStringStyle *style = [[QPCoreTextSeniorStringStyle alloc] init];
    style.foregroundColorAttribute = foregroupColor;
    style.textString = urlString;
    style.isShowUnderlineAttribute = YES;
    style.underlineColorAttribute = foregroupColor;
    style.specialKey = QPCoreTextViewStyleSpecialKeyLink;
    style.highLightColor = [UIColor grayColor];
    style.isEnableClick = YES;
    
    return style;
}


/**
 *  快速生成电话号码对象
 *
 *  @param foregroupColor 前景色
 *  @param telephoneString 电话号码
 *  @return 高级style对象
 */
+ (instancetype)telephoneSeniorStyleWithForegroupColor:(UIColor *)foregroupColor telephoneString:(NSString *)telephoneString
{
    QPCoreTextSeniorStringStyle *style = [[QPCoreTextSeniorStringStyle alloc] init];
    style.foregroundColorAttribute = foregroupColor;
    style.textString = telephoneString;
    style.isShowUnderlineAttribute = YES;
    style.underlineColorAttribute = foregroupColor;
    style.specialKey = QPCoreTextViewStyleSpecialKeyTel;
    style.highLightColor = [UIColor grayColor];
    style.isEnableClick = YES;
    
    return style;
}

@end
