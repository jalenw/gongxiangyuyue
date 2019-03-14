//
//  SystemMessageViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/13.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "SystemMessageViewController.h"

@interface SystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *systemTableview;
@property(nonatomic,strong)NSMutableArray *dataList;

@end

@implementation SystemMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark  懒加载
-(UITableView *)platTableview{
    if (!_systemTableview) {
        _systemTableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _systemTableview.dataSource = self;
        _systemTableview.delegate = self;
        _systemTableview.backgroundColor = [UIColor redColor];
        [self.view addSubview:_systemTableview];
    }
    return _systemTableview;
}
-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


#pragma mark -UITableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end

