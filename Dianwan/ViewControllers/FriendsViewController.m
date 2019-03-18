//
//  FriendsViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendListCell.h"
@interface FriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            NSLog(@"获取成功 -- %@",buddyList);
        }
    } onQueue:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"FriendListCell" owner:self options:nil][0];
    }
    NSDictionary *dict = [self.data objectAtIndex:indexPath.row];
    cell.name.text = [dict safeStringForKey:@"member_name"];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"member_avatar"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
