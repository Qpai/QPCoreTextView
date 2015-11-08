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
{
@protected
    NSString *_imageName;
    CGSize _imageSize;
}

@property (nonatomic,copy) NSString *imageName;

/**
 *  图片的size
 */
@property (nonatomic,assign,readonly) CGSize imageSize;

/**
 *  图片的Rect
 */
@property (nonatomic,assign) CGRect imageRect;



- (CTRunDelegateCallbacks)callbacks;



@end
