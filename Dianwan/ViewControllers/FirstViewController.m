//
//  FirstViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/1.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "FirstViewController.h"
@interface FirstViewController ()
{
    NSArray *adArray;
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAdView];
    [self.adView setBlock:^(NSInteger index){
        NSDictionary *dict = [adArray objectAtIndex:index];
        CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
        controller.address = [dict safeStringForKey:@"url"];
        controller.showNav = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//获取首页
-(void)setupAdView
{
    [[ServiceForUser manager]postMethodName:@"index" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            adArray = [[data safeDictionaryForKey:@"result"] safeArrayForKey:@"adv_list"];
            NSMutableArray *picArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in adArray) {
                [picArray addObject:[dict safeStringForKey:@"adv_code"]];
            }
            [self.adView setArray:picArray];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
