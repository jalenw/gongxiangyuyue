//
//  AddLineViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/19.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddLineViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bts;
@property (weak, nonatomic) IBOutlet UIView *costView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *priceTf;
@property (weak, nonatomic) IBOutlet UITextField *costTf;
- (IBAction)addImgAct:(UIButton *)sender;
- (IBAction)backAct:(UIButton *)sender;
- (IBAction)doneAct:(UIButton *)sender;
- (IBAction)menuAct:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
