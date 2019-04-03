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
#import "FirstHeaderView.h"
@interface FriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
    NSArray *groupsList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    page = 1;
    dataList = [NSMutableArray new];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self getData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        page =1;
        [self getData];
    }];

    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        if (groups.count>0) {
            groupsList = groups;
            [self.tableView reloadData];
        }
    } onQueue:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"first_add"]];
    [self.tableView headerBeginRefreshing];
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
    CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
    controller.address = [NSString stringWithFormat:@"%@%@",web_url,@"dist/chat"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)getData
{
    [[ServiceForUser manager] postMethodName:@"friend/friend_list" params:@{@"page":@(page)} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [dataList removeAllObjects];
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        if (status) {
            [dataList addObjectsFromArray:[data safeArrayForKey:@"result"]];
            [self.tableView reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if (section==0) {
         return groupsList.count;
     }
    else
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
    if (indexPath.section==0) {
        if (groupsList.count>0) {
            EMGroup *group = [groupsList objectAtIndex:indexPath.row];
            cell.name.text = group.groupSubject;
        }
    }
    else
    {
    if (dataList.count>0) {
        NSDictionary *buddy = [dataList objectAtIndex:indexPath.row];
        cell.name.text = [buddy safeStringForKey:@"member_name"];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[buddy safeStringForKey:@"member_avatar"]]];
    }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      if (indexPath.section==0) {
        EMGroup *group = [groupsList objectAtIndex:indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:eConversationTypeGroupChat];
        [self.navigationController pushViewController:chatController animated:YES];
      }
    else
    {
    NSDictionary *buddy = [dataList objectAtIndex:indexPath.row];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:[buddy safeStringForKey:@"friend_id"] conversationType:eConversationTypeChat];
    [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *viewIdentfier = @"FirstHeaderView";
    FirstHeaderView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    if(!sectionHeadView){
        sectionHeadView = [[FirstHeaderView alloc] initWithReuseIdentifier:viewIdentfier];
    }
    if (section==0) {
        sectionHeadView.label.text = @"群聊";
    }
    if (section==1) {
        sectionHeadView.label.text = @"好友";
    }
    return sectionHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

@end
