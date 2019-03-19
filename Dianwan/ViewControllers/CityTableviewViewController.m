//
//  CityTableviewViewController.m
//  BaseProject
//
//  Created by Mac on 2018/11/12.
//  Copyright © 2018年 ZNH. All rights reserved.
//

#import "CityTableviewViewController.h"
#import "City2ViewController.h"
#import "cityModel.h"

@interface CityTableviewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *maintableview;
@property(nonatomic,strong)NSMutableArray *cityArr;
@end

@implementation CityTableviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cityArr = [NSMutableArray array];
    
    self.maintableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.maintableview];
    self.maintableview.delegate =self;
    self.maintableview.dataSource =self;
    [self getdata];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstr =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstr];
    }
    
    cityModel *model =self.cityArr[indexPath.row];
    cell.textLabel.text = model.area_name;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
      return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     return self.cityArr.count;
}

//请求省份
-(void)getdata{
    
    [SVProgressHUD show];
    [[ServiceForUser manager]postMethodName:@"http://gongxiang.cn/mobile/area/area_list" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
                NSDictionary *result= [data safeDictionaryForKey:@"result"];
                NSArray *area_list  = [result objectForKey:@"area_list"];
                for (int i=0; i<area_list.count;i++) {
                    cityModel *model =[[cityModel alloc]init];
                    model.area_id = [area_list[i] safeNumberForKey:@"area_id"];
                    model.area_name = [area_list[i] safeStringForKey:@"area_name"];
                   
                    [self.cityArr addObject:model];
                }
               
                [self.maintableview reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
           
       
    }];
//    [HTTPTOOL registerCityListByKey:UserManagerInstance.userInfoModel.key
//                            success:^(id response) {
//                                NSDictionary *result= [response objectForKey:@"result"];
//                                NSArray *area_list  = [result objectForKey:@"area_list"];
//                                for (int i=0; i<area_list.count;i++) {
//                                    cityModel *model = [cityModel mj_objectWithKeyValues:area_list[i]];
//                                    [self.cityArr addObject:model];
//                                }
//
//                                NSLog(@"%d",self.cityArr.count);
//                                [self.maintableview reloadData];
//    } failure:^(NSError *err) {
//        NSLog(@"%@",err);
//    }];
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    cityModel *model =self.cityArr[indexPath.row];
    NSNumber * city_id =  model.area_id;
//    _cityBlock(model);
//    [self requestCityAction:model.area_id];
    City2ViewController *city = [[City2ViewController alloc]initWithcity_id:city_id];
    city.cityBlock  = ^(cityModel *model) {
        _cityBlock(model);
    };
    [self.navigationController pushViewController:city animated:YES];
    
//    [self.navigationController popViewControllerAnimated:YES];
    
}

//请求城市
//-(void)requestCityAction:(NSNumber *)area_id{
//    
//    
//        [HTTPTOOL registerCityListByKey:UserManagerInstance.userInfoModel.key
//                                area_id:area_id
//                                success:^(id response) {
//                                    NSDictionary *result= [response objectForKey:@"result"];
//                                    NSArray *area_list  = [result objectForKey:@"area_list"];
//                                    for (int i=0; i<area_list.count;i++) {
//                                        cityModel *model = [cityModel mj_objectWithKeyValues:area_list[i]];
//                                        [self.cityArr addObject:model];
//                                    }
//                                    
//                                    NSLog(@"%d",self.cityArr.count);
//                                    [self.maintableview reloadData];
//                                } failure:^(NSError *err) {
//                                    NSLog(@"%@",err);
//                                }];
//    
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
