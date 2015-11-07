//
//  QPCoreTextView.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/25.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPCoreTextView.h"
#import <CoreText/CoreText.h>
#import "QPCoreTextImageStringStyle.h"
@interface QPCoreTextView()

@property (nonatomic,readwrite) CGSize currentSize;

/**
 *  当前属性字符串
 */
@property (nonatomic,strong,readwrite) NSAttributedString *mainAttributeString;

/**
 *  图片的CTRunRef数组
 */
@property (nonatomic,strong) NSMutableArray *imageRunArray;

/**
 *  senior range dict
 */
@property (nonatomic,strong) NSMutableDictionary *seniorRangeDict;

/**
 *  选中的range
 */
@property (nonatomic,strong) NSString *selectedRangeString;



@end


@implementation QPCoreTextView

- (instancetype)initWithFrame:(CGRect)frame attributeString:(NSAttributedString *)attributedString
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _mainAttributeString = attributedString;
        _currentSize = frame.size;
        _imageRunArray = [NSMutableArray array];
        _seniorRangeDict = [NSMutableDictionary dictionary];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self doInitAttribute];
    }
    
    return self;
}



- (void)dealloc
{
    [_imageRunArray removeAllObjects];
    [_seniorRangeDict removeAllObjects];
    _selectedRangeString = nil;
    _mainAttributeString  = nil;
}


#pragma mark instance methods


/**
 *  根据CoreText数据对象重载富文本视图
 *
 *  @param coreTextData CoreText数据对象
 */
- (void)reloadWithCoreTextData:(QPCoreTextData *)coreTextData
{
    CGSize contentSize = CGSizeFromString(coreTextData.viewSize);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, contentSize.width, contentSize.height);
    
    _mainAttributeString = coreTextData.dataAttributedString;
    _currentSize = contentSize;
    
    [_imageRunArray removeAllObjects];
    _selectedRangeString = nil;
    [_seniorRangeDict removeAllObjects];
    
    
    if (!coreTextData.imageRunArray && !coreTextData.seniorRangeDict) {
        coreTextData = [[self class] preLoadCoreTextView:coreTextData];
    }
    
    if (coreTextData.imageRunArray) {
        [_imageRunArray addObjectsFromArray:coreTextData.imageRunArray];
    }
    
    if (coreTextData.seniorRangeDict) {
        [_seniorRangeDict addEntriesFromDictionary:coreTextData.seniorRangeDict];
    }
    
    
    [self setNeedsDisplay];
    
}




- (void)replaceWithRegexStyle:(QPCoreTextRegexStringStyle *)regexStyle
{
    
    if (regexStyle == nil || regexStyle.regexString == nil || regexStyle.regexString.length == 0) {
        return;
    }
    
    NSString *textString = self.mainAttributeString.string;
    
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStyle.regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *rangeArray = [regex matchesInString:textString options:0 range:NSMakeRange(0, [textString length])];
    
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.mainAttributeString];
    
    
    for (NSTextCheckingResult *rangeResult in rangeArray) {
        
        NSRange appStringRange = rangeResult.range;
        
        
        mutableAttributedString = [[self class] addAttributed:mutableAttributedString withBaseStyle:regexStyle range:appStringRange];
        
        
        if (regexStyle.isEnableClick) {
            
            if (!regexStyle.specialKey) {
                [NSException raise:NSInvalidArgumentException format:@"QPCoreTextSeniorStringStyle 's specialKey should be not nil"];
            }
            
            
        }
        
        
        NSString *regexTextString = [mutableAttributedString.string substringWithRange:appStringRange];
        
        QPCoreTextRegexStringStyle *tempRegexStyle = [regexStyle copy];
        
        // 设置正则表达式解析出来的字符串
        tempRegexStyle.textString = regexTextString;
        
        [mutableAttributedString addAttribute:QPCoreTextViewContentAttributeStyleKey value:tempRegexStyle range:appStringRange];
        

        
    }
    
    self.mainAttributeString = [[NSAttributedString alloc] initWithAttributedString:mutableAttributedString];
    
    [_imageRunArray removeAllObjects];
    _selectedRangeString = nil;
    [_seniorRangeDict removeAllObjects];
    
    [self doInitAttribute];
}

#pragma mark class methods

/**
 *  静态方法计算size
 *
 *  @param width            width description
 *  @param attributedString attributedString description
 *
 *  @return size
 */
+ (CGSize)contentSizeFromWidth:(CGFloat)width attributeString:(NSAttributedString *)attributedString
{
    return [QPCoreTextView contentSizeFromWidth:width attributeString:attributedString breakLineNum:0];
}

/**
 *  静态方法计算size
 *
 *  @param width            指定宽度
 *  @param attributedString 属性字符串
 *  @param breakLineNum     限定行数，行数为0的时候，则不限制行数
 *
 *  @return size
 */
+ (CGSize)contentSizeFromWidth:(CGFloat)width attributeString:(NSAttributedString *)attributedString breakLineNum:(NSInteger)breakLineNum
{
    
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((__bridge CFMutableAttributedStringRef)attributedString);
    
    // 创建绘制路径
    CGMutablePathRef textPathRef = CGPathCreateMutable();
    CGPathAddRect(textPathRef, NULL, CGRectMake(0, 0, width, CGFLOAT_MAX));
    
    // 回收绘制路径
    CGPathRelease(textPathRef);
    
    CGSize constraitSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0, attributedString.length), NULL, CGRectMake(0, 0, width, CGFLOAT_MAX).size, NULL);

    CFRelease(frameSetterRef);
    
    return constraitSize;
    
}

/**
 *  静态方法计算size
 *
 *  @param height           指定高度
 *  @param attributedString 属性字符串
 *
 *  @return size
 */
+ (CGSize)contentSizeFromHeight:(CGFloat)height attributeString:(NSAttributedString *)attributedString
{
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((__bridge CFMutableAttributedStringRef)attributedString);
    
    // 创建绘制路径
    CGMutablePathRef textPathRef = CGPathCreateMutable();
    CGPathAddRect(textPathRef, NULL, CGRectMake(0, 0, CGFLOAT_MAX, height));

    // 回收绘制路径
    CGPathRelease(textPathRef);
    
    CGSize constraitSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0, attributedString.length), NULL, CGRectMake(0, 0, CGFLOAT_MAX, height).size, NULL);
    
    CFRelease(frameSetterRef);
    
    return constraitSize;

    
    
}


+ (NSAttributedString *)appendAttributedString:(NSAttributedString *)attributedString withStringStyle:(QPCoreTextBaseStringStyle *)stringStyle
{
    
    if (!stringStyle) {
        return attributedString;
    }
    
    if(attributedString == nil)
    {
        attributedString = [[NSAttributedString alloc] init];
    }
    
    NSMutableAttributedString *mutableAttrbutedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    
    
    
    if ([stringStyle.textString isEqualToString:@""] || stringStyle.textString.length == 0) {
        return attributedString;
    }
   
    NSMutableAttributedString *appendAttributedString = [[NSMutableAttributedString alloc] initWithString:stringStyle.textString];
    
    NSRange appStringRange = NSMakeRange(0, stringStyle.textString.length);
    
    
    appendAttributedString = [[self class] addAttributed:appendAttributedString withBaseStyle:stringStyle range:appStringRange];
    
    
    [appendAttributedString addAttribute:QPCoreTextViewContentAttributeStyleKey value:stringStyle range:appStringRange];
    
    
    [mutableAttrbutedString appendAttributedString:appendAttributedString];
    
    return [[NSAttributedString alloc] initWithAttributedString:mutableAttrbutedString];
}


+ (NSAttributedString *)appendAttributedString:(NSAttributedString *)attributedString withImageStringStyle:(QPCoreTextImageStringStyle *)imageStringStyle
{
    if (!imageStringStyle) {
        return attributedString;
    }
    
    if (!attributedString) {
        attributedString = [[NSAttributedString alloc] init];
    }
    
    
     NSMutableAttributedString *mutableAttrbutedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    unichar objectReplacementChar = 0xFFFC;
    NSString * objectReplacementString = [NSString stringWithCharacters:&objectReplacementChar length:1];
    
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:objectReplacementString];//空格用于给图片留位置
    
    CTRunDelegateCallbacks callBacks = [imageStringStyle callbacks];
    CTRunDelegateRef delegateRef = CTRunDelegateCreate(&callBacks, (__bridge void *)(imageStringStyle.imageName));
    
    
    
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)delegateRef range:NSMakeRange(0, 1)];
    
    
    [imageAttributedString addAttribute:QPCoreTextViewContentAttributeImageKey value:imageStringStyle range:NSMakeRange(0, 1)];
    [mutableAttrbutedString appendAttributedString:imageAttributedString];
    
    return [[NSAttributedString alloc] initWithAttributedString:mutableAttrbutedString];
}


+ (NSAttributedString *)appendAttributedString:(NSAttributedString *)attributedString withSeniorStringStyle:(QPCoreTextSeniorStringStyle *)seniorStringStyle
{
    
    
    
    
    if (!seniorStringStyle) {
        return attributedString;
    }
    
    if (!attributedString) {
        attributedString = [[NSAttributedString alloc] init];
    }
    
    NSMutableAttributedString *mutableAttrbutedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    if ([seniorStringStyle.textString isEqualToString:@""] || seniorStringStyle.textString.length == 0) {
        return attributedString;
    }
    
    NSMutableAttributedString *appendAttributedString = [[NSMutableAttributedString alloc] initWithString:seniorStringStyle.textString];
    
    NSRange appStringRange = NSMakeRange(0, seniorStringStyle.textString.length);
    
    appendAttributedString = [[self class] addAttributed:appendAttributedString withBaseStyle:seniorStringStyle range:appStringRange];
    
    
    if (seniorStringStyle.isEnableClick) {
        
        if (!seniorStringStyle.specialKey) {
            [NSException raise:NSInvalidArgumentException format:@"QPCoreTextSeniorStringStyle 's specialKey should be not nil"];
        }
        
        
    }
    [appendAttributedString addAttribute:QPCoreTextViewContentAttributeStyleKey value:seniorStringStyle range:appStringRange];
    
    [mutableAttrbutedString appendAttributedString:appendAttributedString];
    
    return [[NSAttributedString alloc] initWithAttributedString:mutableAttrbutedString];
}

+ (NSAttributedString *)bindingParagraphSetting:(NSAttributedString *)attributedString withParagraphStringStyle:(QPCoreTextParagraphStyle *)paragraphStringStyle
{
    if (!attributedString) {
        return nil;
    }
    
    if (!paragraphStringStyle) {
        return attributedString;
    }
    
    CTParagraphStyleSetting settings[16];
    
#define QPParagraphBingSetting(_value,attribute,type,index) \
        type _tempValue_##index = _value;   \
        CTParagraphStyleSetting paragraphSetting_##index ;   \
        paragraphSetting_##index.spec = attribute;  \
        paragraphSetting_##index.value =    &_tempValue_##index;    \
        paragraphSetting_##index.valueSize = sizeof(type);  \
        settings[index] = paragraphSetting_##index; \
    
    
    
    
        QPParagraphBingSetting(paragraphStringStyle.textAlignment, kCTParagraphStyleSpecifierAlignment,CTTextAlignment,0)
        QPParagraphBingSetting(paragraphStringStyle.firstLineHeadIndent, kCTParagraphStyleSpecifierFirstLineHeadIndent, CGFloat,1)
        QPParagraphBingSetting(paragraphStringStyle.headIndent, kCTParagraphStyleSpecifierHeadIndent, CGFloat,2)
        QPParagraphBingSetting(paragraphStringStyle.tailIndent, kCTParagraphStyleSpecifierTailIndent, CGFloat,3)
        QPParagraphBingSetting(paragraphStringStyle.lineBreakMode, kCTParagraphStyleSpecifierLineBreakMode, CTLineBreakMode,4)
        QPParagraphBingSetting(paragraphStringStyle.LineHeightMultiple, kCTParagraphStyleSpecifierLineHeightMultiple, CGFloat,5)
        QPParagraphBingSetting(paragraphStringStyle.maximumLineHeight, kCTParagraphStyleSpecifierMaximumLineHeight, CGFloat,6)
        QPParagraphBingSetting(paragraphStringStyle.minimumLineHeight, kCTParagraphStyleSpecifierMinimumLineHeight, CGFloat,7)
        QPParagraphBingSetting(paragraphStringStyle.lineSpacing,     kCTParagraphStyleSpecifierLineSpacing, CGFloat,8)
        QPParagraphBingSetting(paragraphStringStyle.paragraphSpacing, kCTParagraphStyleSpecifierParagraphSpacing, CGFloat,9)
        QPParagraphBingSetting(paragraphStringStyle.paragraphSpacingBefore, kCTParagraphStyleSpecifierParagraphSpacingBefore, CGFloat,10)
        QPParagraphBingSetting(paragraphStringStyle.writingDirection, kCTParagraphStyleSpecifierBaseWritingDirection, CTWritingDirection,11)
        QPParagraphBingSetting(paragraphStringStyle.maximumLineSpacing, kCTParagraphStyleSpecifierMaximumLineSpacing, CGFloat,12)
        QPParagraphBingSetting(paragraphStringStyle.minimumLineSpacing, kCTParagraphStyleSpecifierMinimumLineSpacing, CGFloat,13)
        QPParagraphBingSetting(paragraphStringStyle.lineSpacingAdjustment, kCTParagraphStyleSpecifierLineSpacingAdjustment, CGFloat,14)
        QPParagraphBingSetting(paragraphStringStyle.lineBoundsOptions, kCTParagraphStyleSpecifierLineBoundsOptions, CTLineBoundsOptions,15)
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 16);

    NSMutableAttributedString *mutableAttrbutedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    [mutableAttrbutedString addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0, attributedString.length)];
    
    CFRelease(style);
    return [[NSAttributedString alloc] initWithAttributedString:mutableAttrbutedString];
}


+ (QPCoreTextData *)preLoadCoreTextView:(QPCoreTextData *)coreTextData
{
    if (coreTextData == nil) {
        return nil;
    }
    
    // 这两个属性不能为nil
    if (!coreTextData.dataAttributedString || !coreTextData.viewSize) {
        return coreTextData;
    }
    
    CGSize currentSize = CGSizeFromString(coreTextData.viewSize);
    NSMutableArray *imageRunArray = [NSMutableArray array];
    NSMutableDictionary *seniorRangeDict = [NSMutableDictionary dictionary];
    
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((__bridge CFMutableAttributedStringRef)coreTextData.dataAttributedString);
    
    // 创建绘制路径
    CGMutablePathRef textPathRef = CGPathCreateMutable();
    CGPathAddRect(textPathRef, NULL, CGRectMake(0, 0, currentSize.width,currentSize.height));
    
    
    
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0,0), textPathRef, NULL);
    
    CFArrayRef lineArrayRef = CTFrameGetLines(frameRef);
    CGPoint lineOrigins[CFArrayGetCount(lineArrayRef)];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    CFIndex lineNum = CFArrayGetCount(lineArrayRef);
    
    
    
    for(int index = 0 ; index < lineNum ; index ++)
    {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineArrayRef, index);
        
        
        
        CFArrayRef runArrayRef = CTLineGetGlyphRuns(lineRef);
        CFIndex runNum = CFArrayGetCount(runArrayRef);
        
        // 行的起始点
        CGPoint lineOriginPoint = lineOrigins[index];
        
        
        
        for(int runIndex = 0; runIndex < runNum ; runIndex++)
        {
            CTRunRef runRef = CFArrayGetValueAtIndex(runArrayRef, runIndex);
            
            CGFloat runAscent;
            CGFloat runDescent;
            CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            
            
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(runRef);
            QPCoreTextImageStringStyle *imageStyle = [attributes objectForKey:QPCoreTextViewContentAttributeImageKey];
            if(imageStyle)
            {

                [imageRunArray addObject:(__bridge id)(runRef)];
                
                
                
                CFRange range = CTRunGetStringRange(runRef);
                // 该行起始点到runRef的起始点的距离
                CGFloat offsetX = CTLineGetOffsetForStringIndex(lineRef, range.location, NULL);
                
                
                imageStyle.imageRect = CGRectMake(lineOriginPoint.x + offsetX, lineOriginPoint.y - runDescent, imageStyle.imageSize.width, imageStyle.imageSize.height);
            }
            
            QPCoreTextSeniorStringStyle *seniorStyle = [attributes objectForKey:QPCoreTextViewContentAttributeStyleKey];
            if (seniorStyle && [[seniorStyle class] isSubclassOfClass:[QPCoreTextSeniorStringStyle class]]) {
                
                if (seniorStyle.isEnableClick) {
                    CFRange range = CTRunGetStringRange(runRef);
                    
                    BOOL isSeniorRangeDictContain = NO;
                    
                    for (NSString *rangeKey in seniorRangeDict) {
                        
                        NSRange seniorRange = NSRangeFromString(rangeKey);
                        if (range.location >=  seniorRange.location && range.location <= seniorRange.location + seniorRange.length ) {
                            isSeniorRangeDictContain = YES;
                            break;
                        }
                        
                    }
                    if (isSeniorRangeDictContain == NO) {
                        [seniorRangeDict setObject:seniorStyle forKey:NSStringFromRange(NSMakeRange(range.location, seniorStyle.textString.length))];
                    }
                    
                }
                
            }
            
            
            
        }
    }
    
    
    // 回收绘制路径
    CGPathRelease(textPathRef);
    CFRelease(frameRef);
    CFRelease(frameSetterRef);
    
    coreTextData.seniorRangeDict = [NSDictionary dictionaryWithDictionary:seniorRangeDict];
    coreTextData.imageRunArray = [NSArray arrayWithArray:imageRunArray];
    
    return coreTextData;
    
}

#pragma mark private methods

/**
 *  给文本添加BaseStyle属性
 *
 *  @param attributedString 属性字符串
 *  @param baseStyle        style对象
 *  @param range            范围
 *
 *  @return <#return value description#>
 */
+ (NSMutableAttributedString *)addAttributed:(NSMutableAttributedString *)attributedString withBaseStyle:(QPCoreTextBaseStringStyle *)baseStyle range:(NSRange)range
{
    if (baseStyle.fontAttribute) {
        [attributedString addAttribute:(NSString *)kCTFontAttributeName value:baseStyle.fontAttribute range:range];
    }
    
    if (baseStyle.foregroundColorAttribute) {
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)baseStyle.foregroundColorAttribute.CGColor range:range];
    }
    
    if (baseStyle.isShowUnderlineAttribute && baseStyle.underlineColorAttribute) {
        [attributedString addAttribute:(NSString *)kCTUnderlineColorAttributeName value:(id)baseStyle.underlineColorAttribute.CGColor range:range];
        [attributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:range];
    }
    
    if (baseStyle.backgroupColorAttribute) {
        [attributedString addAttribute:(NSString *)NSBackgroundColorAttributeName value:(id)baseStyle.backgroupColorAttribute range:range];
    }
    
    if (baseStyle.shadowAttribute) {
        [attributedString addAttribute:(NSString *)NSShadowAttributeName value:baseStyle.shadowAttribute range:range];
    }
    
    return attributedString;
}


- (void)doInitAttribute
{
    
    QPCoreTextData *data = [[QPCoreTextData alloc] init];
    data.dataAttributedString = _mainAttributeString;
    data.viewSize = NSStringFromCGSize(self.frame.size);
    
    data = [[self class] preLoadCoreTextView:data];
    
    [self reloadWithCoreTextData:data];
    
    
    if (!_mainAttributeString) {
        return;
    }
    
    return;
    
    
//    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_mainAttributeString);
//    
//    // 创建绘制路径
//    CGMutablePathRef textPathRef = CGPathCreateMutable();
//    CGPathAddRect(textPathRef, NULL, CGRectMake(0, 0, self.currentSize.width,self.currentSize.height));
//    
//    
//
//    
//    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0,0), textPathRef, NULL);
//    
//    CFArrayRef lineArrayRef = CTFrameGetLines(frameRef);
//    CGPoint lineOrigins[CFArrayGetCount(lineArrayRef)];
//    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
//    CFIndex lineNum = CFArrayGetCount(lineArrayRef);
//    
//    
//    
//    for(int index = 0 ; index < lineNum ; index ++)
//    {
//        CTLineRef lineRef = CFArrayGetValueAtIndex(lineArrayRef, index);
//        
//        
//        
//        CFArrayRef runArrayRef = CTLineGetGlyphRuns(lineRef);
//        CFIndex runNum = CFArrayGetCount(runArrayRef);
//        
//        CGPoint lineOriginPoint = lineOrigins[index];
//        
//        
//        
//        for(int runIndex = 0; runIndex < runNum ; runIndex++)
//        {
//            CTRunRef runRef = CFArrayGetValueAtIndex(runArrayRef, runIndex);
//            
//            CGFloat runAscent;
//            CGFloat runDescent;
//            CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
//            
//            
//            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(runRef);
//            QPCoreTextImageStringStyle *imageStyle = [attributes objectForKey:QPCoreTextViewContentAttributeImageKey];
//            if(imageStyle)
//            {
//                imageStyle.lineRef = lineRef;
//                imageStyle.linePoint = lineOriginPoint;
//                [self.imageRunArray addObject:(__bridge id)(runRef)];
//                
//                
//                
//                CFRange range = CTRunGetStringRange(runRef);
//                CGFloat offsetX = CTLineGetOffsetForStringIndex(imageStyle.lineRef, range.location, NULL);
//                
//                imageStyle.offsetFromLineOriginX = offsetX;
//                imageStyle.imageDescent = runDescent;
//                imageStyle.imageRect = CGRectMake(imageStyle.linePoint.x + imageStyle.offsetFromLineOriginX, imageStyle.linePoint.y - imageStyle.imageDescent, imageStyle.imageSize.width, imageStyle.imageSize.height);
//            }
//            
//            QPCoreTextSeniorStringStyle *seniorStyle = [attributes objectForKey:QPCoreTextViewContentAttributeStyleKey];
//            if (seniorStyle && [[seniorStyle class] isSubclassOfClass:[QPCoreTextSeniorStringStyle class]]) {
//                
//                if (seniorStyle.isEnableClick) {
//                    CFRange range = CTRunGetStringRange(runRef);
//                    
//                    BOOL isSeniorRangeDictContain = NO;
//                    
//                    for (NSString *rangeKey in _seniorRangeDict) {
//                        
//                        NSRange seniorRange = NSRangeFromString(rangeKey);
//                        if (range.location >=  seniorRange.location && range.location <= seniorRange.location + seniorRange.length ) {
//                            isSeniorRangeDictContain = YES;
//                            break;
//                        }
//                        
//                    }
//                    if (isSeniorRangeDictContain == NO) {
//                        [_seniorRangeDict setObject:seniorStyle forKey:NSStringFromRange(NSMakeRange(range.location, seniorStyle.textString.length))];
//                    }
//                    
//                }
//                
//            }
//            
//            
//            
//        }
//    }
//    
//    
//    // 回收绘制路径
//    CGPathRelease(textPathRef);
//    CFRelease(frameRef);
//    
//    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect
{
    
    NSLog(@"drawRect start %f %@" ,self.frame.size.height, self.mainAttributeString.string);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);
    
    
    
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self.mainAttributeString);

    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect bounds = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    
    CTFrameDraw(ctFrame, context);
    
    
    for(int i = 0 ; i < [self.imageRunArray count] ;i++)
    {
        CTRunRef runRef = (__bridge CTRunRef)(self.imageRunArray[i]);
        NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(runRef);
        QPCoreTextImageStringStyle *imageStyle = [attributes objectForKey:QPCoreTextViewContentAttributeImageKey];
        UIImage *img = [UIImage imageNamed:imageStyle.imageName];
        CGContextDrawImage(context, imageStyle.imageRect, img.CGImage);
    }
    
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(ctFramesetter);
    
    
    [super drawRect:rect];
    
    NSLog(@"drawRect end %f %@",self.frame.size.height , self.mainAttributeString.string);
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch  locationInView:self];
    
    
    
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((__bridge CFMutableAttributedStringRef)_mainAttributeString);
    
    // 创建绘制路径
    CGMutablePathRef textPathRef = CGPathCreateMutable();
    CGPathAddRect(textPathRef, NULL, CGRectMake(0, 0, self.currentSize.width,self.currentSize.height));
    
    
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0,0), textPathRef, NULL);
    
    CFArrayRef lineArrayRef = CTFrameGetLines(frameRef);
    CGPoint lineOrigins[CFArrayGetCount(lineArrayRef)];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    CFIndex lineNum = CFArrayGetCount(lineArrayRef);
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    
    for(int index = 0 ; index < lineNum ; index ++)
    {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineArrayRef, index);
        
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CGFloat lineWidth = CTLineGetTypographicBounds(lineRef,&ascent,&descent,&leading);
        
        CGPoint lineOriginPoint = lineOrigins[index];
        
        CGRect lineRect = CGRectMake(lineOriginPoint.x,lineOriginPoint.y, lineWidth, ascent+descent+leading);
        
        lineRect = CGRectApplyAffineTransform(lineRect,transform);
        
        if (CGRectContainsPoint(lineRect, point)) {
            
//            CFRange lineRange = CTLineGetStringRange(lineRef);
            
            CFArrayRef runArrayRef = CTLineGetGlyphRuns(lineRef);
            CFIndex runNum = CFArrayGetCount(runArrayRef);
            
            CGPoint lineOriginPoint = lineOrigins[index];
            
            
            
            for(int runIndex = 0; runIndex < runNum ; runIndex++)
            {
                
                CTRunRef runRef = CFArrayGetValueAtIndex(runArrayRef, runIndex);
                CGFloat runAscent;
                CGFloat runDescent;
                CGFloat runLeading;
                CGFloat runWidth = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, &runLeading);
                
                
                CFRange runRange = CTRunGetStringRange(runRef);
                CGFloat offsetX = CTLineGetOffsetForStringIndex(lineRef, runRange.location, NULL);
                
                CGRect runRect = CGRectMake(lineOriginPoint.x + offsetX,lineOriginPoint.y - runDescent, runWidth, runAscent + runDescent + runLeading);
                
                runRect = CGRectApplyAffineTransform(runRect,transform);
                
                if (CGRectContainsPoint(runRect, point)) {
                    
                    CFIndex rangeLocationPointInView = runRange.location;
                    
                    for (NSString *rangeKey in [_seniorRangeDict allKeys]) {
                        
                        NSRange rangeSenior = NSRangeFromString(rangeKey);
                        
                        if (rangeLocationPointInView >= rangeSenior.location && rangeLocationPointInView <= rangeSenior.location + rangeSenior.length) {
                            
                            self.selectedRangeString = rangeKey;
                            
                            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.mainAttributeString];
                            
                            QPCoreTextSeniorStringStyle *seniorStringStyle = [_seniorRangeDict objectForKey:rangeKey];
                            
                            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:seniorStringStyle.highLightColor range:rangeSenior];
                            
                            self.mainAttributeString = [[NSAttributedString alloc] initWithAttributedString:mutableAttributedString];
                            [self setNeedsDisplay];
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
        
    }
    
    CFRelease(frameSetterRef);
    CFRelease(frameRef);
    CGPathRelease(textPathRef);
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_selectedRangeString) {
        
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.mainAttributeString];
        
        QPCoreTextSeniorStringStyle *seniorStringStyle = [_seniorRangeDict objectForKey:self.selectedRangeString];
        
        NSRange rangeSenior = NSRangeFromString(self.selectedRangeString);
        
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:seniorStringStyle.foregroundColorAttribute range:rangeSenior];
        
        self.mainAttributeString = [[NSAttributedString alloc] initWithAttributedString:mutableAttributedString];
        
        self.selectedRangeString = nil;
        [self setNeedsDisplay];
        
        if (self.delegate) {
            [self.delegate coreTextView:self selectWithContentType:seniorStringStyle.specialKey contentString:seniorStringStyle.textString];
        }
        
    }
}
@end
