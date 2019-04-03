//
//  PostYueJiaViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/4/3.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "PostYueJiaViewController.h"

@interface PostYueJiaViewController ()
{
    int payType;
}
@end

@implementation PostYueJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布约单";
    [self setupForDismissKeyboard];
}

- (IBAction)typeAct:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付方式选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *imagelibaray = [UIAlertAction actionWithTitle:@"线下支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        payType = 1;
        [self.bt setTitle:@"线下支付" forState:UIControlStateNormal];
    }];
    UIAlertAction *camare = [UIAlertAction actionWithTitle:@"线上支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        payType = 2;
        [self.bt setTitle:@"线上支付" forState:UIControlStateNormal];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:imagelibaray];
    [alertController addAction:camare];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)doneAct:(UIButton *)sender {
    if (self.name.text.length==0) {
        [AlertHelper showAlertWithTitle:@"请输入标题"];
        return;
    }
    if (payType==0) {
        [AlertHelper showAlertWithTitle:@"请选择支付方式"];
        return;
    }
    if (self.marketPrice.text.length==0) {
        [AlertHelper showAlertWithTitle:@"请输入市场价"];
        return;
    }
    if (self.cost.text.length==0) {
        [AlertHelper showAlertWithTitle:@"请输入成本价"];
        return;
    }
    if (self.desc.text.length==0) {
        [AlertHelper showAlertWithTitle:@"请输入描述"];
        return;
    }
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"ordery/addorder" params:@{@"chat_id":self.chat_id,@"title":self.name.text,@"intro":self.desc.text,@"price":self.marketPrice.text,@"cost_price":self.cost.text,@"pay_type":@(payType-1)} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            [AlertHelper showAlertWithTitle:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}
@end
