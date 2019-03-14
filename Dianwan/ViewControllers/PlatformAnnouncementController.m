//
//  PlatformAnnouncementController.m
//  Dianwan
//
//  Created by Yang on 2019/3/13.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "PlatformAnnouncementController.h"

@interface PlatformAnnouncementController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *platTableview;
@property(nonatomic,strong)NSMutableArray *dataList;

@end

@implementation PlatformAnnouncementController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark  懒加载
-(UITableView *)platTableview{
    if (!_platTableview) {
        _platTableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _platTableview.dataSource = self;
        _platTableview.delegate = self;
        
        _platTableview.backgroundColor = [UIColor blueColor];
        [self.view addSubview:_platTableview];
    }
    return _platTableview;
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
