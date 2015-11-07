//
//  MYMainViewController.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/30.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPListViewController.h"
#import "QPMainVCCell.h"
#import "QPMainDataModel.h"
#import "QPCacheIntance.h"
#import "QPCustomCoreTextImageStringStyle.h"
@interface QPListViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation QPListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupData];
    
//    [self setupTableView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"列表示例";
}

- (void)setupData
{
    self.dataArray = [NSMutableArray array];
    
    if ([QPCacheIntance share].array && [[QPCacheIntance share].array count] > 0) {
        [self.dataArray addObjectsFromArray:[QPCacheIntance share].array];
        [self setupTableView];
        return;
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
        NSArray *emojiArray = [NSArray arrayWithContentsOfFile:plistPath];
        
        for (int i = 0; i < 50; i++) {
            
            QPCoreTextBaseStringStyle *textStyle = [[QPCoreTextBaseStringStyle alloc] init];
            textStyle.foregroundColorAttribute = [UIColor greenColor];
            textStyle.textString = @"你好吗你ssssssssss好吗你好吗你好吗HHHHH你好吗??????????";
            
            NSAttributedString *attr = [QPCoreTextView appendAttributedString:nil withStringStyle:textStyle];
            
            QPCoreTextImageStringStyle *imageStyle = [[QPCoreTextImageStringStyle alloc] init];
            imageStyle.imageName = @"001[憨笑]";
            
            attr = [QPCoreTextView appendAttributedString:attr withImageStringStyle:imageStyle];
            
            QPCoreTextBaseStringStyle *textStyle1 = [[QPCoreTextBaseStringStyle alloc] init];
            textStyle1.foregroundColorAttribute = [UIColor orangeColor];
            textStyle1.textString = @"321321321312";
            textStyle1.isShowUnderlineAttribute = YES;
            textStyle1.underlineColorAttribute = [UIColor whiteColor];
            attr = [QPCoreTextView appendAttributedString:attr withStringStyle:textStyle1];
            
            
            NSInteger emojiNum = arc4random() % 50;
            
            
            
            for (NSDictionary *keyDict in emojiArray) {
                if (emojiNum == 0) {
                    break;
                }
                
                QPCustomCoreTextImageStringStyle *imageStyle1 = [[QPCustomCoreTextImageStringStyle alloc] init];
                imageStyle1.imageName = [keyDict allValues][0];
                
                attr = [QPCoreTextView appendAttributedString:attr withImageStringStyle:imageStyle1];
                
                emojiNum --;
            }
            
            
            
            QPCoreTextSeniorStringStyle *clickStyle = [QPCoreTextSeniorStringStyle linkSeniorStyleWithForegroupColor:[UIColor orangeColor] urlString:@"http://www.baidu.com/fdsfdsfds/fdsfdsfds/123"];
            
            attr = [QPCoreTextView appendAttributedString:attr withSeniorStringStyle:clickStyle];
            
            QPCoreTextParagraphStyle *paraStyle = [[QPCoreTextParagraphStyle alloc] init];
            paraStyle.lineBreakMode = kCTLineBreakByCharWrapping;
            
            attr = [QPCoreTextView bindingParagraphSetting:attr withParagraphStringStyle:paraStyle];
            
            
            QPCoreTextData *model = [[QPCoreTextData alloc] init];
            model.dataAttributedString = attr;
            
            CGFloat cellHeight = [QPMainVCCell cellHeightWithAttributedString:model.dataAttributedString];
            model.viewSize = NSStringFromCGSize(CGSizeMake(screenSize.width, cellHeight));
            
            model = [QPCoreTextView preLoadCoreTextView:model];
            
            [strongSelf.dataArray addObject:model];
            
            
        }

        
        [QPCacheIntance share].array = strongSelf.dataArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf setupTableView];
            }
        });
        
    });
    
    
}

- (void)setupTableView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 20 , screenSize.width, screenSize.height - 44 - 20) style:UITableViewStylePlain];
    [self.mainTableView setBackgroundColor:[UIColor clearColor]];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:self.mainTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
}

#pragma mark uitableivew methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.mainManager numberOfVideoArray];
    return [self.dataArray count];
}

static NSString *identifier = @"QPLocalPlayListItemCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    QPMainVCCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[QPMainVCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    QPCoreTextData *attr = self.dataArray[indexPath.row];
    
    [cell setDataModel:attr];
    
    return cell;
    

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QPCoreTextData *model = self.dataArray[indexPath.row];
    
    
    
    if (model.viewSize) {
        
        CGSize viewSize = CGSizeFromString(model.viewSize);
        
        NSLog(@"heightforRow %f %@",viewSize.height , model.dataAttributedString.string);
        
        return viewSize.height;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat cellHeight = [QPMainVCCell cellHeightWithAttributedString:model.dataAttributedString];
    model.viewSize = NSStringFromCGSize(CGSizeMake(screenSize.width, cellHeight));
    
    CGSize viewSize = CGSizeFromString(model.viewSize);
    NSLog(@"heightforRow %f %@",viewSize.height , model.dataAttributedString.string);
    
    return cellHeight;
    
    
}

@end
