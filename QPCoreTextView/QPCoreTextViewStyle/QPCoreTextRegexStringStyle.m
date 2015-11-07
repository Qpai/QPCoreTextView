//
//  QPCoreTextRegexStringStyle.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/29.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPCoreTextRegexStringStyle.h"
#import "QPCoreTextConstant.h"
@implementation QPCoreTextRegexStringStyle



- (instancetype)copyWithZone:(NSZone *)zone
{
    QPCoreTextRegexStringStyle *style = [[[self class] allocWithZone:zone] init];
    style.regexString = self.regexString;
    
    style.foregroundColorAttribute = [self.foregroundColorAttribute copy];
    style.textString =  [self.textString copy];
    style.fontAttribute = [self.fontAttribute copy];
    style.isShowUnderlineAttribute = self.isShowUnderlineAttribute;
    style.underlineColorAttribute = [self.underlineColorAttribute copy];
    style.backgroupColorAttribute = [self.backgroupColorAttribute copy];
    style.shadowAttribute = [self.shadowAttribute copy];
    style.specialKey = [self.specialKey copy];
    style.isEnableClick = self.isEnableClick;
    style.highLightColor = [self.highLightColor copy];

    return style;
}



/**
 *  快速生成链接对象
 *  [a-zA-z]+://[^\s]*
 *
 *  @param foregroupColor 前景色
 *
 *  @return 高级style对象
 */
+ (instancetype)linkRegexStyleWithForegroupColor:(UIColor *)foregroupColor
{
    QPCoreTextRegexStringStyle *style = [[QPCoreTextRegexStringStyle alloc] init];
    style.foregroundColorAttribute = foregroupColor;
    style.regexString = @"[a-zA-z]+://[^\\s]*";
    style.isShowUnderlineAttribute = YES;
    style.underlineColorAttribute = foregroupColor;
    style.specialKey = QPCoreTextViewStyleSpecialKeyLink;
    style.highLightColor = [UIColor grayColor];
    style.isEnableClick = YES;
    
    return style;
}


/**
 *  快速生成电话号码对象
 *  1[3|5|7|8|][0-9]{9}
 *
 *  @param foregroupColor 前景色
 *
 *  @return 高级style对象
 */
+ (instancetype)telephoneRegexStyleWithForegroupColor:(UIColor *)foregroupColor
{
    QPCoreTextRegexStringStyle *style = [[QPCoreTextRegexStringStyle alloc] init];
    style.foregroundColorAttribute = foregroupColor;
    style.regexString = @"1[3|5|7|8|][0-9]{9}";
    style.isShowUnderlineAttribute = YES;
    style.underlineColorAttribute = foregroupColor;
    style.specialKey = QPCoreTextViewStyleSpecialKeyTel;
    style.highLightColor = [UIColor grayColor];
    style.isEnableClick = YES;
    
    return style;
}
@end
