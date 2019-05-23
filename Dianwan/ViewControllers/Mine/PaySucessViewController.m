//
//  PaySucessViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "PaySucessViewController.h"

@interface PaySucessViewController ()

@end

@implementation PaySucessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.btText) {
        [self.bt setTitle:self.btText forState:UIControlStateNormal];
    }
}

- (IBAction)toWhereAct:(UIButton *)sender {
    if (self.block) {
        [self.navigationController popViewControllerAnimated:YES];
        self.block();
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
