//
//  QPCoreTextView.h
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/25.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPCoreTextConstant.h"
#import "QPCoreTextSeniorStringStyle.h"
#import "QPCoreTextBaseStringStyle.h"
#import "QPCoreTextImageStringStyle.h"
#import "QPCoreTextParagraphStyle.h"
#import "QPCoreTextSeniorStringStyle.h"
#import "QPCoreTextRegexStringStyle.h"
#import "QPCoreTextData.h"
@class QPCoreTextView;

@protocol QPCoreTextViewDelegate <NSObject>

@optional

/**
 *  点击了富文本视图的其中一部分内容，仅包括链接和电话号码
 *
 *  @param coreTextView  当前富文本视图
 *  @param contentType   内容类型
 *  @param contentString 内容字符串
 */
- (void)coreTextView:(QPCoreTextView *)coreTextView selectWithContentType:(NSString *)contentType contentString:(NSString *)contentString;

@end

@interface QPCoreTextView : UIView

/**
 *  返回当前size
 */
@property (nonatomic,readonly) CGSize currentSize;

/**
 *  代理
 */
@property (nonatomic,weak) id<QPCoreTextViewDelegate> delegate;


/**
 *  构造函数，默认按照frame 截断内容
 *
 *  @param frame            frame
 *  @param attributedString 属性字符串
 *
 *  @return 富文本视图实例
 */
- (instancetype)initWithFrame:(CGRect)frame attributeString:(NSAttributedString *)attributedString;

/**
 *  根据CoreText数据对象重载富文本视图
 *
 *  @param coreTextData CoreText数据对象
 */
- (void)reloadWithCoreTextData:(QPCoreTextData *)coreTextData;

/**
 *  用正则表达式style进行替换，执行完这个之后，可以重新创建一个QPCoreTextData，用来reload
 *
 *  @param style 正则表达式style
 *
 */
- (void)replaceWithRegexStyle:(QPCoreTextRegexStringStyle *)regexStyle;



/**
 *  静态方法计算size
 *
 *  @param width            width description
 *  @param attributedString attributedString description
 *
 *  @return size
 */
+ (CGSize)contentSizeFromWidth:(CGFloat)width attributeString:(NSAttributedString *)attributedString;

/**
 *  append一个属性字符串，根据stringStyle
 *
 *  @param attributedString 原始属性字符串
 *  @param stringStyle      <#stringStyle description#>
 *
 *  @return 属性字符串
 */
+ (NSAttributedString *)appendAttributedString:(NSAttributedString *)attributedString withStringStyle:(QPCoreTextBaseStringStyle *)stringStyle;

/**
 *  append一个属性字符串，根据图片stringStyle
 *
 *  @param attributedString 原始属性字符串
 *  @param imageStringStyle 图片style对象
 *
 *  @return 属性字符串
 */
+ (NSAttributedString *)appendAttributedString:(NSAttributedString *)attributedString withImageStringStyle:(QPCoreTextImageStringStyle *)imageStringStyle;

/**
 *  append一个属性字符串，根据高级
 *
 *  @param attributedString  原始属性字符串
 *  @param seniorStringStyle 高级style对象
 *
 *  @return 属性字符串
 */
+ (NSAttributedString *)appendAttributedString:(NSAttributedString *)attributedString withSeniorStringStyle:(QPCoreTextSeniorStringStyle *)seniorStringStyle;

/**
 *  给一个属性字符串绑定段落设置
 *
 *  @param attributedString     原始属性字符串
 *  @param paragraphStringStyle 段落style对象
 *
 *  @return 属性字符串
 */
+ (NSAttributedString *)bindingParagraphSetting:(NSAttributedString *)attributedString withParagraphStringStyle:(QPCoreTextParagraphStyle *)paragraphStringStyle;


/**
 *  进行数据的显示预加载，强烈建议当富文本中存在链接，图片，电话，正则表达式匹配可点文本的时候进行显示数据预加载
 *
 *  传入的时候必须已经对dataAttributedString，及viewSize赋值，否则将预加载失败，无法提升显示速度
 *
 *  @param coreTextData coreText数据对象
 *
 *  @return coreText数据对象
 */
+ (QPCoreTextData *)preLoadCoreTextView:(QPCoreTextData *)coreTextData;
@end
