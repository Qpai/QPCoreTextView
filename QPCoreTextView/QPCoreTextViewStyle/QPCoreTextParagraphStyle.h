//
//  QPCoreTextParagraphStyle.h
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/29.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
@interface QPCoreTextParagraphStyle : NSObject

//@property (nonatomic,assign) CGFloat kCTRightTextAlignment
/**
 *  对齐方式
 */
@property (nonatomic,assign) CTTextAlignment textAlignment;

/**
 *  首行缩进
 */
@property (nonatomic,assign) CGFloat firstLineHeadIndent;

/**
 *  段缩进
 */
@property (nonatomic,assign) CGFloat headIndent;

/**
 *  段尾缩进
 */
@property (nonatomic,assign) CGFloat tailIndent;


//@property (nonatomic,copy) NSString *TabStopsAttribute;

/**
 *  换行模式
 */
@property (nonatomic,assign) CTLineBreakMode lineBreakMode;

/**
 *  多行高
 */
@property (nonatomic,assign) CGFloat LineHeightMultiple;

/**
 *  最大行高
 */
@property (nonatomic,assign) CGFloat maximumLineHeight;

/**
 *  最小行高
 */
@property (nonatomic,assign) CGFloat minimumLineHeight;
/**
 *  行距
 */
@property (nonatomic,assign) CGFloat lineSpacing;

/**
 *  段间距
 */
@property (nonatomic,assign) CGFloat paragraphSpacing;

/**
 *  段前间距
 */
@property (nonatomic,assign) CGFloat paragraphSpacingBefore;

/**
 *  书写方向
 */
@property (nonatomic,assign) CTWritingDirection writingDirection;

/**
 *  最大行间距
 */
@property (nonatomic,assign) CGFloat maximumLineSpacing;

/**
 *  最小行间距
 */
@property (nonatomic,assign) CGFloat minimumLineSpacing;


@property (nonatomic,assign) CGFloat lineSpacingAdjustment;


@property (nonatomic,assign) CTLineBoundsOptions lineBoundsOptions;
@end
