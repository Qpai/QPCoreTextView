//
//  QPCoreTextBaseStringStyle.h
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/29.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QPCoreTextBaseStringStyle : NSObject

/**
 *  字符串
 */
@property (nonatomic,copy) NSString *textString;

/**
 *  字体
 */
@property (nonatomic,strong) UIFont *fontAttribute;

/**
 *  前景色
 */
@property (nonatomic,strong) UIColor *foregroundColorAttribute;


/**
 *  是否显示下划线
 */
@property (nonatomic,assign) BOOL isShowUnderlineAttribute;

/**
 *  下划线颜色
 */
@property (nonatomic,strong) UIColor *underlineColorAttribute;

/**
 *  背景色
 */
@property (nonatomic,strong) UIColor *backgroupColorAttribute;

/**
 *  阴影
 */
@property (nonatomic,strong) NSShadow *shadowAttribute;
@end
