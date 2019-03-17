//
//  FirstViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/1.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "FirstViewController.h"
#import "MenuCollectionViewCell.h"
#import "GYRollingNoticeView.h"
#import "HMScannerController.h"
#import "QRCodeViewController.h"
@interface FirstViewController ()<GYRollingNoticeViewDataSource, GYRollingNoticeViewDelegate>
{
    NSArray *adArray;
    NSArray *menuList;
    NSArray *noticeList;
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth, 636)];
    [self setupAdView];
    [self.adView setBlock:^(NSInteger index){
        NSDictionary *dict = [adArray objectAtIndex:index];
        CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
        controller.address = [dict safeStringForKey:@"url"];
        controller.showNav = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.itemSize = CGSizeMake(ScreenWidth/4,180/2);
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    [self.collectionView setCollectionViewLayout:_layout];
    
    [self setupNoticeView];
    [self setupGoldView];
    
    [self.smView setArray: @[@{@"name":@"我的推荐码",@"image":@"first_code"},@{@"name":@"平台说明",@"image":@"first_?"}]];
    [self.smView setBlock:^(NSInteger index) {
        self.maskView.hidden = YES;
        if (index==0) {
            QRCodeViewController *vc = [[QRCodeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
            controller.address = [NSString stringWithFormat:@"%@wap/mall/info.html?article_id=51",web_url];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLeftBarButtonWithImage:[UIImage imageNamed:@"first_qr"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"first_add"]];
}

-(void)leftbarButtonDidTap:(UIButton *)button
{
    HMScannerController *scanner = [HMScannerController scannerWithCardName:@"" avatar:@"" completion:^(NSString *stringValue) {
    }];
    [scanner setTitleColor:[UIColor blackColor] tintColor:[UIColor greenColor]];
    [self showDetailViewController:scanner sender:nil];
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
    self.maskView.hidden = !self.maskView.hidden;
}

-(void)setupAdView
{
    [[ServiceForUser manager]postMethodName:@"index" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            adArray = [[data safeDictionaryForKey:@"result"] safeArrayForKey:@"adv_list"];
            menuList = [[data safeDictionaryForKey:@"result"] safeArrayForKey:@"nav_list"];
            [self.collectionView reloadData];
            NSMutableArray *picArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in adArray) {
                [picArray addObject:[dict safeStringForKey:@"adv_code"]];
            }
            [self.adView setArray:picArray];
        }
    }];
}

-(void)setupNoticeView
{
    GYRollingNoticeView *nv = [[GYRollingNoticeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-62, self.noticeView.height)];
    nv.dataSource = self;
    nv.delegate = self;
    [nv registerClass:[GYNoticeViewCell class] forCellReuseIdentifier:@"GYNoticeViewCell"];
    [self.noticeView addSubview:nv];
    [[ServiceForUser manager]postMethodName:@"index/getnoticelist" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            noticeList = [data safeArrayForKey:@"result"];
            [nv reloadDataAndStartRoll];
        }
    }];
}

-(void)setupGoldView
{
    [[ServiceForUser manager]postMethodName:@"terrace/index" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            self.cashLb.text = [[[data safeDictionaryForKey:@"result"] safeDictionaryForKey:@"cash"] safeStringForKey:@"value"];
            self.rewardLb.text = [[[data safeDictionaryForKey:@"result"] safeDictionaryForKey:@"gold"] safeStringForKey:@"value"];
        }
    }];
}

- (NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView
{
    return noticeList.count;
}

- (__kindof GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index
{
    GYNoticeViewCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"GYNoticeViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [noticeList[index] safeStringForKey:@"title"]];
    return cell;
}

- (void)didClickRollingNoticeView:(GYRollingNoticeView *)rollingView forIndex:(NSUInteger)index
{

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return menuList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"MenuCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"MenuCollectionViewCell"];
    MenuCollectionViewCell *cell = [[MenuCollectionViewCell alloc]init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"MenuCollectionViewCell"
                                                     forIndexPath:indexPath];
    NSDictionary *dict = [menuList objectAtIndex:indexPath.row];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"adv_code"]]];
    cell.name.text = [dict safeStringForKey:@"adv_title"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = menuList[indexPath.row];
    NSString *link = [dict safeStringForKey:@"adv_link"];
    if (link.length>0) {
        CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
        controller.address = [NSString stringWithFormat:@"%@%@",web_url,link];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)noticeAct:(UIButton *)sender {
    CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
    controller.address = [NSString stringWithFormat:@"%@dist/text/list",web_url];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goldAct:(UIButton *)sender {
    CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
    controller.address = [NSString stringWithFormat:@"%@wap/mall/text_ul.html",web_url];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
