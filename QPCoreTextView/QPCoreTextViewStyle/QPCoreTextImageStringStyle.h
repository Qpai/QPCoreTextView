//
//  QPCoreTextImageStringStyle.h
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/27.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
@interface QPCoreTextImageStringStyle : NSObject

@property (nonatomic,copy) NSString *imageName;

/**
 *  图片所在的行
 */
//@property (nonatomic,assign) CTLineRef lineRef;


/**
 *  图片所在的行开始的点位
 */
//@property (nonatomic,assign) CGPoint linePoint;

/**
 *  图片的size
 */
@property (nonatomic,assign,readonly) CGSize imageSize;

/**
 *  图片在当前lineRef中的下行
 */
//@property (nonatomic,assign) CGFloat imageDescent;

/**
 *  相对于当前lineRef起始点的偏移量
 */
//@property (nonatomic,assign) CGFloat offsetFromLineOriginX;

/**
 *  图片的Rect
 */
@property (nonatomic,assign) CGRect imageRect;



- (CTRunDelegateCallbacks)callbacks;



@end
