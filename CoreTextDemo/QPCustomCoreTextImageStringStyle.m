//
//  QPCustomCoreTextImageStringStyle.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/11/7.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPCustomCoreTextImageStringStyle.h"

@implementation QPCustomCoreTextImageStringStyle

static CGFloat RunDelegateGetAscentCallback( void *refCon ){
    
    return 29 - RunDelegateGetDescentCallback(refCon);
    
//    NSString *imageName = (__bridge NSString *)refCon;
//    UIImage *image = [UIImage imageNamed:imageName];
//    return image.size.height - RunDelegateGetDescentCallback(refCon);
}

static CGFloat RunDelegateGetDescentCallback(void *refCon){
    
    return 0;
}

static CGFloat RunDelegateGetWidthCallback(void *refCon){
    
    return 29;
//    NSString *imageName = (__bridge NSString *)refCon;
//    UIImage *image = [UIImage imageNamed:imageName];
//    return image.size.width + 2.f;
}



static void RunDelegateDeallocCallback( void* refCon ){
    
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



@end
