//
//  FriendsViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendListCell.h"
#import "ChatViewController.h"
@interface FriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    
    [[ServiceForUser manager] postMethodName:@"mobile/friend/friend_list" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            self.data = [data safeArrayForKey:@"result"];
            [self.tableView reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"first_add"]];
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
    CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
    controller.address = [NSString stringWithFormat:@"%@%@",web_url,@"dist/chat"];
    [self.navigationController pushViewController:controller animated:YES];
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
    NSDictionary *buddy = [self.data objectAtIndex:indexPath.row];
    cell.name.text = [buddy safeStringForKey:@"member_name"];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[buddy safeStringForKey:@"member_avatar"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *buddy = [self.data objectAtIndex:indexPath.row];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:[buddy safeStringForKey:@"friend_id"] conversationType:eConversationTypeChat];
    [self.navigationController pushViewController:chatController animated:YES];
}
@end
