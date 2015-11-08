//
//  QPCoreTextImageStringStyle.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/27.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPCoreTextImageStringStyle.h"
#import <UIKit/UIKit.h>


@interface QPCoreTextImageStringStyle()

@property (nonatomic,assign,readwrite) CGSize imageSize;

@end



@implementation QPCoreTextImageStringStyle
@synthesize imageName = _imageName;
@synthesize imageSize = _imageSize;


static void RunDelegateDeallocCallback( void* refCon ){
    
}

static CGFloat RunDelegateGetAscentCallback( void *refCon ){
    
    NSString *imageName = (__bridge NSString *)refCon;
    UIImage *image = [UIImage imageNamed:imageName];
    return image.size.height - RunDelegateGetDescentCallback(refCon);
}

static CGFloat RunDelegateGetDescentCallback(void *refCon){
    
    return 0;
}

static CGFloat RunDelegateGetWidthCallback(void *refCon){
    
    NSString *imageName = (__bridge NSString *)refCon;
    UIImage *image = [UIImage imageNamed:imageName];
    return image.size.width + 2.f;
}

- (CTRunDelegateCallbacks)callbacks
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = RunDelegateDeallocCallback;
    callbacks.getAscent = RunDelegateGetAscentCallback;
    callbacks.getDescent = RunDelegateGetDescentCallback;
    callbacks.getWidth = RunDelegateGetWidthCallback;
    
    return callbacks;
}


- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    _imageSize = image.size;
}

//- (void)setLineRef:(CTLineRef)lineRef
//{
//    _lineRef = CFRetain(lineRef);
//}



@end
