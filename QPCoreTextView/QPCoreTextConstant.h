//
//  QPCoreTextConstant.h
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/25.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#ifndef CoreTextDemo_QPCoreTextConstant_h
#define CoreTextDemo_QPCoreTextConstant_h

typedef enum
{
    /**
     *  图片内容
     */
    QPCoreTextViewContentImage,
    /**
     *  连接
     */
    QPCoreTextViewContentURL,
    /**
     *  电话号码
     */
    QPCoreTextViewContentPhoneNumber,
    /**
     *  自定义内容
     */
    QPCoreTextViewContentCustom
} QPCoreTextViewContentType;


/**
 *  内部解析类型
 */
typedef NS_OPTIONS(NSUInteger, QPCoreTextViewContentInnerParserType){
    /**
     *  <#Description#>
     */
    QPCoreTextViewContentAutoParserLink = 0x01,
    /**
     *  <#Description#>
     */
    QPCoreTextViewContentAutoParserTelephone = 0x02
};

/**
 *  属性字符串的图片属性标示key
 */
#define QPCoreTextViewContentAttributeImageKey @"QPCoreTextViewContentAttributeImageKey"

/**
 *  存储style对象的key
 */
#define QPCoreTextViewContentAttributeStyleKey @"QPCoreTextViewContentAttributeStyleKey"

/**
 *  高级style链接的key
 */
#define QPCoreTextViewStyleSpecialKeyLink @"QPCoreTextViewStyleSpecialKeyLink"

/**
 *  高级style电话号码的key
 */
#define QPCoreTextViewStyleSpecialKeyTel @"QPCoreTextViewStyleSpecialKeyTel"
#endif
