//
//  SystemMsgViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/7/31.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "SystemMsgViewController.h"
#import "SystemMsgTableViewCell.h"

@interface SystemMsgViewController ()
{
    NSArray *array;
}
@end

@implementation SystemMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    [[ServiceForUser manager]postMethodName:@"" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            array = [[data safeDictionaryForKey:@"datas"] safeArrayForKey:@""];
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    return [SystemMsgTableViewCell heightForSystemMsgTableViewCell: [dict safeStringForKey:@"push_message"]];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemMsgTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SystemMsgTableViewCell" owner:self options:nil][0];
    }
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    cell.name.text = [dict safeStringForKey:@"push_title"];
    cell.time.text = [dict safeStringForKey:@"push_time"];
    cell.content.text = [dict safeStringForKey:@"push_message"];
    cell.content.height = [Tooles calculateTextHeight:ScreenWidth-16 Content:[dict safeStringForKey:@"push_message"] fontSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
