//
//  QPMainViewController.m
//  CoreTextDemo
//
//  Created by Li Yi on 15/10/5.
//  Copyright (c) 2015年 Li Yi. All rights reserved.
//

#import "QPMainViewController.h"
#import "QPListViewController.h"
#import "DetailViewController.h"
@interface QPMainViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mainTableView;

@end

@implementation QPMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark private methods

- (void)setupTableView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 20 , screenSize.width, screenSize.height) style:UITableViewStylePlain];
    [self.mainTableView setBackgroundColor:[UIColor clearColor]];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:self.mainTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
}

#pragma mark uitableview methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

static NSString *identifier = @"QPMenuCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"单个"];
    }
    else if(indexPath.row == 1)
    {
        [cell.textLabel setText:@"列表"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (indexPath.row == 1)
    {
        QPListViewController *myVC = [[QPListViewController alloc] init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
}

@end
