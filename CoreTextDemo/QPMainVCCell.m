//
//  QPMainVCCell.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/30.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPMainVCCell.h"

@implementation QPMainVCCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, screenSize.width,self.frame.size.height);
        
        [self setupView];
    }
    return self;
}


- (void)setupView
{
    self.mainCoreTextView = [[QPCoreTextView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10) attributeString:nil];
    [self addSubview:self.mainCoreTextView];
    self.mainCoreTextView.layer.borderWidth = 1;
}


+ (CGFloat)cellHeightWithAttributedString:(NSAttributedString *)attributeString
{
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGSize contentSize = [QPCoreTextView contentSizeFromWidth:screenSize.width - 10 attributeString:attributeString];
    
    return contentSize.height + 10;
}

- (void)setDataModel:(QPCoreTextData *)dataModel
{
    _dataModel = dataModel;

//    CGSize size = CGSizeFromString(dataModel.viewSize);
//    
//    CGRect contentFrame = CGRectMake(_mainCoreTextView.frame.origin.x,_mainCoreTextView.frame.origin.y,self.frame.size.width - 10, size.height);
    
//    [_mainCoreTextView reloadWithAttributedString:dataModel.dataAttributedString viewFrame:contentFrame];
    
    [_mainCoreTextView reloadWithCoreTextData:dataModel];
    
}

@end
