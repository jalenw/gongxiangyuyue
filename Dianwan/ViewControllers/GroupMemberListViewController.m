//
//  GroupMemberListViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/6.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "GroupMemberListViewController.h"
#import "FriendListCell.h"
#import "ChatViewController.h"
@interface GroupMemberListViewController ()
{
    NSMutableArray *dataList;
}
@end

@implementation GroupMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群成员";
    dataList = [[NSMutableArray alloc]init];
    [self getData];
}

-(void)getData
{
    [[ServiceForUser manager] postMethodName:@"member/getGroupList" params:@{@"group_id":self.group_id} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            [dataList addObjectsFromArray:[data safeArrayForKey:@"result"]];
            [self.tableView reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return dataList.count;
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

        if (dataList.count>0) {
            NSDictionary *buddy = [dataList objectAtIndex:indexPath.row];
            cell.name.text = [buddy safeStringForKey:@"member_name"];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:[buddy safeStringForKey:@"member_avatar"]]];
        }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

        NSDictionary *buddy = [dataList objectAtIndex:indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:[buddy safeStringForKey:@"chat_id"] conversationType:eConversationTypeChat];
        [self.navigationController pushViewController:chatController animated:YES];
    
}

@end
