//
//  DetailViewController.h
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/25.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

