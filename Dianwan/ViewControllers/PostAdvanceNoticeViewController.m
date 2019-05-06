//
//  PostAdvanceNoticeViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/6.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "PostAdvanceNoticeViewController.h"
#import "LZHDatePickerView.h"
#import "NSDate+Helper.h"
@interface PostAdvanceNoticeViewController ()
{
    NSArray *classList;
    NSDictionary *classDict;
    NSString *pic_url;
    NSTimeInterval timeInterval;
}
@end

@implementation PostAdvanceNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    [self getClassList];
}

-(void)getClassList
{
    [[ServiceForUser manager]postMethodName:@"channelclass/getClassList" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            classList = [data  safeArrayForKey:@"result"];
            [self.tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return classList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"typeCell"];
    }
    if (classList.count>0) {
        NSDictionary *dict = [classList objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict safeStringForKey:@"class_name"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [classList objectAtIndex:indexPath.row];
    classDict = dict;
    self.typeView.hidden = YES;
    self.typeTf.text = [classDict safeStringForKey:@"class_name"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (IBAction)changeTimeAct:(UIButton *)sender {
    LZHDatePickerView *datePicker = [[LZHDatePickerView alloc] initWithFrame:ScreenBounds];
    datePicker.datePicker.maximumDate = [NSDate date];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setBlock:^(NSDate *date) {
        self.timeTf.text = [NSString stringWithFormat:@"%@",[NSDate dateYearDateTimeFormatter:date.timeIntervalSince1970*1000]];
        timeInterval = date.timeIntervalSince1970;
    }];
    [datePicker showPicker];
}

- (IBAction)chooseTypeAct:(UIButton *)sender {
    self.typeView.hidden = NO;
}

- (IBAction)closeTypeViewAct:(UIButton *)sender {
    self.typeView.hidden = YES;
}

- (IBAction)confirmTypeAct:(UIButton *)sender {
    self.typeView.hidden = YES;
}

- (IBAction)backAct:(UIButton *)sender {
    [super back];
}
- (IBAction)addPicAct:(UIButton *)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相机", @"从手机相册选择", nil];
    [choiceSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照，&& [self doesCameraSupportTakingPhotos] 支持c相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {//设置后摄像头
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imgData = UIImageJPEGRepresentation(portraitImg, 1);
    [SVProgressHUD show];
    [[ServiceForUser manager] postFileWithActionOp:@"common/upload_header_img" andData:imgData andUploadFileName:[Tooles getUploadImageName] andUploadKeyName:@"img" and:@"image/jpeg" params:@{} progress:^(NSProgress *uploadProgress) {
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } block:^(NSDictionary *responseObject, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            pic_url = [[responseObject safeDictionaryForKey:@"result"] safeStringForKey:@"img_name"];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.pic sd_setImageWithURL:[NSURL URLWithString:pic_url]];
            }];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAct:(UIButton *)sender {
    if (pic_url.length==0) {
        [AlertHelper showAlertWithTitle:@"请上传封面图片"];
        return;
    }
    if (self.nameTf.text.length==0) {
        [AlertHelper showAlertWithTitle:@"请输入标题"];
        return;
    }
    if (classDict==nil) {
        [AlertHelper showAlertWithTitle:@"请选择类别"];
        return;
    }
    if (timeInterval==0) {
        [AlertHelper showAlertWithTitle:@"请选择预告时间"];
        return;
    }
    if (self.descTv.text.length==0) {
        [AlertHelper showAlertWithTitle:@"请填写简介"];
        return;
    }
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"channelforeshow/addForeshow" params:@{@"title":self.nameTf.text,@"cover":pic_url,@"content":self.descTv.text,@"channel_time":@(timeInterval),@"channel_class_id":[classDict safeStringForKey:@"channels_class_id"]} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshAdvanceNoticeList" object:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}
@end
