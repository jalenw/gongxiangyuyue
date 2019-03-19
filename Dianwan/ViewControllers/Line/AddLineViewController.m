//
//  AddLineViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/19.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "AddLineViewController.h"

@interface AddLineViewController ()

@end

@implementation AddLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)addImgAct:(UIButton *)sender {
}

- (IBAction)backAct:(UIButton *)sender {
    [super back];
}

- (IBAction)doneAct:(UIButton *)sender {
}

- (IBAction)menuAct:(UIButton *)sender {
}
@end
