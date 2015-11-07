//
//  QPCoreTextParagraphStyle.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/29.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPCoreTextParagraphStyle.h"

@implementation QPCoreTextParagraphStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _textAlignment = kCTTextAlignmentNatural;
    }
    
    return self;
}

@end
