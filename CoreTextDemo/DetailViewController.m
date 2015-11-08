//
//  DetailViewController.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/9/25.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "DetailViewController.h"
#import "QPCoreTextView.h"
#import <CoreText/CoreText.h>
#import "QPCoreTextImageStringStyle.h"
@interface DetailViewController ()<QPCoreTextViewDelegate>

@end

@implementation DetailViewController

#pragma mark - Managing the detail item



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self testCoreText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)testCoreText
{
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
    
    QPCoreTextImageStringStyle *imageStyle1 = [[QPCoreTextImageStringStyle alloc] init];
    imageStyle1.imageName = @"001[憨笑]";
    
    attr = [QPCoreTextView appendAttributedString:attr withImageStringStyle:imageStyle1];

    QPCoreTextSeniorStringStyle *clickStyle = [QPCoreTextSeniorStringStyle linkSeniorStyleWithForegroupColor:[UIColor orangeColor] urlString:@"http://www.baidu.com"];
    
    attr = [QPCoreTextView appendAttributedString:attr withSeniorStringStyle:clickStyle];
    
    QPCoreTextParagraphStyle *paraStyle = [[QPCoreTextParagraphStyle alloc] init];
    paraStyle.lineBreakMode = kCTLineBreakByCharWrapping;
    
    attr = [QPCoreTextView bindingParagraphSetting:attr withParagraphStringStyle:paraStyle];
    
    
    CGSize contentSize = [QPCoreTextView contentSizeFromWidth:220 attributeString:attr];
    
    
    QPCoreTextView *myView = [[QPCoreTextView alloc] initWithFrame:CGRectMake(100, 300, contentSize.width, contentSize.height) attributeString:attr];
    [myView setDelegate:self];

    
    QPCoreTextRegexStringStyle *regexStyle = [QPCoreTextRegexStringStyle linkRegexStyleWithForegroupColor:[UIColor blueColor]];
    
    [myView replaceWithRegexStyle:regexStyle];
    
    [self.view addSubview:myView];
    
    NSLog(@"x : %f , y : %f",contentSize.width,contentSize.height);

}



- (void)coreTextView:(QPCoreTextView *)coreTextView selectWithContentType:(NSString *)contentType contentString:(NSString *)contentString
{
    NSLog(@"contentType : %@ contentString : %@",contentType,contentString);
}
@end
