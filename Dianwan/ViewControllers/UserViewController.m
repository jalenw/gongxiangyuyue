//
//  UserViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/7/19.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "UserViewController.h"
#import "TZImagePickerController.h"
#import "LZHAreaPickerView.h"
#import "LZHDatePickerView.h"
#import "NSDate+Helper.h"
#import "LZHActionSheetView.h"

@interface UserViewController ()
{
    NSString *job_id;
    NSString *area_id;
    NSString *pic_url;
}
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self setupForDismissKeyboard];//只要controller加上此方法，点击空白地方就能收起键盘
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarButtonWithTitle:@"保存"];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (AppDelegateInstance.defaultUser!=nil) {
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:AppDelegateInstance.defaultUser.avatar]];
        self.name.text = AppDelegateInstance.defaultUser.nickname;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)avatarAct:(UIButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self.avatar setImage:[photos firstObject]];
        NSData *imgData = UIImageJPEGRepresentation([photos firstObject], 1);
        [SVProgressHUD show];
        [[ServiceForUser manager] postFileWithActionOp:@"" andData:imgData andUploadFileName:[Tooles getUploadImageName] andUploadKeyName:@"name" and:@"image/jpeg" params:@{} progress:^(NSProgress *uploadProgress) {
            NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        } block:^(NSDictionary *responseObject, NSString *error, BOOL status, NSError *requestFailed) {
            [SVProgressHUD dismiss];
            if (status) {
                pic_url = [responseObject safeStringForKey:@"datas"];
            }
        }];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (IBAction)jobAct:(UIButton *)sender {
    NSArray *array = @[@{@"profession":@"护士",@"id":@"1"},@{@"profession":@"医生",@"id":@"2"},@{@"profession":@"律师",@"id":@"3"},@{@"profession":@"程序员",@"id":@"4"}];
    LZHAreaPickerView *picker = [[LZHAreaPickerView alloc] initWithFrame:ScreenBounds];
    picker.array = array;
    picker.name = @"profession";//对应字典里的KEY就会显示出来
    [picker setBlock:^(NSDictionary *dict) {
        job_id = [dict safeStringForKey:@"id"];
        [sender setTitle:[dict safeStringForKey:@"profession"] forState:UIControlStateNormal];
    }];
    [picker showPicker];
}

- (IBAction)cityAct:(UIButton *)sender {
    //同职业
}

- (IBAction)dateAct:(UIButton *)sender {
    LZHDatePickerView *datePicker = [[LZHDatePickerView alloc] initWithFrame:ScreenBounds];
    datePicker.datePicker.maximumDate = [NSDate date];
    [datePicker setBlock:^(NSDate *date) {
        [self.birthday setTitle:[NSString stringWithFormat:@"%@",[NSDate dateYearStringOfInterval:date.timeIntervalSince1970*1000]] forState:UIControlStateNormal];
    }];
    [datePicker showPicker];
}

- (IBAction)sexAct:(UIButton *)sender {
    LZHActionSheetView *actionSheet = [LZHActionSheetView createWithTitleArray:@[@"女",@"男"]];
    [actionSheet setBlock:^(NSInteger index, NSString *title) {
        if (index == 0) {
            [sender setTitle:@"女" forState:UIControlStateNormal];
        }else if (index == 1){
            [sender setTitle:@"男" forState:UIControlStateNormal];
        }
    }];
    [actionSheet show];
}
@end
