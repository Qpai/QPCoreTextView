//
//  QPMainVCCell.h
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/30.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPCoreTextView.h"
#import "QPMainDataModel.h"
@interface QPMainVCCell : UITableViewCell

@property (nonatomic,strong) QPCoreTextView *mainCoreTextView;


@property (nonatomic,strong,setter=setDataModel:) QPCoreTextData *dataModel;

+ (CGFloat)cellHeightWithAttributedString:(NSAttributedString *)attributeString;

@end
